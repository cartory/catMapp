import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Dialog for selectImageSource
/// Must call with Get.dialog :)
Future<ImageSource?> selectImageSource() async {
  return await Get.defaultDialog<ImageSource?>(
    title: 'Select Source',
    titleStyle: const TextStyle(fontSize: 17),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: .15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          label: const Text('Gallery'),
          icon: const Icon(Icons.photo_library),
          onPressed: () => Get.back<ImageSource>(result: ImageSource.gallery),
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey, width: .15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          label: const Text('Camera'),
          icon: const Icon(Icons.camera_alt),
          onPressed: () => Get.back(result: ImageSource.camera),
        ),
      ],
    ),
  );
}
