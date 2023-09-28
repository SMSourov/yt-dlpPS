from python_imports import video_properties
from python_imports.audio_function import audio_function
import json
import subprocess

# # Prompt the user to enter the video URL
# video_url = input("Enter the video URL: ")
# 
# # Print the entered URL (optional, for verification)
# print("Entered URL:", video_url)
# 
# # Get the temp file
# get_temp_file = "python3 ./yt-dlp \"" + video_url + "\" --write-info-json --skip-download --windows-filenames -o temp"
# try:
#     print("Capturing temp file")
#     output = subprocess.check_output(get_temp_file, shell=True, stderr=subprocess.STDOUT, text=True)
# except subprocess.CalledProcessError as e:
#     print("Error occured \n", e.stderr)
#     exit()

# Read the JSON file
with open('temp.info.json', 'r') as file:
    json_file = json.load(file)

audio_function(json_file, video_properties.a_codec, video_properties.format_note, video_properties.a_lang)
# print(video_properties.a_found)
