from python_imports import video_properties
def audio_function(json_file, a_codec, format_note, a_lang):
    print("The slected audio codec is " + a_codec)
    print("The slected quality is " + format_note)
    print("The slected audio language is \"" + a_lang + "\" (optional)")
    print("\n")
    hasMultipleLanguages = False

    # get a list of codec
    formats = json_file['formats']
    #initialize an array
    a_codec_values = []
    for format_info in formats:
        if 'acodec' in format_info:
            a_codec_value = format_info['acodec']
            if "opus" in a_codec_value or "mp4a" in a_codec_value:
                a_codec_values.append(a_codec_value)
    a_codec_values = list(set(a_codec_values))
    a_codec_values.sort()
    total_codecs = len(a_codec_values)

    print("Total codecs available", total_codecs)
    for i in range(total_codecs):
        print(a_codec_values[i])
    
    if a_codec in a_codec_values:
        a_codec_index = a_codec_values.index(a_codec)
        print(a_codec_index)



