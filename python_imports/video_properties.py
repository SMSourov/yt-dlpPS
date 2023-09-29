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


# the languages
A_LANGS = {
    "aa", "ab", "ae", "af", "ak", "am", "an", "ar", "as", "av", "ay", "az",
    "ba", "be", "bg", "bh", "bi", "bm", "bn", "bo", "br", "bs", "ca", "ce", "ch",
    "co", "cr", "cs", "cu", "cv", "cy", "da", "de", "dv", "dz", "ee", "el", "en",
    "eo", "es", "et", "eu", "fa", "ff", "fi", "fj", "fo", "fr", "fy", "ga", "gd",
    "gl", "gn", "gu", "gv", "ha", "he", "hi", "ho", "hr", "ht", "hu", "hy", "hz",
    "ia", "id", "ie", "ig", "ii", "ik", "io", "is", "it", "iu", "ja", "jv", "ka",
    "kg", "ki", "kj", "kk", "kl", "km", "kn", "ko", "kr", "ks", "ku", "kv", "kw",
    "ky", "la", "lb", "lg", "li", "ln", "lo", "lt", "lu", "lv", "mg", "mh", "mi",
    "mk", "ml", "mn", "mr", "ms", "mt", "my", "na", "nb", "nd", "ne", "ng", "nl",
    "nn", "no", "nr", "nv", "ny", "oc", "oj", "om", "or", "os", "pa", "pi", "pl",
    "ps", "pt", "qu", "rm", "rn", "ro", "ru", "rw", "sa", "sc", "sd", "se", "sg",
    "si", "sk", "sl", "sm", "sn", "so", "sq", "sr", "ss", "st", "su", "sv", "sw",
    "ta", "te", "tg", "th", "ti", "tk", "tl", "tn", "to", "tr", "ts", "tt", "tw",
    "ty", "ug", "uk", "ur", "uz", "ve", "vi", "vo", "wa", "wo", "xh", "yi", "yo",
    "za", "zh", "zu"
}