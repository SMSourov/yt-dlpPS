@REM I'm using the GCC comiper to make an executable.
@REM However, depending on the compiler, it will make 
@REM 32-bit/64-bit executable file.

windres icon.rc -O coff -o icon.res

gcc yt-dlp.windows.c icon.res -o yt-dlp.windows.x64.exe

@REM I've no idea why but when I try to make the 32-bit executable
@REM file, Windows Security marks the file as a threat
@REM gcc yt-dlp.windows.c icon.res -o yt-dlp.windows.x86.exe
