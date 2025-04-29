unit frmTriangulo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Horse, Horse.Request, Horse.Response,
  System.Threading, System.Net.HttpClient, System.Net.HttpClientComponent, FireDAC.Comp.Client,
  System.Net.URLClient, System.JSON, System.DateUtils, System.Generics.Collections;

type

  TMensagemRegistro = class
    Mensagem: string;
    Lado1: string;
    Lado2: string;
    Lado3: string;
    DataHora: TDateTime;
  end;

  TForm1 = class(TForm)
    lblLado1: TLabel;
    edtLado1: TEdit;
    lblLado2: TLabel;
    edtLado2: TEdit;
    lblLado3: TLabel;
    edtLado3: TEdit;
    btnCalcular: TButton;
    lblTipoTriangulo: TLabel;
    Image1: TImage;
    procedure edtLado1KeyPress(Sender: TObject; var Key: Char);
    procedure edtLado2KeyPress(Sender: TObject; var Key: Char);
    procedure edtLado3KeyPress(Sender: TObject; var Key: Char);
    procedure btnCalcularClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
    function ValidarEdits(Edits: array of TEdit): Boolean;
    procedure EnviarRegistro(const Mensagem, Lado1, Lado2, Lado3: string; Now: TDateTime);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MensagensRecebidas: TObjectList<TMensagemRegistro>;

implementation

{$R *.dfm}

uses uConexao;

{$REGION 'FUNÇÕES'}
function TForm1.ValidarEdits(Edits: array of TEdit): Boolean;
var
  i, valor: Integer;
begin
  Result := True;

  for i := Low(Edits) to High(Edits) do
  begin

    if Trim(Edits[i].Text) = '' then
    begin
      ShowMessage('Preencha todos os campos.');
      Edits[i].SetFocus;
      Result := False;
      Exit;
    end;

    if not TryStrToInt(Edits[i].Text, valor) then
    begin
      ShowMessage('Digite um número válido no campo ' + Edits[i].Name);
      Edits[i].SetFocus;
      Result := False;
      Exit;
    end;

    if valor <= 0 then
    begin
      ShowMessage('Os valores devem ser maiores que 0.');
      Edits[i].SetFocus;
      Result := False;
      Exit;
    end;
  end;
end;


procedure TForm1.EnviarRegistro(const Mensagem, Lado1, Lado2, Lado3: string; Now: TDateTime);
begin
  TTask.Run(
    procedure
    var
      HttpClient: TNetHTTPClient;
      Response: IHTTPResponse;
      StringStream: TStringStream;
    begin
      HttpClient := TNetHTTPClient.Create(nil);
      try
        StringStream := TStringStream.Create(
              '{"mensagem":"' + Mensagem + '",' +
                '"lado1": "' + Lado1 + '",' +
                '"lado2": "' + Lado2 + '",' +
                '"lado3": "' + Lado3 + '",' +
                '"datetime": "' + DateToISO8601(Now, True) + '"}',
  TEncoding.UTF8
);
        try
          Response := HttpClient.Post('http://localhost:9000/registrar', StringStream, nil, [
            TNameValuePair.Create('Content-Type', 'application/json')
          ]);

          TThread.Synchronize(nil,
            procedure
            begin
              if Response.StatusCode = 200 then
                ShowMessage('Registro enviado com sucesso!')
              else
                ShowMessage('Erro ao enviar registro: ' + Response.StatusText);
            end
          );
        finally
          StringStream.Free;
        end;
      finally
        HttpClient.Free;
      end;
    end
  );
end;

{$ENDREGION}

{$REGION 'CREATE DO FORM E CONEXÃO COM A API/BD'}
procedure TForm1.FormCreate(Sender: TObject);
begin

  if not Assigned(dtmConexao) then
    dtmConexao := TdtmConexao.Create(Self);

  dtmConexao.Conectar;

  MensagensRecebidas := TObjectList<TMensagemRegistro>.Create(True);


