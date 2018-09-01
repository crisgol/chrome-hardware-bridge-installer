; install.nsi

;--------------------------------

; The name of the installer
Name "Chrome Hardware Bridge"

; The file to write
OutFile "Chrome Hardware Bridge Setup.exe"

; The default installation directory
InstallDir "$PROGRAMFILES\Chrome Hardware Bridge"

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

InstType "Full Installation"

Section "Host"
  SectionIn 1 2
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "install.nsi"
  
  SetOutPath "$INSTDIR\host"
  File "host\*.*"
  ExecWait "$INSTDIR\host\install_host.bat"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\Chrome Hardware Bridge" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge" "DisplayName" "Chrome Hardware Bridge"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

SubSection /e "Python and Dependencies"
  Section "Python 2.7.15"
    SectionIn 1 2
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\python-2.7.15.msi"

    ExecWait "msiexec /i python-2.7.15.msi /qb ADDLOCAL=ALL"
  SectionEnd

  Section "Python pip"
    SectionIn 1 2
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\pip-18.0-py2.py3-none-any.whl"

    ExecWait "C:\Python27\python -m pip install --upgrade pip-18.0-py2.py3-none-any.whl"
  SectionEnd
  
  Section "Python wxpython"
    SectionIn 1 2
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\wxPython-4.0.3-cp27-cp27m-win32.whl"

    ExecWait "C:\Python27\Scripts\pip.exe install wxPython-4.0.3-cp27-cp27m-win32.whl"
  SectionEnd
  
  Section "Python pypiwin32"
    SectionIn 1 2
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\pypiwin32-219-cp27-none-win32.whl"

    ExecWait "C:\Python27\Scripts\pip.exe install pypiwin32-219-cp27-none-win32.whl"
  SectionEnd
SubSectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge"
  DeleteRegKey HKLM "SOFTWARE\Chrome Hardware Bridge"
  
  ExecWait "$INSTDIR\host\uninstall_host.bat"
  
  ; Remove files and uninstaller
  Delete "$INSTDIR\host\*.*"
  Delete "$INSTDIR\app\*.*"
  Delete "$INSTDIR\*.*"  

  ; Remove directories used
  RMDir "$INSTDIR\host"
  RMDir "$INSTDIR\app"
  RMDir "$INSTDIR"  

SectionEnd
