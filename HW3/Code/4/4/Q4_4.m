clear;close all;clc

MRI_image = imread('..\..\..\chest-ct-scan.jpg');
gray_image = im2double(rgb2gray(MRI_image));

noisy_image_10db = awgn(gray_image,10);
noisy_image_15db = awgn(gray_image,15);
noisy_image_20db = awgn(gray_image,20);

psnr_noisy_image_10db = psnr(noisy_image_10db,gray_image);
psnr_noisy_image_15db = psnr(noisy_image_15db,gray_image);
psnr_noisy_image_20db = psnr(noisy_image_20db,gray_image);
%% Heat_Explicit_Diffusion

temp_image = [];
temp_image = imresize(gray_image, [256 256]);

Heat_explicit(noisy_image_10db, 0.2);
Heat_explicit_10db = Heat_explicit(noisy_image_10db, 0.5);
Heat_explicit(noisy_image_10db, 0.8);
psnr_Heat_explicit_10db = psnr(Heat_explicit_10db, temp_image);

Heat_explicit_15db = Heat_explicit(noisy_image_15db, 0.2);
Heat_explicit(noisy_image_15db, 0.5);
Heat_explicit(noisy_image_15db, 0.8);
psnr_Heat_explicit_15db = psnr(Heat_explicit_15db, temp_image);

Heat_explicit_20db = Heat_explicit(noisy_image_20db, 0.2);
Heat_explicit(noisy_image_20db, 0.5);
Heat_explicit(noisy_image_20db, 0.8);
psnr_Heat_explicit_20db = psnr(Heat_explicit_20db, temp_image);
%% Non_Anisotropic_Diffusion

temp_image = [];
temp_image = imresize(gray_image, [256 256]);

non_aniso(noisy_image_10db, 0.2);
non_aniso_10db = non_aniso(noisy_image_10db, 0.5);
non_aniso(noisy_image_10db, 0.8);
psnr_non_aniso_10db = psnr(non_aniso_10db, temp_image);

non_aniso_15db = non_aniso(noisy_image_15db, 0.2);
non_aniso(noisy_image_15db, 0.5);
non_aniso(noisy_image_15db, 0.8);
psnr_non_aniso_15db = psnr(non_aniso_15db, temp_image);

non_aniso_20db = non_aniso(noisy_image_20db, 0.2);
non_aniso(noisy_image_20db, 0.5);
non_aniso(noisy_image_20db, 0.8);
psnr_non_aniso_20db = psnr(non_aniso_20db, temp_image);
%% Heat_Implicit_Diffusion

temp_image = [];
temp_image = imresize(gray_image, [256 256]);

Heat_imp(noisy_image_10db, 0.2);
Heat_imp_10db = Heat_imp(noisy_image_10db, 0.5);
Heat_imp(noisy_image_10db, 0.8);
psnr_Heat_imp_10db = psnr(Heat_imp_10db, temp_image);

Heat_imp_15db = Heat_imp(noisy_image_15db, 0.2);
Heat_imp(noisy_image_15db, 0.5);
Heat_imp(noisy_image_15db, 0.8);
psnr_Heat_imp_15db = psnr(Heat_imp_15db, temp_image);

Heat_imp_20db = Heat_imp(noisy_image_20db, 0.2);
Heat_imp(noisy_image_20db, 0.5);
Heat_imp(noisy_image_20db, 0.8);
psnr_Heat_imp_20db = psnr(Heat_imp_20db, temp_image);
%% Inhomogeneous_Isotropic_Diffusion

temp_image = [];
temp_image = imresize(gray_image, [256 256]);

Inhomo_iso(noisy_image_10db, 0.2);
Inhomo_iso_10db = Inhomo_iso(noisy_image_10db, 0.5);
Inhomo_iso(noisy_image_10db, 0.8);
psnr_Inhomo_iso_10db = psnr(Inhomo_iso_10db, temp_image);

Inhomo_iso_15db = Inhomo_iso(noisy_image_15db, 0.2);
Inhomo_iso(noisy_image_15db, 0.5);
Inhomo_iso(noisy_image_15db, 0.8);
psnr_Inhomo_iso_15db = psnr(Inhomo_iso_15db, temp_image);

Inhomo_iso_20db = Inhomo_iso(noisy_image_20db, 0.2);
Inhomo_iso(noisy_image_20db, 0.5);
Inhomo_iso(noisy_image_20db, 0.8);
psnr_Inhomo_iso_20db = psnr(Inhomo_iso_20db, temp_image);
