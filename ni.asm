.386
.model flat,stdcall
option casemap:none

include ni.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov    hInstance,eax
	invoke WinMain,hInstance,NULL,NULL,SW_HIDE
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL	wc:WNDCLASSEX
	LOCAL	msg:MSG

	mov		wc.cbSize,sizeof WNDCLASSEX
	mov		wc.lpfnWndProc,offset WndProc
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	mov		wc.lpszClassName,offset ClassName
	invoke RegisterClassEx,addr wc
	invoke CreateDialogParam,hInstance,IDD_DIALOG,NULL,addr WndProc,NULL
	
	mov		nid.hwnd,eax
	mov 	nid.cbSize,sizeof NOTIFYICONDATA
	mov		nid.uID,IDI_TRAY
	mov		nid.uFlags,NIF_ICON+NIF_MESSAGE+NIF_TIP
	mov		nid.uCallbackMessage,WM_SHELLNOTIFY
	invoke	LoadIcon,hInst,IDI_ON
	mov		IconOn,eax
	invoke	LoadIcon,hInst,IDI_OFF
	mov		IconOff,eax
	invoke  GetKeyState,VK_NUMLOCK
	invoke lstrcpy,addr nid.szTip,addr StatusPrefix
	.if eax==1
		invoke 	lstrcat,addr nid.szTip,addr StatusOn
		push	IconOn
	.else
		invoke 	lstrcat,addr nid.szTip,addr StatusOff
		push	IconOff
	.endif	
	pop		nid.hIcon
	
	invoke ShowWindow,hWnd,CmdShow
	invoke Shell_NotifyIcon,NIM_ADD,addr nid
	invoke UpdateWindow,hWnd
	invoke SetTimer,hWnd,NULL,200,NULL
	.while TRUE
		invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
		invoke TranslateMessage,addr msg
		invoke DispatchMessage,addr msg
	.endw
	mov		eax,msg.wParam
	ret

WinMain endp

WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL pt:POINT

	.if uMsg==WM_INITDIALOG
		push	hWin
		pop		hWnd
	.elseif uMsg==WM_CREATE
		invoke 	CreatePopupMenu
		mov		hPopupMenu,eax
		invoke	AppendMenu,hPopupMenu,MF_STRING,IDM_EXIT,addr ExitDesc
	.elseif uMsg==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		.if eax==IDM_EXIT
			invoke SendMessage,hWin,WM_CLOSE,0,0
		.endif
	.elseif uMsg==WM_DESTROY
		invoke DestroyMenu,hPopupMenu
		invoke Shell_NotifyIcon,NIM_DELETE,addr nid
		invoke DestroyWindow,hWin
		invoke PostQuitMessage,NULL
	.elseif uMsg==WM_TIMER
		invoke 	lstrcpy,addr nid.szTip,addr StatusPrefix
		invoke  GetKeyState,VK_NUMLOCK
		.if eax==1
			invoke 	lstrcat,addr nid.szTip,addr StatusOn
			push	IconOn
		.else
			invoke 	lstrcat,addr nid.szTip,addr StatusOff
			push	IconOff
		.endif	
		pop		nid.hIcon
		invoke Shell_NotifyIcon,NIM_MODIFY,addr nid
	.elseif uMsg==WM_SHELLNOTIFY
		.if wParam==IDI_TRAY
			.if lParam==WM_RBUTTONDOWN 
				invoke GetCursorPos,addr pt
				invoke SetForegroundWindow,hWnd 
            	invoke TrackPopupMenu,hPopupMenu,TPM_RIGHTALIGN,pt.x,pt.y,NULL,hWnd,NULL 
               	invoke PostMessage,hWnd,WM_NULL,0,0
            .endif
		.endif
	.else
		invoke DefWindowProc,hWin,uMsg,wParam,lParam
		ret
	.endif
	ret

WndProc endp

end start
