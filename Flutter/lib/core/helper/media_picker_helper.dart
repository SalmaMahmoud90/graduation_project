import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a_tareqaak/core/resources/app_colors.dart';
import 'package:a_tareqaak/core/resources/app_values.dart';
import 'package:a_tareqaak/presentation/widgets/text/body_title.dart';

class MediaPickerHelper {
  final ImagePicker picker = ImagePicker();
  List<XFile> selectedImages = [];
  XFile? selectedImage;
  XFile? selectedVideo;

  Future<List<String>> pickImages() async {
    try {
      // Clear previous selection
      selectedImages = await picker.pickMultiImage();
      if (selectedImages.isEmpty) {
        debugPrint('No images selected.');
        return [];
      }

      // Map selected images to their paths
      return selectedImages.map((file) => file.path).toList();
    } catch (e) {
      debugPrint('Error picking images: $e');
      return [];
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      selectedImage = await picker.pickImage(source: ImageSource.camera);

      if (selectedImage != null) {
        final croppedImagePath = await _cropImage(selectedImage!.path);
        return croppedImagePath ?? selectedImage!.path;
      } else {
        debugPrint('No image selected.');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      selectedImage = await picker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        final croppedImagePath = await _cropImage(selectedImage!.path);
        return croppedImagePath ?? selectedImage!.path;
      } else {
        debugPrint('No image selected.');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<String?> pickVideoFromGallery() async {
    try {
      selectedVideo = await picker.pickVideo(source: ImageSource.gallery);

      if (selectedVideo != null) {
        return selectedVideo!.path;
      } else {
        debugPrint('No video selected.');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
      return null;
    }
  }
  Future<String?> pickImage(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      backgroundColor: AppColors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r13)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const BodyTitle(text: "photo_shoot", color: AppColors.blueText),
                onTap: () {
                  Navigator.pop(context, 'camera');
                },
              ),
              Divider(color: AppColors.greyDivider, height: 0, thickness: 0.7, endIndent: AppHeight.h20, indent: AppHeight.h20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const BodyTitle(text: "selection_from_gallery", color: AppColors.blueText),
                onTap: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
            ],
          ),
        );
      },
    );

    if (result == 'camera') {
      return await pickImageFromCamera();
    } else if (result == 'gallery') {
      return await pickImageFromGallery();
    }
    return null;
  }

  Future<String?> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'قص الصورة',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: AppColors.white,
            activeControlsWidgetColor: AppColors.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'قص الصورة',
          ),
        ],
      );

      return croppedFile?.path;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

}
