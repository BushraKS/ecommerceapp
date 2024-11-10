import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/firebasestoragedemo/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Reference> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    getUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Storage"),
        centerTitle: true,
      ),
      body: _buildUI(context),
      floatingActionButton: _uploadMediaButton(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (_uploadedFiles.isEmpty) {
      return Center(
        child: Text("No files uploaded yet"),
      );
    }
    return ListView.builder(
        itemCount: _uploadedFiles.length,
        itemBuilder: (context, index) {
          Reference ref = _uploadedFiles[index];
          return FutureBuilder(
              future: ref.getDownloadURL(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: Image.network(snapshot.data!),
                    title: Text(ref.name),
                  );
                }
                return Container();
              });
        });
  }

  Widget _uploadMediaButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        File? selectedImage = await getMediaFromGallery(context);
        print(selectedImage);
        if (selectedImage != null) {
          await uploadFileForUser(selectedImage);
          getUploadedFiles();
        }
      },
      child: Icon(Icons.upload),
    );
  }

  void getUploadedFiles() async {
    List<Reference>? list = await getUserUploadedFiles();
    if (list != null) {
      setState(() {
        _uploadedFiles = list;
      });
    }
  }
}
