import 'dart:io';

import 'package:Insta_Clone/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Storage {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r"userProfile_(.*).jpg");
      photoId = exp.firstMatch(url)[1];
    }

    StorageUploadTask uploadTask = storageRef
        .child("images/users/userProfile_$photoId.jpg")
        .putFile(image);
    StorageTaskSnapshot storageSanp = await uploadTask.onComplete;
    String downloadURL = await storageSanp.ref.getDownloadURL();
    return downloadURL;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      "$path/img_$photoId.jpg",
      quality: 70,
    );
    return compressedImageFile;
  }
}