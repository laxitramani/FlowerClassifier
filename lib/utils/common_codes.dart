import 'dart:io';
import 'package:image_picker/image_picker.dart';

getImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(
    source: source,
    imageQuality: 10,
  );
  return File(image != null ? image.path : "");
}
