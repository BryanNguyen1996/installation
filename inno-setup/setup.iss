; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Demo App"
#define MyAppVersion "1.0"
#define MyAppPublisher "VMO"
#define MyAppURL "https://www.vmo.com/"
#define AppId "947715C9-EAD4-44A0-AF0D-A6F380A1088F"
#define MariaDB "database"
#define Nginx "nginx"
#define SourceDir "..\windows-build"
#define AppInstallerName "setup"
#define OutputDirectory "..\windows-installer"

[Setup]
DisableWelcomePage=no
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#AppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
UninstallDisplayName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequired=admin 
PrivilegesRequiredOverridesAllowed=commandline
OutputDir={#OutputDirectory}
OutputBaseFilename={#AppInstallerName}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
LicenseFile=license.txt

[Messages]
WelcomeLabel2=This will install {#MyAppName} ({#MyAppVersion}) on your computer.
ClickNext=
FinishedLabelNoIcons=Setup has finished installing {#MyAppName} ({#MyAppVersion}) on your computer.
ConfirmUninstall=Are you sure you want to completely remove %1 and all of its components on this computer?
WizardInstalling=Installing {#MyAppName} ({#MyAppVersion})
InstallingLabel=The program features you selected are being installed.
UninstallAppFullTitle=Uninstall %1
StatusUninstalling=Uninstalling {#MyAppName} ({#MyAppVersion}) %n%n The program are being uninstalled. %n%n%n%n Status: Uninstalling %1...
; *** Installation status messages
StatusClosingApplications=Status: Closing applications...
StatusCreateDirs=Status: Creating directories...
StatusExtractFiles=Status: Extracting files...
StatusCreateIcons=Status: Creating shortcuts...
StatusCreateIniEntries=Status: Creating INI entries...
StatusCreateRegistryEntries=Status: Creating registry entries...
StatusRegisterFiles=Status: Registering files...
StatusSavingUninstall=Status: Saving uninstall information...
StatusRunProgram=Status: Finishing installation...
StatusRestartingApplications=Status: Restarting applications...
StatusRollback=Status: Rolling back changes..

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"


[Files]
Source: "{#SourceDir}\mariadb.exe"; Flags: dontcopy
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Code]
var
  DatabasePage: TWizardPage;
  HostEdit, PortEdit, UserEdit, DatabaseEdit: TNewEdit;
  PasswordEdit: TPasswordEdit;

procedure TNewEditOnlyNumberKeyPress(Sender: TObject; var Key: Char);
var
  KeyCode: Integer;
begin
  // allow only numbers
  KeyCode := Ord(Key);
  if not ((KeyCode = 8) or ((KeyCode >= 48) and (KeyCode <= 57))) then
    Key := #0;
end;

procedure UpdateNextButtonState;
begin
  WizardForm.NextButton.Enabled := (Length(Trim(HostEdit.Text)) > 0) and (Length(Trim(PortEdit.Text)) > 0) and (Length(Trim(UserEdit.Text)) > 0) and (Length(Trim(PasswordEdit.Text)) > 0) and (Length(Trim(DatabaseEdit.Text)) > 0);
end;

procedure TextEditOnChange(Sender: TObject);
begin
  UpdateNextButtonState;
end;

procedure CreateText(ALeft, ATop: Integer; ACaption: String);
var
  StaticText: TNewStaticText;
begin
  StaticText := TNewStaticText.Create(WizardForm);
  StaticText.Parent := WizardForm;
  StaticText.Left := 0;
  StaticText.Top := WizardForm.NextButton.Top;
  StaticText.Height := StaticText.Height + ScaleY(8);
  StaticText.Font.Size := 8;
  StaticText.Caption := ACaption;
  StaticText.WordWrap := True;
  StaticText.AutoSize := True;
  StaticText.Parent := WizardForm.WelcomePage;
end;

procedure InitializeWizard();
var
  Left, LeftInc, Top, TopInc: Integer;
  HostLabel, PortLabel, UserLabel, PasswordLabel, DatabaseLabel: TNewStaticText;
  StaticText: TNewStaticText;
  DescriptionStaticText: TNewStaticText;
  SubDescriptionStaticText: TNewStaticText;
begin
  Left := WizardForm.WelcomeLabel2.Left;
  LeftInc := WizardForm.CancelButton.Width + ScaleX(8);
  TopInc := WizardForm.CancelButton.Height + ScaleY(8);
  Top := WizardForm.WelcomeLabel2.Top + WizardForm.WelcomeLabel2.Height - 4*TopInc;

  CreateText(Left, Top, 'To ensure the installation of {#MyAppName} is carried out smoothly, please exit all running browsers before continuing.' + #13#10 + ''+ #13#10 + '');

  // Create a custom page for database connection details
  DatabasePage := CreateInputQueryPage(wpSelectDir, 'Connect Database',
    'Which is the connected database?', '');

  WizardForm.NextButton.Enabled := False;
   // text description
  DescriptionStaticText := TNewStaticText.Create(DatabasePage);
  DescriptionStaticText.Top := 0;
  DescriptionStaticText.Left := 0;
  DescriptionStaticText.Caption := 'Demo App will be connected to the database based on following configurations.';
  DescriptionStaticText.Font.Style := [fsBold];
  DescriptionStaticText.Parent := DatabasePage.Surface;

  SubDescriptionStaticText := TNewStaticText.Create(DatabasePage);
  SubDescriptionStaticText.Top := DescriptionStaticText.Top + DescriptionStaticText.Height + ScaleY(11);
  SubDescriptionStaticText.Left := 0;
  SubDescriptionStaticText.Caption := 'To continue, please fill all the required information and click Next.';
  SubDescriptionStaticText.Parent := DatabasePage.Surface;

  // Add host input label
  HostLabel := TNewStaticText.Create(DatabasePage);
  HostLabel.Top := SubDescriptionStaticText.Top + SubDescriptionStaticText.Height + ScaleY(20) + ScaleY(3);
  HostLabel.Left := 0;
  HostLabel.Caption := 'Host';
  HostLabel.AutoSize := True;
  HostLabel.Parent := DatabasePage.Surface;
  // text required
  StaticText := TNewStaticText.Create(DatabasePage);
  StaticText.Top := SubDescriptionStaticText.Top + SubDescriptionStaticText.Height + ScaleY(20) + ScaleY(3);
  StaticText.Left := HostLabel.Width;
  StaticText.Caption := '*';
  StaticText.Font.Color := clRed;
  StaticText.Parent := DatabasePage.Surface;
  // Add host input field
  HostEdit := TNewEdit.Create(DatabasePage);
  HostEdit.Top := SubDescriptionStaticText.Top + SubDescriptionStaticText.Height + ScaleY(20);
  HostEdit.Parent := DatabasePage.Surface;
  HostEdit.text := 'localhost';

  // Add port input label
  PortLabel := TNewStaticText.Create(DatabasePage);
  PortLabel.Top := HostEdit.Top + HostEdit.Height + ScaleY(11);
  PortLabel.Left := 0;
  PortLabel.Caption := 'Port';
  PortLabel.AutoSize := True;
  PortLabel.Parent := DatabasePage.Surface;
  // text required
  StaticText := TNewStaticText.Create(DatabasePage);
  StaticText.Top := HostEdit.Top + HostEdit.Height + ScaleY(11);
  StaticText.Left := PortLabel.Width;
  StaticText.Caption := '*';
  StaticText.Font.Color := clRed;
  StaticText.Parent := DatabasePage.Surface;
  // Add port input field
  PortEdit := TNewEdit.Create(DatabasePage);
  PortEdit.Parent := DatabasePage.Surface;
  PortEdit.Top := HostEdit.Top + HostEdit.Height + ScaleY(8);
  PortEdit.text := '3306';

  // Add Username input label
  UserLabel := TNewStaticText.Create(DatabasePage);
  UserLabel.Top := PortEdit.Top + PortEdit.Height + ScaleY(11);
  UserLabel.Left := 0;
  UserLabel.Caption := 'Username';
  UserLabel.AutoSize := True;
  UserLabel.Parent := DatabasePage.Surface;
  // text required
  StaticText := TNewStaticText.Create(DatabasePage);
  StaticText.Top := PortEdit.Top + PortEdit.Height + ScaleY(11);
  StaticText.Left := UserLabel.Width;
  StaticText.Caption := '*';
  StaticText.Font.Color := clRed;
  StaticText.Parent := DatabasePage.Surface;
  // Add Username input field
  UserEdit := TNewEdit.Create(DatabasePage);
  UserEdit.Parent := DatabasePage.Surface;
  UserEdit.Top := PortEdit.Top + PortEdit.Height + ScaleY(8);

  // Add password input label
  PasswordLabel := TNewStaticText.Create(DatabasePage);
  PasswordLabel.Top := UserEdit.Top + UserEdit.Height + ScaleY(11);
  PasswordLabel.Left := 0;
  PasswordLabel.Caption := 'Password';
  PasswordLabel.AutoSize := True;
  PasswordLabel.Parent := DatabasePage.Surface;
  // text required
  StaticText := TNewStaticText.Create(DatabasePage);
  StaticText.Top := UserEdit.Top + UserEdit.Height + ScaleY(11);
  StaticText.Left := PasswordLabel.Width;
  StaticText.Caption := '*';
  StaticText.Font.Color := clRed;
  StaticText.Parent := DatabasePage.Surface;
  // Add password input field
  PasswordEdit := TPasswordEdit.Create(DatabasePage);
  PasswordEdit.Parent := DatabasePage.Surface;
  PasswordEdit.Top := UserEdit.Top + UserEdit.Height + ScaleY(8);

  // Add Database name input label
  DatabaseLabel := TNewStaticText.Create(DatabasePage);
  DatabaseLabel.Top := PasswordEdit.Top + PasswordEdit.Height + ScaleY(11);
  DatabaseLabel.Left := 0;
  DatabaseLabel.Caption := 'Database name';
  DatabaseLabel.AutoSize := True;
  DatabaseLabel.Parent := DatabasePage.Surface;
  // text required
  StaticText := TNewStaticText.Create(DatabasePage);
  StaticText.Top := PasswordEdit.Top + PasswordEdit.Height + ScaleY(11);
  StaticText.Left := DatabaseLabel.Width;
  StaticText.Caption := '*';
  StaticText.Font.Color := clRed;
  StaticText.Parent := DatabasePage.Surface;
  // Add Database name input field
  DatabaseEdit := TNewEdit.Create(DatabasePage);
  DatabaseEdit.Parent := DatabasePage.Surface;
  DatabaseEdit.Top := PasswordEdit.Top + PasswordEdit.Height + ScaleY(8);


  HostEdit.Left := DatabaseLabel.Width + StaticText.Width + ScaleX(8);
  PortEdit.Left := DatabaseLabel.Width + StaticText.Width + ScaleX(8);
  UserEdit.Left := DatabaseLabel.Width + StaticText.Width + ScaleX(8);
  PasswordEdit.Left := DatabaseLabel.Width + StaticText.Width + ScaleX(8);
  DatabaseEdit.Left := DatabaseLabel.Width + StaticText.Width + ScaleX(8);
  
  HostEdit.Width := DatabasePage.SurfaceWidth - DatabaseLabel.Width - StaticText.Width - ScaleX(8);
  PortEdit.Width := DatabasePage.SurfaceWidth - DatabaseLabel.Width - StaticText.Width - ScaleX(8);
  UserEdit.Width := DatabasePage.SurfaceWidth - DatabaseLabel.Width - StaticText.Width - ScaleX(8);
  PasswordEdit.Width := DatabasePage.SurfaceWidth - DatabaseLabel.Width - StaticText.Width - ScaleX(8);
  DatabaseEdit.Width := DatabasePage.SurfaceWidth - DatabaseLabel.Width - StaticText.Width - ScaleX(8);
  
  HostEdit.OnChange := @TextEditOnChange;
  PortEdit.OnChange := @TextEditOnChange;
  PortEdit.OnKeyPress := @TNewEditOnlyNumberKeyPress;
  UserEdit.OnChange := @TextEditOnChange;
  PasswordEdit.OnChange := @TextEditOnChange;
  DatabaseEdit.OnChange := @TextEditOnChange;
end;

procedure AddToReadyMemo(var Memo: string; Info, NewLine: string);
begin
  if Info <> '' then Memo := Memo + Info + Newline + NewLine;
end;

function UpdateReadyMemo(
  Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo,
  MemoGroupInfo, MemoTasksInfo: String): String;
var
  SetupName : String;
begin
  SetupName := ExtractFileName(ExpandConstant('{srcexe}'));
  Result :=
    Result +
    'Setup Files:' + NewLine +
    Space + SetupName + NewLine + NewLine;
  AddToReadyMemo(Result, MemoDirInfo, NewLine);
end;

function IsPortInUse(Port:String):Boolean;
var
  ResultCode: Integer;
begin
  Exec(ExpandConstant('{cmd}'), '/C netstat -na | findstr'+' /C:":'+Port+' "', '', 0,
       ewWaitUntilTerminated, ResultCode);
  if ResultCode <> 1 then 
  begin
    Result := True; 
  end
    else
  begin
    Result := False;
  end;
end;

function InitializeSetup(): Boolean;
var
  fe: Boolean;
  configuration: Boolean;
  usedPorts: String;

begin
  fe := IsPortInUse('8088'); 
  configuration := IsPortInUse('3000');
   
  usedPorts := '';
  
  if fe then usedPorts := usedPorts + '8088, ';
  if configuration then usedPorts := usedPorts + '3000, ';

  if Length(usedPorts) > 0 then
  begin
    usedPorts := Copy(usedPorts, 1, Length(usedPorts) - 2);
    MsgBox('The following ports have been used: ' + usedPorts + #13'Please close used Port(s) then reinstall the application.', mbError, MB_OK);
    Result := False;
  end
  else
  begin
    Result := True;
  end;
  ExtractTemporaryFiles('{tmp}\mariadb.exe');
end;

procedure InitializeUninstallProgressForm();
begin
  UninstallProgressForm.PageDescriptionLabel.Caption := 'Were so sorry to say goodbye';
  UninstallProgressForm.StatusLabel.Height :=  ScaleY(100);
  UninstallProgressForm.PageNameLabel.Caption := 'Uninstalling {#MyAppName}...';
  UninstallProgressForm.ProgressBar.Top :=  UninstallProgressForm.ProgressBar.Top + ScaleY(50);
 end;

function NextButtonClick(CurPageID: Integer): Boolean;
var 
  ResultCode: Integer;
  EnvFilePath: string;
begin
  Result := True;
  if CurPageID = DatabasePage.ID then
  begin
    WizardForm.NextButton.Enabled := False
    WizardForm.BackButton.Enabled := False
    ExecAsOriginalUser(ExpandConstant('{tmp}\')+'mariadb.exe', '-u ' + UserEdit.Text +' -p' + PasswordEdit.Text + ' -h ' + HostEdit.Text + ' -P ' + PortEdit.Text + ' -e "\q"', '',
        SW_HIDE, ewWaitUntilTerminated, ResultCode);
    if ResultCode = 1 then begin
      Result := False
      MsgBox('Unable to connect to the Maria database. Please check your connection details.', mbError, MB_OK)
    end else begin
      ExecAsOriginalUser(ExpandConstant('{tmp}\')+'mariadb.exe', '-u ' + UserEdit.Text +' -p' + PasswordEdit.Text + ' -h ' + HostEdit.Text + ' -P ' + PortEdit.Text + ' -e "use ' + DatabaseEdit.Text +  '"', '',
          SW_HIDE, ewWaitUntilTerminated, ResultCode);
      if ResultCode = 0 then begin
        Result := False
        MsgBox('Database already exists, please select another database.', mbError, MB_OK)
      end else begin
        // Specify the path for the file
        EnvFilePath := ExpandConstant('{tmp}\.env');

        Log(EnvFilePath)

        // Write user information to the file
        SaveStringToFile(EnvFilePath, 'host=' + HostEdit.Text + #13#10 + 'port=' + PortEdit.Text + #13#10 + 'username=' + UserEdit.Text + #13#10 + 'password=' + PasswordEdit.Text + #13#10 + 'database=' + DatabaseEdit.Text, False);
      end;
    end;
    WizardForm.NextButton.Enabled := True
    WizardForm.BackButton.Enabled := True
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = DatabasePage.ID then
  begin
    UpdateNextButtonState
  end;
end;

[Run]
Filename: "{app}\nssm.exe"; Parameters: "install nginxService ""{app}\{#Nginx}\nginx.exe"""; Flags: runhidden
Filename: "{app}\nssm.exe"; Parameters: "start nginxService"; Flags: runhidden
Filename: "{app}\node.exe"; Parameters: "./initial-database.js ""{tmp}"""; Flags: runhidden
Filename: "{app}\node.exe"; Parameters: "./install.js"; Flags: runhidden

[UninstallRun]
Filename: "{app}\node.exe"; Parameters: "./install.js --uninstall"; Flags: runhidden
Filename: "{app}\nssm.exe"; Parameters: "stop nginxService" ; Flags: runhidden
Filename: "{app}\nssm.exe"; Parameters: "remove nginxService confirm" ; Flags: runhidden
Filename: "{app}\stop.bat"; Flags: runhidden
Filename: "{app}\kill_port.bat"; Parameters: ""; Flags: runascurrentuser waituntilterminated; AfterInstall: Sleep(5000)


[UninstallDelete]
;Type: files; Name: "{app}\bin\*.*"

