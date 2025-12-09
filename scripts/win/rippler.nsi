;--------------------------------
; Rippler VST3 Installer (NSIS)
;--------------------------------

!include "MUI2.nsh"
!include "FileFunc.nsh"
!insertmacro GetParameters

!ifndef VERSION
  !define VERSION "0.0.0-dev"
!endif

;--------------------------------
; General settings
;--------------------------------
Name "Rippler ${VERSION}"
OutFile "rippler-win64-${VERSION}-setup.exe"
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
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler" "DisplayVersion" "${VERSION}"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPresets} "Built-in factory presets."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMallets} "Additional sample based mallets."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller Section
;--------------------------------
Section "Uninstall"
    RMDir /r "$APPDATA\Rippler"
    Delete "$INSTDIR\Uninstall.exe"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Rippler"
SectionEnd
