# yt-dlpPS

This repo contains the PowerShell file that I use to download an YouTube video with the help of [yt-dlp](https://github.com/yt-dlp/yt-dlp). It makes everything easier for me. I don't have to type everything everytime.
Powershell v7, FFmpeg, FFprobe is needed to use this.


Put `yt-dlp` in the folder where you will run this script and make a folder named
`bin`
That folder, keep `ffmpeg.exe` and `ffprobe.exe`

This should work on both Windows and Linux without any problem

The C programs can be compiled easily.
In order to make the process easier, the binaries for Windows OS `yt-dlp.windows.exe` and Linux OS `yt-dlp.linux` are given to avoid compilation problems and make the process easier.
In order to use this program, make sure that you have the dependencies installed. The list of dependencies are:
    
For Windows OS:
  - [Python](https://www.python.org/downloads/) 3.x or later (`yt-dlp` needs python runtime environment to work. It won't work without it.)
  - Static full builds of [FFmpeg](https://www.gyan.dev/ffmpeg/builds/)
Add mkvtoolnix-gui, SubtitleEdit.exe in the environment variables.

    
For Linux OS:
  - python3 (`yt-dlp` needs python runtime environment to work. It won't work without it.)
  - python3-is-python (In the powershell file, `python` command is used. But in `python3` package, you have to use `python3` command. this package solves that problem.
  - ffmpeg

You may have to change the command by yourself. You only have to copy and paste the location in the powershell file. Nothing more.
