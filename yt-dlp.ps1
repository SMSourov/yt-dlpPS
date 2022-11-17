$YouTube_video_URL = Read-Host "Enter your YouTube video URL"
Write-Host "You have entered" $YouTube_video_URL

# Firstly, download and convert the subtitle to SRT. SRT is supported in almost every video player that supports subtitle.
.\yt-dlp.exe $YouTube_video_URL --write-thumbnail  --ffmpeg-location bin/ --write-subs --sub-langs all --convert-subs srt --skip-download


# Secondly, download and convert the subtitle to ASS. It has more features than SRT. To edit, a separate subtitle editor is recommended.
.\yt-dlp.exe $YouTube_video_URL --write-thumbnail  --ffmpeg-location bin/ --write-subs --sub-langs all --convert-subs ass --skip-download


# Thirdly, download the original subtitle files that are available in youtube
.\yt-dlp.exe $YouTube_video_URL --write-thumbnail  --ffmpeg-location bin/ --write-subs --sub-langs all --skip-download


# Fourthly, download the video and others and embedd everything. Unfortunately, it only embeds the WebVTT subtitle file. You would have to use MKVToolNix to add the other subtitle files.
.\yt-dlp.exe $YouTube_video_URL -N 8 --windows-filenames --write-description --write-info-json --write-thumbnail --convert-thumbnails jpg --write-url-link --write-webloc-link  --write-desktop-link --embed-subs --embed-thumbnail --embed-metadata --embed-chapters --embed-info-json --xattrs --ffmpeg-location bin/


# Fifthly, if the video is 1080p or higher, download the 1080p video only. If you have a 1080p monitor/display, there is no meaning of having of a video that has a higher resolution of your monitor/display. Besides, a video of a higher(let's assume 8K) is uploaded, YouTube converts them into several lower resolution. One of them is 1080p. It will download the converted version. You may need to use MKVToolNix to edit the video file.
.\yt-dlp.exe $YouTube_video_URL -N 8 -f 248



Pause