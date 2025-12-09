;--------------------------------
; Rippler VST3 Installer (NSIS)
;--------------------------------

!include "MUI2.nsh"
!include "FileFunc.nsh"
!insertmacro GetParameters

;--------------------------------
; General settings
;--------------------------------
Name "Rippler 0.7.0"
OutFile "rippler-win64-0.7.0-setup.exe"
InstallDir "$PROGRAMFILES64\Common Files\VST3\Rippler"
InstallDirRegKey HKLM "Software\Tiltpoint.Audio\Rippler" "Install_Dir"
RequestExecutionLevel admin
ShowInstDetails show
BrandingText " "

; Custom icon
!define MUI_WELCOMEFINISHPAGE_BITMAP "assets\wizard.bmp"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "assets\logo.bmp"

;--------------------------------
; Pages
;--------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\include\EULA.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Uninstaller
;--------------------------------
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
; Components
;--------------------------------

Section "VST3" SecVST3
    SetOutPath "$INSTDIR"
    File /r "..\..\build\Rippler_artefacts\Release\VST3\Rippler.vst3"
SectionEnd

Section "Presets" SecPresets
    RMDir /r "$APPDATA\Rippler\presets\Factory"
    SetOutPath "$APPDATA\Rippler\presets\Factory"
    File /r "..\include\presets\Factory\*.*"
SectionEnd

Section "Mallets" SecMallets
    SetOutPath "$APPDATA\Rippler\mallets"
    File /r "..\include\mallets\*.*"
SectionEnd

Section "Uninstaller & Registry"
    SetOutPath "$INSTDIR"
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    SetRegView 64

    ; Registry entries for Add/Remove Programs
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler" "DisplayName" "Rippler"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler" "Publisher" "Tiltpoint.Audio"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler" "DisplayVersion" "0.7.0"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecVST3} "Rippler VST3 plugin (64-bit)."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPresets} "Built-in factory presets."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMallets} "Additional sample based mallets."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller Section
;--------------------------------
Section "Uninstall"
    Delete "$INSTDIR\Rippler.vst3"
    RMDir /r "$APPDATA\Rippler"
    Delete "$INSTDIR\Uninstall.exe"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler"
SectionEnd
