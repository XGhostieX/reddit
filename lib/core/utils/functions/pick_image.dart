import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../service_locator.dart';
import 'display_message.dart';

Future<File?> pickImage(WidgetRef ref) async {
  try {
    final ImagePicker picker = ref.read(imagePickerProvider);
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  } catch (e) {
    displayMessage(e.toString(), true);
    return null;
  }
}
