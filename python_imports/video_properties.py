# Set the resolution
# In order to download a video, make sure that the height/width has one of the given values:
# 7680
# 3840
# 2560
# 1920(default)
# 1280
# 854
# 640
# 426
# 256

# Create variables for the width and height values
width = 1920
height = 1080

# Set the video codec, avaiable codecs "vp"(vp9), "av0"(av1), "avc"
v_codec = "vp"
# vcodec = "avc"
# vcodec = "av0"

# Set the protocol, available codecs "https", "m3u8"
# protocol = "https"
protocol = "m3u8"

# Set the audio codec, avaiable codecs "mp4a", "opus"
# acodec = "mp4a"
a_codec = "opus"

# Set the audio quality, available qualities are "medium", "low", "ultralow"
# This gets the strings that has this words
format_note = "medium"
# format_note = "low"
# format_note = "ultralow"

# Set the prefered audio language. If it is found, it will be selected
a_lang = "en"

# Set the subtitle language
s_lang = "en"

# Note whether the desired audio, video and subtitle is found or not, 0 = no(default), 1 = yes
v_found = 0
a_found = 0
s_found = 0
