from python_imports import video_properties
import re
def audio_function(json_file, a_codec, format_note, a_lang):
    print(a_codec + " " + format_note + " " + a_lang)
    print("\n")

    formats = json_file['formats']
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
    A_CODECS_REGEX = re.compile(r'^(opus|mp4a\.\d+\.\d+)$')
    FORMAT_NOTES = {"medium", "low", "ultralow"}
    a_codec_values = []
    format_notes_values = []

    # Initialize boolean variables for format notes
    found_low = False
    found_ultralow = False
    found_medium = False

    a_lang_values = []

    # Iterate through the 'formats' array
    for format_info in formats:
        # Check if 'acodec', 'format_note', and 'language' are present in the format_info
        if all(key in format_info for key in ['acodec', 'format_note', 'language']):
            a_codec_value = format_info['acodec']
            format_note_value = format_info['format_note']
            language_value = format_info['language']

            # Use regular expression to match 'a_codec_value' against the pattern
            if A_CODECS_REGEX.match(a_codec_value):
                # Check if any of the FORMAT_NOTES is present in format_note_value
                if not found_low and "low" in format_note_value.lower():
                    found_low = True
                if not found_ultralow and "ultralow" in format_note_value.lower():
                    found_ultralow = True
                if not found_medium and "medium" in format_note_value.lower():
                    found_medium = True

                # Add a_codec_value to the list if not present
                if a_codec_value not in a_codec_values:
                    a_codec_values.append(a_codec_value)

            # Check if 'language' is in A_LANGS
            if language_value in A_LANGS:
                if language_value not in a_lang_values:
                    a_lang_values.append(language_value)

    # Print which flags became true for format notes
    if found_low:
        print("Found 'low' in format notes.")
    if found_ultralow:
        print("Found 'ultralow' in format notes.")
    if found_medium:
        print("Found 'medium' in format notes.")

    # Print the unique format notes, languages, and previously solved a_codec_values
    print("\nUnique Format Notes:")
    for format_note in list(set(a_codec_values)):
        print(format_note)

    print("\nUnique Languages:")
    for language in a_lang_values:
        print(language)

        # don't make any changes to the prevous part.
        # everything works like a charm