program Triangulos;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Form1},
  TipoTriangulo in 'TipoTriangulo.pas',
  TrianguloFactory in 'TrianguloFactory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
