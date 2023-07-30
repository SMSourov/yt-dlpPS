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

    # Filter formats based on width and video codec
    $formats = $myJson.formats | Where-Object { 
        $_.width -eq $width -and 
        $_.vcodec -like "*$vcodec*" -and 
        $_.protocol -like "*$protocol*" 
    }

    if ($formats.Count -eq 0) {
        # If no formats match the width, try matching height using width as height
        $formats = $myJson.formats | Where-Object { 
            $_.height -eq $width -and 
            $_.vcodec -like "*$vcodec*" -and 
            $_.protocol -like "*$protocol*" 
        }
    }

    if ($formats.Count -eq 0) {
        # If no formats match the width or height, select the best available format
        $formats = $myJson.formats | Where-Object { 
            $_.vcodec -like "*$vcodec*" -and 
            $_.protocol -like "*$protocol*" 
        }
    }

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
# 7680
# 3840
# 2560
# 1920
# 1280
# 854
# 640
# 426
# 256


# Create variables for the width and height values
$width = 1920
# $height = 1080

# Set the video codec, avaiable codecs "vp"(vp9), "av0"(av1), "avc"
$vcodec = "vp"
# $vcodec = "avc"
# $vcodec = "av0"

# Set the protocol, available codecs "https", "m3u8"
# $protocol = "https"
$protocol = "m3u8"

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



# Fifth block, start filtering for video
# Step 1: List the available width values and store them in an array variable
$availableWidths = @()
$myJson.formats | ForEach-Object {
    $widthValue = $_.width
    if ($widthValue -notin $availableWidths) {
        $availableWidths += $widthValue
    }
}

# Sort the array in ascending order (optional)
$availableWidths = $availableWidths | Sort-Object

# Write-Output "Available Width Values:"
$availableWidths | ForEach-Object {
    # Write-Output $_
}

# Write-Output "Exiting the fifth block - Step 1"
# Write-Output "Initiating the fifth block - Step 2: List Available Height Values"



































# Step 2: List the available height values and store them in an array variable
$availableHeights = @()
$myJson.formats | ForEach-Object {
    $heightValue = $_.height
    if ($heightValue -notin $availableHeights) {
        $availableHeights += $heightValue
    }
}

# Sort the array in ascending order (optional)
$availableHeights = $availableHeights | Sort-Object

# Write-Output "Available Height Values:"
$availableHeights | ForEach-Object {
    # Write-Output $_
}




# Write-Output "Initiating fifth block - Step 3: Filter Formats Based on Width and Video Codec"

# Initialize the $matchWidth variable to 0 (no match)
$matchWidth = 0

# Step 3: Filter formats based on width
# Check if the desired resolution matches with width from availableWidths
if ($width -in $availableWidths) {
    # Desired resolution matches with width, set $matchWidth to 1
    $matchWidth = 1
}
else {
    # If no formats match the width from availableWidths, try matching height using width as height from availableHeights
    if ($width -in $availableHeights) {
        # Desired resolution matches with height (assuming portrait orientation), set $matchWidth to 2
        $matchWidth = 2
    }
}

# Increment $videoFound if $matchWidth is non-zero
if ($matchWidth -ne 0) {
    $videoFound++
    if ($matchWidth -eq 1) {
        # Write-Output "It is a landscape video"
    }
    elseif ($matchWidth -eq 2) {
        # Write-Output "It is a protrait video"
    }
}

# Write-Output "Exiting the fifth block - Step 3"
# Write-Output "Initiating the sixth block"



Write-Output "Initiating sixth block - Step 4: Filter Formats Based on Video Codec"

