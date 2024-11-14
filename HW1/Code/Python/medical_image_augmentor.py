# #!/usr/bin/env python3
# #    Developer: Mohammad Sadegh Kalami Yazdi
# #    ID: 402811068
# #pip3 install numpy matplotlib albumentations opencv-python 
import albumentations as A
from albumentations.core.transforms_interface import ImageOnlyTransform
import cv2
import numpy as np
import matplotlib.pyplot as plt

class RandomBiasFieldArtifact(ImageOnlyTransform):
    def __init__(self, severity=1, p=1.0):
        super(RandomBiasFieldArtifact, self).__init__(always_apply=True, p=p)
        self.severity = severity

    def apply(self, image, **params):
        rows, cols = image.shape[:2]
        X, Y = np.meshgrid(np.linspace(-1,1,cols), np.linspace(-1,1,rows))
        bias = np.exp(- (X**2 + Y**2))
        bias_field = 1 + 0.5 * bias
        bias_field = np.repeat(bias_field[:, :, np.newaxis], 3, axis=2)
        augmented = image * bias_field
        augmented = np.clip(augmented, 0, 255).astype(image.dtype)
        return augmented

class RandomMotionArtifact(ImageOnlyTransform):
    def __init__(self, severity=1, p=1.0):
        super(RandomMotionArtifact, self).__init__(always_apply=True, p=p)
        self.severity = severity

    def apply(self, image, **params):
        size = np.random.randint(5, 15)
        angle = np.random.uniform(0, 360)
        M = cv2.getRotationMatrix2D((size/2, size/2), angle, 1)
        kernel = np.ones((size, size), dtype=np.float32)
        kernel = cv2.warpAffine(kernel, M, (size, size))
        kernel /= np.sum(kernel)
        blurred = cv2.filter2D(image, -1, kernel)
        return blurred

class RandomSpikeArtifact(ImageOnlyTransform):
    def __init__(self, severity=1, p=1.0):
        super(RandomSpikeArtifact, self).__init__(always_apply=True, p=p)

    def apply(self, image, **params):
        spikes = np.random.randint(5, 15)
        for _ in range(spikes):
            x = np.random.randint(0, image.shape[1])
            y = np.random.randint(0, image.shape[0])
            image[y, x] = 255
        return image

class RandomGhostingArtifact(ImageOnlyTransform):
    def __init__(self, severity=1, p=1.0):
        super(RandomGhostingArtifact, self).__init__(always_apply=True, p=p)

    def apply(self, image, **params):
        ghost = image.copy()
        shift = np.random.randint(5, 20)
        M = np.float32([[1, 0, shift], [0, 1, 0]])
        ghost = cv2.warpAffine(ghost, M, (image.shape[1], image.shape[0]))
        blended = cv2.addWeighted(image, 0.8, ghost, 0.2, 0)
        return blended

class MedicalImageAugmentor:
    def __init__(self):
        self.augmentations = [
            ("Horizontal Flip", A.HorizontalFlip(p=1.0)),
            ("Vertical Flip", A.VerticalFlip(p=1.0)),
            ("Rotation", A.Rotate(limit=15, p=1.0)),
            ("Affine Transformation", A.Affine(scale=(0.95, 1.05), rotate=(-10, 10), shear=(-5, 5), p=1.0)),
            ("Elastic Transformation", A.ElasticTransform(alpha=1, sigma=30, p=1.0)),
            ("Motion Blur", A.MotionBlur(blur_limit=(3, 5), p=1.0)),
            ("Gaussian Blur", A.GaussianBlur(blur_limit=(3, 5), p=1.0)),
            ("Median Blur", A.MedianBlur(blur_limit=3, p=1.0)),
            ("Gaussian Noise", A.GaussNoise(var_limit=(5.0, 20.0), p=1.0)),
            ("ISO Noise", A.ISONoise(p=1.0)),
            ("Multiplicative Noise", A.MultiplicativeNoise(multiplier=(0.95, 1.05), p=1.0)),
            ("Brightness/Contrast", A.RandomBrightnessContrast(brightness_limit=0.1, contrast_limit=0.1, p=1.0)),
            ("Bias Field Artifact", RandomBiasFieldArtifact(p=1.0)),
            ("Motion Artifact", RandomMotionArtifact(p=1.0)),
            ("Spike Artifact", RandomSpikeArtifact(p=1.0)),
            ("Ghosting Artifact", RandomGhostingArtifact(p=1.0)),
        ]

    def apply_augmentation(self, image, augmentation):
        transform = A.Compose([augmentation])
        augmented = transform(image=image)
        return augmented['image']

    def get_augmented_images(self, image):
        augmented_images = []
        for name, aug in self.augmentations:
            augmented_image = self.apply_augmentation(image, aug)
            augmented_images.append((name, augmented_image))
        return augmented_images

if __name__ == "__main__":
    augmentor = MedicalImageAugmentor()
    image_path = r'D:\My-Documants\PhD\Term_03_1403\HW1_402811068\HW1\img10.png'
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    if image is None:
        raise FileNotFoundError(f"Image not found at the path: {image_path}")
    image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)
    augmented_images = augmentor.get_augmented_images(image)
    num_augmentations = len(augmented_images)
    cols = 4
    rows = (num_augmentations + cols - 1) // cols
    plt.figure(figsize=(20, 5 * rows))
    plt.subplot(rows + 1, cols, 1)
    plt.title('Original Image')
    plt.imshow(cv2.cvtColor(image, cv2.COLOR_RGB2GRAY), cmap='gray')
    plt.axis('off')
    for idx, (name, aug_img) in enumerate(augmented_images, start=2):
        plt.subplot(rows + 1, cols, idx)
        plt.title(name)
        if aug_img.shape[2] == 3:
            plt.imshow(cv2.cvtColor(aug_img, cv2.COLOR_RGB2GRAY), cmap='gray')
        else:
            plt.imshow(aug_img, cmap='gray')
        plt.axis('off')
    plt.tight_layout()
    plt.show()

