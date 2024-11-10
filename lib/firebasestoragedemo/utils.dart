import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';

Future<void> signInAnonymous() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("UID of current user is: ${userCredential.user?.uid}");
  } catch (e) {
    print(e);
  }
}

Future<File?> getMediaFromGallery(BuildContext context) async {
  List<MediaFile>? singleMedia;
  try {
    singleMedia =
        await GalleryPicker.pickMedia(context: context, singleMedia: true);
  } catch (e) {
    print(e);
  }
  return singleMedia?.first.getFile();
}

Future<bool> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final filName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$filName");
    uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}

Future<List<Reference>?> getUserUploadedFiles() async {
  late List<Reference>? uploadsList;
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadRef = storageRef.child("$userId/uploads");
    final uploads = await uploadRef.listAll();
    uploadsList = uploads.items;
  } catch (e) {
    print(e);
  }
  return uploadsList;
}
