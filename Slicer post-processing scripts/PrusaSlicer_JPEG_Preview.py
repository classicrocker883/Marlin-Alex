#!/usr/bin/python
import sys
import re
import os
import base64 
import io
import subprocess

try:
    from PIL import Image
except ImportError:
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow"])
    from PIL import Image
    
def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

sourceFile = sys.argv[1]

# Read the ENTIRE g-code file into memory
with open(sourceFile, "r") as f:
    lines = f.read()

thumb_expresion = '; thumbnail begin.*?\n((.|\n)*?); thumbnail end'
size_expresion = '; thumbnail begin [0-9]+x[0-9]+ [0-9]+'
size_expresion_group = '; thumbnail begin [0-9]+x[0-9]+ ([0-9]+)'

thumb_matches = re.findall(thumb_expresion, lines)
size_matches = re.findall(size_expresion, lines)

def encodedStringToGcodeComment(encodedString):
    n = 78
    return '; ' + '\n; '.join(encodedString[i:i+n] for i in range(0, len(encodedString), n)) + '\n'


for idx, match in enumerate(thumb_matches):
    original = match[0]
    encoded = original.replace("; ", "")
    encoded = encoded.replace("\n", "")
    encoded = encoded.replace("\r", "")
    decoded = base64.b64decode(encoded)
    img_png = Image.open(io.BytesIO(decoded))
    img_png_rgb = img_png.convert('RGB')
    img_byte_arr = io.BytesIO()
    img_png_rgb.save(img_byte_arr, format='jpeg', quality=85 if idx == 0 else 60, optimize=True)
    img_byte_arr = img_byte_arr.getvalue()
    encodedjpg = base64.b64encode(img_byte_arr).decode("utf-8")
    encodedjpg_gcode = encodedStringToGcodeComment(encodedjpg)
    lines = lines.replace(original, encodedjpg_gcode)

    size_match = size_matches[idx]
    size = re.findall(size_expresion_group, size_match)
    new_size = size_match.replace(size[0], str(len(encodedjpg)))
    lines = lines.replace(size_match, new_size)

lines = lines.replace("; thumbnail begin", "; jpeg thumbnail begin")

# destFile = re.sub('\.gcode$','',sourceFile)
# # os.rename(sourceFile,destFile+".bak")
# destFile = re.sub('\.gcode$','',sourceFile)
# destFile = destFile + '.gcode'

with open(sourceFile, "w") as of:
    of.write(lines)
    
of.close()
f.close()
