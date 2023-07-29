function Get-VideoFormats {
    param(
        [Parameter(Mandatory=$true)]
        $myJson,

        [Parameter(Mandatory=$true)]
        $width,

        [Parameter(Mandatory=$true)]
        $vcodec,

        [Parameter(Mandatory=$true)]
        $protocol
    )

    $formats = $myJson.formats | Where-Object { 
        $_.width -eq $width -and 
        $_.vcodec -like "*$vcodec*" -and 
        $_.protocol -like "*$protocol*" 
    }

    # Instead of returning just the format IDs, return the entire format objects
    return $formats
}


function Get-AudioFormats {
    param(
        [Parameter(Mandatory=$true)]
        $myJson,

        [Parameter(Mandatory=$true)]
        $format_note,

        [Parameter(Mandatory=$true)]
        $acodec
    )

    $formats = $myJson.formats | Where-Object { 
        $_.format_note -eq "$format_note" -and 
        $_.acodec -like "*$acodec*" 
    }

    # Instead of returning just the format IDs, return the entire format objects
    return $formats
}


# First block, take the url and get the temp file.
$YouTube_URL = Read-Host "Enter your YouTube video URL"

# Get the info. The info file will be temporarily saved as "temp.info.json"
py .\yt-dlp\ $YouTube_URL --write-info-json --skip-download --windows-filenames -o temp



# Second block, set the config
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



# Third block, download the subtitles
# Third block, download the subtitles in both ASS and SRT formats
$subtitleFormats = @("ass", "srt")
foreach ($format in $subtitleFormats) {
    py .\yt-dlp\ "$YouTube_URL" --ffmpeg-location bin/ --write-subs --sub-langs all --convert-subs $format --skip-download
}



# Fourth block, read the temp file
# Read the JSON file and convert it to a PowerShell object
$myJson = Get-Content -Raw temp.info.json | ConvertFrom-Json



# Fifth block, start filtering for the video
# Filter the formats array based on the variables
$formats = Get-VideoFormats -myJson $myJson -width $width -vcodec $vcodec -protocol $protocol

if ($formats.Count -eq 1) {
    $selectedFormat = $formats[0]
    $vidID = $selectedFormat.format_id
    Write-Output "The video format selected: $($selectedFormat.width)x$($selectedFormat.height), Codec: $($selectedFormat.vcodec), Format ID: $vidID"
}
elseif ($formats.Count -eq 0) {
    Write-Output "The requested type of video is not available. You should check the other quality."
}
else {
    Write-Output "Multiple video formats available. Please choose from the following:"
    $formats | ForEach-Object {
        Write-Output "Resolution: $($_.width)x$($_.height), Codec: $($_.vcodec), Format ID: $($_.format_id)"
    }

    $selectedFormatIndex = Read-Host "Enter the index of the format you want to download"
    if ($selectedFormatIndex -ge 0 -and $selectedFormatIndex -lt $formats.Count) {
        $selectedFormat = $formats[$selectedFormatIndex]
        $vidID = $selectedFormat.format_id
        Write-Output "You selected Resolution: $($selectedFormat.width)x$($selectedFormat.height), Codec: $($selectedFormat.vcodec), Format ID: $vidID"
    }
    else {
        Write-Output "Invalid format index. Downloading the first available format."
        $selectedFormat = $formats[0]
        $vidID = $selectedFormat.format_id
    }
}



# Sixth block, start filtering for the audio
# Filter the formats array based on the variables
$formats = Get-AudioFormats -myJson $myJson -format_note $format_note -acodec $acodec
if ($formats.Count -eq 1) {
    $selectedFormat = $formats[0]
    $audID = $selectedFormat.format_id
    Write-Output "The audio format selected: $($selectedFormat.abr), Codec: $($selectedFormat.acodec), Format ID: $audID"
}
elseif ($formats.Count -eq 0) {
    Write-Output "The requested type of audio is not available. You should check the other quality."
}
else {
    Write-Output "Multiple audio formats available. Please choose from the following:"
    $formats | ForEach-Object {
        Write-Output "Bitrate: $($_.abr), Codec: $($_.acodec), Format ID: $($_.format_id)"
    }

    $selectedFormatIndex = Read-Host "Enter the index of the format you want to download"
    if ($selectedFormatIndex -ge 0 -and $selectedFormatIndex -lt $formats.Count) {
        $selectedFormat = $formats[$selectedFormatIndex]
        $audID = $selectedFormat.format_id
        Write-Output "You selected Bitrate: $($selectedFormat.abr), Codec: $($selectedFormat.acodec), Format ID: $audID"
    }
    else {
        Write-Output "Invalid format index. Downloading the first available format."
        $selectedFormat = $formats[0]
        $audID = $selectedFormat.format_id
    }
}



# Seventh block, define the audio, video quality
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



# Eight block, execute the command to the host
py .\yt-dlp\ "$YouTube_URL" -N 8 --windows-filenames --write-thumbnail --convert-thumbnails jpg  --embed-thumbnail --embed-metadata --embed-chapters --ffmpeg-location bin/ --write-subs --sub-format srt -f "$audioVideoQuality" 



# Ninth block, remove the temporary file.
# Remove the temporary file
Remove-Item temp.info.json


Pause
