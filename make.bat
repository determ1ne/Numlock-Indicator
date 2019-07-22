set masm32=C:\Masm32
%masm32%\Bin\RC.EXE "ni.rc"
%masm32%\Bin\ML.EXE /c /coff /Cp /nologo /I"%masm32%\Include" "ni.asm"
%masm32%\Bin\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"C:\Masm32\Lib" /OUT:"ni.exe" "ni.obj" "ni.RES"
del Ni.obj
del Ni.RES