from PIL import Image
# open image as grayscale image
img = Image.open("assert/input.jpg").convert("L")

# get size
w, h = img.size
# debug
print(f"imgsize {w}x{h}")
# load pixel
px = img.load()
# write to output file
with open("pic_input.txt", "w") as f:
    for y in range(h):
        for x in range(w):
            f.write(f"{px[x,y]}\n")