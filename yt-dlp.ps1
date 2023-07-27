$YouTube_URL = Read-Host "Enter your YouTube video URL"

# Get the info. The info file will be temporarily saved as "temp.info.json"
py .\yt-dlp\ $YouTube_URL --write-info-json --skip-download --windows-filenames -o temp

# In order to download a video, make sure that the height/width has one of the given values:
# 4320
# 2160
# 1440
# 1080
# 720
# 480
# 360
# 240
# 144

# Create variables for the width and height values
$width = 1920
# $height = 1080

# Set the video codec, avaiable codecs "vp"(vp9), "av0"(av1), "avc"
$vcodec = "vp"
# $vcodec = "avc"
# $vcodec = "av0"

# Set the protocol, available codecs "https", "m3u8"
$protocol = "https"
# $protocol = "m3u8"

# Set the audio codec, avaiable codecs "mp4a", "opus"
# $acodec = "mp4a"
$acodec = "opus"

# Set the audio quality, available qualities are "ultralow", "low", "medium"
# $format_note = "ultralow"
# $format_note = "low"
$format_note = "medium"

# Making 2 flags to mark a prime id for video and audio is found
$videoFound = 0
$audioFound = 0

# Set the optional commands
# $optionalCommands = " -N 8 --windows-filenames --write-thumbnail --convert-thumbnails jpg --embed-thumbnail --embed-metadata --embed-chapters --ffmpeg-location bin/"


# Download the subtitles
py .\yt-dlp\ "$YouTube_URL" --ffmpeg-location bin/ --write-subs --sub-langs all --convert-subs ass --skip-download
py .\yt-dlp\ "$YouTube_URL" --ffmpeg-location bin/ --write-subs --sub-langs all --convert-subs srt --skip-download


# Read the JSON file and convert it to a PowerShell object
$myJson = Get-Content -Raw temp.info.json | ConvertFrom-Json

# Filter the formats array based on the variables
$formats = $myJson.formats | Where-Object { 
    $_.width -eq $width -and 
    # $_.height -eq $height -and 
    $_.vcodec -like "*$vcodec*" -and 
    $_.protocol -like "*$protocol*" 
}
# Extract the format_id values and store them in an array variable
$formatIds = $formats | Select-Object -ExpandProperty format_id

# Check how many id $formatIds have. Only 1 is acceptable.
$count = $formatIds.Count
if ( $count -eq 1 ) {
    $vidID = $formatIds.ToString()
    $videoFound++
    Write-Output "The video id is $vidID"
}
elseif ( $count -eq 0 ) {

    # Filter the formats array based on the variables
    $formats = $myJson.formats | Where-Object { 
        # $_.width -eq $width -and 
        $_.height -eq $width -and 
        $_.vcodec -like "*$vcodec*" -and 
        $_.protocol -like "*$protocol*" 
    }

    # Extract the format_id values and store them in an array variable
    $formatIds = $formats | Select-Object -ExpandProperty format_id

    # Check how many id $formatIds have. Only 1 is acceptable.
    $count = $formatIds.Count
    if ( $count -eq 1 ) {
        $vidID = $formatIds.ToString()
        $videoFound++
        Write-Output "The video id is $vidID"
    }
    elseif ( $count -eq 0) {
        Write-Output "The requested type of video is not available. You should the check the other quality."
    }
    elseif ( $count -gt 1) {
        Write-Output "Multiple videos available. You need to be more specific.However, one is selected for you."
        $vidID = $formatIds[0].ToString()
        $videoFound++
        Write-Output "The video id is $vidID"
    }
}
elseif ( $count -gt 1) {
    Write-Output "Multiple videos available. You need to be more specific. However, one is selected for you."
    $vidID = $formatIds[0].ToString()
    $videoFound++
    Write-Output "The video id is $vidID"
}

# Filter the formats array based on the variables
$formats = $myJson.formats | Where-Object { 
    $_.format_note -eq "$format_note" -and 
    $_.acodec -like "*$acodec*" 
}

# Extract the format_id values and store them in an array variable
$formatIds = $formats | Select-Object -ExpandProperty format_id

# Check how many id $formatIds have. Only 1 is acceptable.
$count = $formatIds.Count
if ( $count -eq 1 ) {
    $audID = $formatIds.ToString()
    $audioFound++
    Write-Output "The audio id is $audID"
}
elseif ( $count -eq 0 ) {
    Write-Output "The requested type of audio is not available. You should the check the other quality."
}
elseif ( $count -gt 1) {
    Write-Output "Multiple audios available. You need to be more specific. However, one is selected for you."
    $audID = $formatIds[0].ToString()
    $audioFound++
    Write-Output "The audio id is $audID"
}



if ($videoFound -eq 1 -and $audioFound -eq 1) {
    $audioVideoQuality = "$vidID+$audID"
}
elseif ($videoFound -eq 0 -and $audioFound -eq 1) {
    $audioVideoQuality = "bv+$audID"
}
elseif ($videoFound -eq 1 -and $audioFound -eq 0) {
    $audioVideoQuality = "$vidID+ba"
}
elseif ($videoFound -eq 0 -and $audioFound -eq 0) {
    $audioVideoQuality = "bv+ba"
}


py .\yt-dlp\ "$YouTube_URL" -N 8 --windows-filenames --write-thumbnail --convert-thumbnails jpg  --embed-thumbnail --embed-metadata --embed-chapters --ffmpeg-location bin/ --write-subs --sub-format srt -f "$audioVideoQuality" 

# Remove the temporary file
Remove-Item temp.info.json


Pause
