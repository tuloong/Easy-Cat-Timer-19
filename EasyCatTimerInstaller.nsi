; Easy Cat Timer Installer
; Created with NSIS (Nullsoft Scriptable Install System)

!define APP_NAME "Easy Cat Timer"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "Easy Cat Timer Team"
!define APP_WEBSITE "https://github.com/Easy-Cat-Timer/Easy-Cat-Timer"
!define APP_EXE "CatTimer WpfProject.exe"

; Set compression
SetCompressor /SOLID lzma

; Resource files - must be defined before MUI2.nsh include
!define MUI_ICON "CatTimer WpfProject\Asset\Icon\Icon.ico"
!define MUI_UNICON "CatTimer WpfProject\Asset\Icon\Icon.ico"

; Include Modern UI
!include "MUI2.nsh"

; Basic settings
Name "${APP_NAME}"
OutFile "EasyCatTimer-v${APP_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}" "Install_Dir"
RequestExecutionLevel admin

; Default install directory pages
!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

; Welcome pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstall pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language settings
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

; ------------------------
; Installation Section
; ------------------------
Section "MainProgram" SecMain

    SectionIn RO

        ; Set output path
    SetOutPath "$INSTDIR"

    ; Write uninstall information
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayVersion" "${APP_VERSION}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "VersionMajor" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "VersionMinor" 0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "NoRepair" 1
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "DisplayIcon" "$INSTDIR\${APP_EXE}"

    ; Install main program files
    ; Try Release version first, otherwise use Debug version
    SetOutPath "$INSTDIR"
    
    ; Debug: create directory structure
    CreateDirectory "$INSTDIR\logs"
    
    ; Use relative path to installer script directory
    SetOutPath "$INSTDIR"
    
    ; Copy all files from release build
    File /r "CatTimer WpfProject\bin\Release\net8.0-windows\*.*"
    
    FilesDone:

    ; Create shortcuts
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0
    CreateShortCut "$SMPROGRAMS\${APP_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0

    ; Add to start menu
    CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0

SectionEnd

; Optional desktop shortcut
Section "DesktopShortcut" SecDesktop
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_EXE}" 0
SectionEnd

; ------------------------
; Uninstall Section
; ------------------------
Section "Uninstall"

    ; Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
    DeleteRegKey HKLM "Software\${APP_PUBLISHER}\${APP_NAME}"

    ; Remove files and shortcuts
    Delete "$SMPROGRAMS\${APP_NAME}\*.*"
    Delete "$DESKTOP\${APP_NAME}.lnk"
    Delete "$SMPROGRAMS\${APP_NAME}.lnk"
    Delete "$INSTDIR\*.*"

    ; Remove directories
    RMDir "$SMPROGRAMS\${APP_NAME}"
    RMDir "$INSTDIR"

SectionEnd

; ------------------------
; Functions Section
; ------------------------
Function .onInit
    ; Check if already installed
    ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" "UninstallString"
    StrCmp $R0 "" done

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "${APP_NAME} is already installed on your system.$\r$\n$\r$\nClick OK to uninstall the old version and install the new version." IDOK uninst
    Abort

uninst:
    ClearErrors
    ExecWait '$R0 /S _?=$INSTDIR'
    IfErrors no_remove_uninstaller done
    no_remove_uninstaller:
        Delete "$INSTDIR\uninstall.exe"
    done:

FunctionEnd

Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove ${APP_NAME} and all its components?" IDYES +2
    Abort
FunctionEnd

Function .onInstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${APP_NAME} installed successfully!"
FunctionEnd

Function un.onUninstSuccess
    MessageBox MB_ICONINFORMATION|MB_OK "${APP_NAME} has been successfully removed from your computer."
FunctionEnd