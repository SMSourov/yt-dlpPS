from python_imports import video_properties
import re
def audio_function(json_file, a_codec, format_note, a_lang):
    print(a_codec + " " + format_note + " " + a_lang)
    print("\n")

    formats = json_file['formats']

    A_CODECS_REGEX = re.compile(r'^(opus|mp4a\.\d+\.\d+)$')
    FORMAT_NOTES = {"medium", "low", "ultralow"}
    a_codec_values = []
    format_note_values = []

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
                if not found_medium and "medium" in format_note_value.lower():
                    found_medium = True
                    format_note_values.append("medium")
                if not found_low and "low" in format_note_value.lower():
                    found_low = True
                    format_note_values.append("low")
                if not found_ultralow and "ultralow" in format_note_value.lower():
                    found_ultralow = True
                    format_note_values.append("ultralow")

                # Add a_codec_value to the list if not present
                if a_codec_value not in a_codec_values:
                    a_codec_values.append(a_codec_value)

            # Check if 'language' is in A_LANGS
            if language_value in video_properties.A_LANGS:
                if language_value not in a_lang_values:
                    a_lang_values.append(language_value)

    a_codec_values.sort()
    total_codecs = len(a_codec_values)

    # Print the unique format notes, languages, and previously solved a_codec_values
    print("\nTotal codecs", total_codecs)
    print("\nAvailable audio codecs:")
    i = 0
    for codecs in a_codec_values:
        print(i, " " + codecs)
        i += 1

    i = 0
    print("\nAvailable Languages:")
    for language in a_lang_values:
        print(i, " " + language)
        i += 1

    i = 0
    print("\nAvailable audio qualities")
    for format_note in format_note_values:
        print(i, " " + format_note)
        i += 1
# don't make any changes to the prevous part.
# everything works like a charm

# Check if user's preferred properties are found in the filtered formats
    if a_codec in a_codec_values:
        print(f"Preferred audio codec '{a_codec}' found.")
    else:
        print(f"Preferred audio codec '{a_codec}' not found.")

    if format_note.lower() in format_note_values:
        print(f"Preferred format note '{format_note}' found.")
    else:
        print(f"Preferred format note '{format_note}' not found.")

    if a_lang in a_lang_values:
        print(f"Preferred audio language '{a_lang}' found.")
    else:
        print(f"Preferred audio language '{a_lang}' not found.")
    
    # User's preferred values
    user_a_codec = 'mp4a.40.2'
    user_format_note = 'low'
    user_a_lang = 'en'

    # Initialize a variable to store the matching format_id
    matching_format_id = None

    # Iterate through the formats to find a match
    for format_info in formats:
        if all(key in format_info for key in ['acodec', 'format_note', 'language']):
            if (
                format_info['acodec'] == user_a_codec and
                format_info['format_note'].lower() == user_format_note.lower() and
                format_info['language'] == user_a_lang
            ):
                matching_format_id = format_info['format_id']
                break  # Stop searching after finding a match

    # Check if a matching format_id was found
    if matching_format_id:
        print("Matching Format ID:", matching_format_id)
    else:
        print("No matching format found.")
