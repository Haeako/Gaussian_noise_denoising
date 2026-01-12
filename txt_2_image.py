from PIL import Image
import numpy as np

def convert_txt_to_image(txt_file, output_image, width, height):
    with open(txt_file, 'r') as f:
        pixels = [int(line.strip()) for line in f if line.strip()]
        total_pixels = width * height
        if len(pixels) < total_pixels:
            pixels.extend([0] * (total_pixels - len(pixels)))
        pixel_matrix = np.array(pixels, dtype=np.uint8).reshape((height, width))
        img = Image.fromarray(pixel_matrix)
        img.save(output_image)
W = 430 
H = 554
INPUT_TXT = "pic_output.txt"
OUTPUT_IMG = "assert/output.png"

convert_txt_to_image(INPUT_TXT, OUTPUT_IMG, W, H)