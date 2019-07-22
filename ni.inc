include windows.inc
include user32.inc
include kernel32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib

WinMain				PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD

IDD_DIALOG			equ 1000
IDI_ON				equ 10000
IDI_OFF				equ 10001
IDI_TRAY			equ 10010
IDM_EXIT			equ 10011

WM_SHELLNOTIFY      equ WM_USER+5

.const

ClassName			db 'DLGCLASS',0
AppName				db 'Numlock Indicator',0
StatusPrefix		db 'Num lock: ',0
StatusOn			db 'On',0
StatusOff			db 'Off',0
ExitDesc			db 'E&xit',0

.data?

hInstance			dd ?
hWnd				dd ?
hPopupMenu			dd ?
nid					NOTIFYICONDATA <>
IconOn              HICON ?
IconOff             HICON ?