THorse.Post('/registrar',
  procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    Mensagem: string;
    Lado1, Lado2, Lado3: string;
    DataHora: TDateTime;
    JsonBody: TJSONObject;
  begin
    JsonBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
    try
      if Assigned(JsonBody) then
      begin
        Mensagem := JsonBody.GetValue<string>('mensagem');
        Lado1 := JsonBody.GetValue<string>('lado1');
        Lado2 := JsonBody.GetValue<string>('lado2');
        Lado3 := JsonBody.GetValue<string>('lado3');
        DataHora := ISO8601ToDate(JsonBody.GetValue<string>('datetime'));

        TThread.Synchronize(nil,
          procedure
          begin
            var Registro: TMensagemRegistro;
              Registro := TMensagemRegistro.Create;
              Registro.Mensagem := Mensagem;
              Registro.Lado1 := Lado1;
              Registro.Lado2 := Lado2;
              Registro.Lado3 := Lado3;
              Registro.DataHora := DataHora;

              MensagensRecebidas.Add(Registro);


            ShowMessage('Mensagem recebida na API: ' + Mensagem);
          end
        );

        Res.Send('Registro recebido!');
      end
      else
        Res.Status(400).Send('JSON inválido.');
    finally
      JsonBody.Free;
    end;
  end
);


THorse.Get('/lista',
  procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
    JsonArray: TJSONArray;
    Obj: TMensagemRegistro;
    JsonObj: TJSONObject;
  begin
    JsonArray := TJSONArray.Create;
    try
      for Obj in MensagensRecebidas do
      begin
        JsonObj := TJSONObject.Create;
        JsonObj.AddPair('mensagem', Obj.Mensagem);
        JsonObj.AddPair('lado1', Obj.Lado1);
        JsonObj.AddPair('lado2', Obj.Lado2);
        JsonObj.AddPair('lado3', Obj.Lado3);
        JsonObj.AddPair('datetime', DateToISO8601(Obj.DataHora));
        JsonArray.AddElement(JsonObj);
      end;

      Res.Send(JsonArray.ToString);
    finally
      JsonArray.Free;
    end;
  end
);

THorse.Listen(9000);
end;

{$ENDREGION}

{$REGION 'TRATAMENTO DOS EDITS'}
procedure SomenteNumeros(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;


procedure TForm1.edtLado1KeyPress(Sender: TObject; var Key: Char);
begin
  SomenteNumeros(Sender, Key);
end;


procedure TForm1.edtLado2KeyPress(Sender: TObject; var Key: Char);
begin
  SomenteNumeros(Sender, Key);
end;


procedure TForm1.edtLado3KeyPress(Sender: TObject; var Key: Char);
begin
  SomenteNumeros(Sender, Key);
end;
{$ENDREGION}

{$REGION 'FUNCIONAMENTO E REQUISIÇÃO NA API'}
procedure TForm1.btnCalcularClick(Sender: TObject);
var
  a, b, c : Double;
begin
    if ValidarEdits([edtLado1, edtLado2, edtLado3]) then
      begin
        a := StrToFloat(edtLado1.Text);
        b := StrToFloat(edtLado2.Text);
        c := StrToFloat(edtLado3.Text);

        if (a + b > c) and
           (a + c > b) and
           (b + c > a)
        then
          begin
            //ShowMessage('É um triângulo');

            if (a = b) and (b = c) then
              begin
                //ShowMessage('Triângulo Equilátero')
                lblTipoTriangulo.Caption := 'Triângulo Equilátero';
                Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'resource\equilátero.png');
                EnviarRegistro('Triângulo Equilátero', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
                dtmConexao.InserirRegistro('Triângulo Equilátero', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
              end

            else if ((a = b) and (b <> c)) or
                    ((a = c) and (b <> c)) or
                    ((b = c) and (a <> b)) then
              begin
                //ShowMessage('Triângulo Isósceles');
                lblTipoTriangulo.Caption := 'Triângulo Isósceles';
                Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'resource\isósceles.png');
                EnviarRegistro('Triângulo Isósceles', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
                dtmConexao.InserirRegistro('Triângulo Isósceles', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
              end

            else
              begin
                //ShowMessage('Triângulo Escaleno');
                lblTipoTriangulo.Caption := 'Triângulo Escaleno';
                Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'resource\escaleno.png');
                EnviarRegistro('Triângulo Escaleno', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
                dtmConexao.InserirRegistro('Triângulo Escaleno', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
              end
          end
        else
          begin
            ShowMessage('Não é um triângulo, coloque medidas válidas!');
            Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'resource\ximage.png');
            EnviarRegistro('Não é um triângulo!', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
            dtmConexao.InserirRegistro('Não é um triângulo!', edtLado1.Text, edtLado2.Text, edtLado3.Text, Now);
          end;
      end;
end;
{$ENDREGION}




// ------------------------------------------------- //
procedure TForm1.FormDestroy(Sender: TObject);
begin
  MensagensRecebidas.Free;
end;

end.
