import cv2
from skimage.metrics import structural_similarity as ssim

def calculate_metrics(original_path, processed_path):
    # 1. read grayscale image
    img_org = cv2.imread(original_path, cv2.IMREAD_GRAYSCALE)
    img_proc = cv2.imread(processed_path, cv2.IMREAD_GRAYSCALE)
    # 3. get PSNR
    psnr_val = cv2.PSNR(img_org, img_proc)

    # 4. get SSIM
    score, _ = ssim(img_org, img_proc, full=True)

    print("-" * 30)
    print(f"PSNR: {psnr_val:.2f} dB")
    print(f"SSIM: {score:.4f}")
    print("-" * 30)

# run
calculate_metrics(r"assert\output.png", r"assert\baitap1_anhgoc.jpg")