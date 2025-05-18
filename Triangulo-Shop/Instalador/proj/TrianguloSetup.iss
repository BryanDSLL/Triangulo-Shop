[Setup]
AppName=Triangulo
AppVersion=1.0
DefaultDirName={pf}\Triangulo
DefaultGroupName=Triangulo
OutputDir=.
OutputBaseFilename=InstaladorTriangulo
Compression=lzma
SolidCompression=yes

[Files]
Source: "C:\Users\bryan\Desktop\.CODE\proj\Triangulo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryan\Desktop\.CODE\proj\Biblioteca\*"; DestDir: "{app}\Biblioteca"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\bryan\Desktop\.CODE\proj\resource\*"; DestDir: "{app}\resource"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\bryan\Desktop\.CODE\proj\base\*"; DestDir: "{app}\base"; Flags: ignoreversion recursesubdirs createallsubdirs

[Tasks]
Name: "desktopicon"; Description: "Criar atalho na área de trabalho"; GroupDescription: "Opções adicionais:"

[Icons]
Name: "{group}\Triangulo"; Filename: "{app}\Triangulo.bat"; IconFilename: "{app}\resource\icon.ico"
Name: "{commondesktop}\Triangulo"; Filename: "{app}\Triangulo.bat"; IconFilename: "{app}\resource\icon.ico"; Tasks: desktopicon
Name: "{group}\Desinstalar Triangulo"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\Triangulo.bat"; Description: "Executar Triangulo com dependências"; Flags: shellexec nowait postinstall

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  BatFile: string;
  BatContent: string;
begin
  if CurStep = ssPostInstall then
  begin
    BatFile := ExpandConstant('{app}\Triangulo.bat');
    BatContent := '@echo off' + #13#10 +
                  'set PATH=%PATH%;%~dp0Biblioteca' + #13#10 +
                  'start "" "%~dp0Triangulo.exe"';
    SaveStringToFile(BatFile, BatContent, False);
  end;
end;
