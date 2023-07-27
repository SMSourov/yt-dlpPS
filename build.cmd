windres icon.rc -O coff -o icon.res

gcc yt-dlp.windows.c icon.res -o yt-dlp.windows.exe
