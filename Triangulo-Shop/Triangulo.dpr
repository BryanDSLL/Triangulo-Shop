program Triangulo;

uses
  Windows,
  Vcl.Forms,
  System.SysUtils,
  System.StartUpCopy,
  UfrmTriangulo in 'UfrmTriangulo.pas' {frmTriangulo},
  uConexao in 'uConexao.pas' {dtmConexao: TDataModule},
  Triangulo.dxSettings in 'Triangulo.dxSettings.pas',
  URelatorio in 'URelatorio.pas' {frmRelatorio};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTriangulo, frmTriangulo);
  Application.CreateForm(TdtmConexao, dtmConexao);
  Application.Run;
end.
