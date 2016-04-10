; install.nsi

!include "EnvVarUpdate.nsh"

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
InstType "Host, Dependencies and Extension Only"
InstType "Host and Dependencies Only"
InstType "Host Only"


Section "Host (required)"

  SectionIn RO
  
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
  Section "Python 2.7.11"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\python-2.7.11.msi"

    ExecWait "msiexec /i python-2.7.11.msi /qb ADDLOCAL=ALL"
  SectionEnd

  Section "Python pip"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\pip-8.1.1-py2.py3-none-any.whl"

    ExecWait "C:\Python27\python -m pip install --upgrade pip-8.1.1-py2.py3-none-any.whl"
  SectionEnd
  
  Section "Python wxpython"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\wxPython_Phoenix-3.0.3.dev1964+f780b21-cp27-cp27m-win32.whl"

    ExecWait "C:\Python27\Scripts\pip.exe install wxPython_Phoenix-3.0.3.dev1964+f780b21-cp27-cp27m-win32.whl"
  SectionEnd
  
  Section "Python pypiwin32"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\pypiwin32-219-cp27-none-win32.whl"

    ExecWait "C:\Python27\Scripts\pip.exe install pypiwin32-219-cp27-none-win32.whl"
  SectionEnd

  Section "Python pdfkit"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\pdfkit-0.5.0-py2-none-any.whl"

    ExecWait "C:\Python27\Scripts\pip.exe install pdfkit-0.5.0-py2-none-any.whl"
  SectionEnd

  Section "wkhtmltopdf"
    SectionIn 1 2 3
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\wkhtmltox-0.12.3.2_msvc2013-win32.exe"

    ExecWait "$TEMP\wkhtmltox-0.12.3.2_msvc2013-win32.exe /S"
    
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$PROGRAMFILES\wkhtmltopdf\bin"
  SectionEnd
SubSectionEnd
  
SubSection /e "Google Chrome and Extension"
  Section "Google Chrome"
    SectionIn 1
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\googlechromestandaloneenterprise.msi"

    ExecWait "msiexec /i googlechromestandaloneenterprise.msi"
  SectionEnd

  Section "Chrome Extension"
    SectionIn 1 2
  
    !define PRODUCT_VERSION "1.1.2"
    !define CRXNAME "fnfkcaeloalplnglklappfjfjeafakeo_main.crx"
    !define CRXID "fnfkcaeloalplnglklappfjfjeafakeo"

    SetOutPath "$INSTDIR\app"
    File "app\${CRXNAME}"
    WriteRegStr HKLM "Software\Google\Chrome\Extensions\${CRXID}" "path" "$INSTDIR\${CRXNAME}"
    WriteRegStr HKLM "Software\Google\Chrome\Extensions\${CRXID}" "version"     "${PRODUCT_VERSION}"
    WriteRegStr HKLM "Software\Wow6432Node\Google\Chrome\Extensions\${CRXID}" "path" "$INSTDIR\app\${CRXNAME}"
    WriteRegStr HKLM "Software\Wow6432Node\Google\Chrome\Extensions\${CRXID}" "version" "${PRODUCT_VERSION}"
  SectionEnd
SubSectionEnd

SubSection /e "Adobe Reader"
  Section "Adobe Reader XI"
    SectionIn 1
  
    ; Set output path to the installation directory.
    SetOutPath $TEMP
    
    ; Put file there
    File "dist\AdbeRdr11000_zh_TW.exe"

    ExecWait "AdbeRdr11000_zh_TW.exe /msi EULA_ACCEPT=YES UPDATE_MODE=0 /qn"
  SectionEnd
SubSectionEnd
;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Chrome Hardware Bridge"
  DeleteRegKey HKLM "SOFTWARE\Chrome Hardware Bridge"

  DeleteRegValue HKLM "Software\Google\Chrome\Extensions\${CRXID}" "path"
  DeleteRegValue HKLM "Software\Google\Chrome\Extensions\${CRXID}" "version"
  DeleteRegValue HKLM "Software\Wow6432Node\Google\Chrome\Extensions\${CRXID}" "path"
  DeleteRegValue HKLM "Software\Wow6432Node\Google\Chrome\Extensions\${CRXID}" "version"
  
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