if ($videoFound -ne 0) {
    # Step 4: Filter formats based on video codec (only if $videoFound is non-zero)
    # Initialize the $matchCodec variable to 0 (no match)
    $matchCodec = 0

    # Initialize an empty array to store the available video codecs for the given $width
    $availableCodecsForWidth = @()

    # List the available video codecs for the given $width
    foreach ($format in $myJson.formats) {
        if ($format.width -eq $width -and $format.vcodec -is [string]) {
            $availableCodecsForWidth += $format.vcodec
        }
    }

    # Print the available video codecs for the given $width
    # Write-Output "Available Video Codecs for Width: $width"
    # $availableCodecsForWidth

    # Check if the desired video codec is a substring of any of the available video codecs
    foreach ($codec in $availableCodecsForWidth) {
        if ($codec -like "*$vcodec*") {
            # Desired video codec found (substring match), set $matchCodec to 1
            $matchCodec = 1
            Write-Output "Desired video codec found"
            break
        }
    }

    if ($matchCodec -eq 0) {
        # Check for other available codecs with priority vp > av0 > avc
        $availableCodecs = "vp", "av0", "avc"

        foreach ($codec in $availableCodecs) {
            foreach ($availableCodec in $availableCodecsForWidth) {
                if ($availableCodec.Contains($codec)) {
                    # Higher-priority codec found, update $vcodec
                    $vcodec = $codec
                    Write-Output "Using available codec: $vcodec"
                    $matchCodec = 1
                    break
                }
            }

            if ($matchCodec -eq 1) {
                break
            }
        }
    }
}

# Write-Output "Exiting the sixth block - Step 4"
# Write-Output "Initiating the seventh block"



Write-Output "Initiating the sixth block - Step 5: Filter Formats Based on Audio Codec"

# Step 5: Filter formats based on audio codec
# Initialize an empty array to store the available protocols for the given $width and $vcodec
$availableProtocolsForWidthAndCodec = @()

# List the available formats for the given $width and $vcodec
foreach ($format in $myJson.formats) {
    if ($format.width -eq $width -and $format.vcodec.Contains($vcodec) -and $format.protocol -is [string]) {
        $availableProtocolsForWidthAndCodec += $format.protocol
    }
}

# Print the available protocols for the given $width and $vcodec
Write-Output "Available Protocols for Width: $width, Codec: $vcodec"
$availableProtocolsForWidthAndCodec


# If the given $protocol matches with the available protocols, do nothing.
# Otherwise, change the value of $protocol to the matching protocol (either "https" or "m3u8").
if (-not ($availableProtocolsForWidthAndCodec -like "*$protocol*")) {
    if ($availableProtocolsForWidthAndCodec -like "*https*") {
        $protocol = "https"
    } elseif ($availableProtocolsForWidthAndCodec -like "*m3u8*") {
        $protocol = "m3u8"
    }
}

# Write-Output "The protocol selected is $protocol"



Write-Output "Initiating the sixth block - Step 6: Get Format ID for Selected Video"

# Step 6: Get format ID for selected video
if ($videoFound -ne 0) {
    # Use the Get-VideoFormats function to get the filtered formats
    $formats = Get-VideoFormats -myJson $myJson -width $width -vcodec $vcodec -protocol $protocol

    if ($formats.Count -gt 0) {
        # Using the filtered formats, select the first format as the chosen format
        $chosenFormat = $formats[0]

        # Get the format ID of the chosen format
        $formatID = $chosenFormat.format_id

        # Store the format ID in $vidID
        $vidID = $formatID

        Write-Output "The video format ID is: $formatID"

        # Proceed with downloading the selected video using the format ID
        # ... (Write the code for downloading the video using the format ID)
    }
    else {
        Write-Output "No matching video format found for the given criteria."
    }
}
else {
    Write-Output "No matching video found for the given criteria."
}



# Sixth block, start filtering for the audio
# Filter the formats array based on the variables
$formats = Get-AudioFormats -myJson $myJson -format_note $format_note -acodec $acodec
if ($formats.Count -eq 1) {
    $selectedFormat = $formats[0]
    $audID = $selectedFormat.format_id
    $audioFound = 1   # Update audioFound to 1 as the desired audio format is found
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

Write-Output "the quality is  $audioVideoQuality"

# Eight block, execute the command to the host
py .\yt-dlp\ "$YouTube_URL" -N 8 --windows-filenames --write-thumbnail --convert-thumbnails jpg  --embed-thumbnail --embed-metadata --embed-chapters --ffmpeg-location bin/ --write-subs --sub-format srt -f "$audioVideoQuality" 



# Ninth block, remove the temporary file.
# Remove the temporary file
Remove-Item temp.info.json


Pause
