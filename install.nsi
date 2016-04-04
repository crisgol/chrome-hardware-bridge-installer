; install.nsi

!include "EnvVarUpdate.nsh"

;--------------------------------

; The name of the installer
Name "Chrome Hardware Extension Host"

; The file to write
OutFile "Chrome Hardware Extension Host Setup.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\Chrome Hardware Extension Host"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page directory
Page components
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

Section "Core (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "install.nsi"
  
  SetOutPath "$INSTDIR\host"
  File "host\*.*"
  ExecWait "$INSTDIR\host\install_host.bat"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\Chrome Hardware Extension Host" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Extension Host" "DisplayName" "Chrome Hardware Extension Host"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Extension Host" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Extension Host" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Extension Host" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

Section "Python 2.7"
  ; Set output path to the installation directory.
  SetOutPath $TEMP
  
  ; Put file there
  File "dist\python-2.7.11.msi"

  ExecWait "msiexec /i python-2.7.11.msi /qb ADDLOCAL=ALL"
SectionEnd

Section "Python pypiwin32"
  ; Set output path to the installation directory.
  SetOutPath $TEMP
  
  ; Put file there
  File "dist\pypiwin32-219-cp27-none-win32.whl"

  ExecWait "C:\Python27\Scripts\pip.exe install pypiwin32-219-cp27-none-win32.whl"
SectionEnd

Section "Python pdfkit"
  ; Set output path to the installation directory.
  SetOutPath $TEMP
  
  ; Put file there
  File "dist\pdfkit-0.5.0-py2-none-any.whl"

  ExecWait "C:\Python27\Scripts\pip.exe install pdfkit-0.5.0-py2-none-any.whl"
SectionEnd

Section "wkhtmltopdf"
  ; Set output path to the installation directory.
  SetOutPath $TEMP
  
  ; Put file there
  File "dist\wkhtmltox-0.12.3.2_msvc2013-win32.exe"

  ExecWait "$TEMP\wkhtmltox-0.12.3.2_msvc2013-win32.exe /S"
  
  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$PROGRAMFILES\wkhtmltopdf\bin"
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Extension Host"
  DeleteRegKey HKLM "SOFTWARE\Chrome Hardware Extension Host"

  ExecWait "$INSTDIR\host\uninstall_host.bat"
  
  ; Remove files and uninstaller
  Delete "$INSTDIR\host\*.*"
  Delete "$INSTDIR\*.*"  

  ; Remove directories used
  RMDir "$INSTDIR\host"
  RMDir "$INSTDIR"  

SectionEnd
