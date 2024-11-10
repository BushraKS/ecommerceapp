import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/services/shared_pref.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? img, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    img = await SharedPreferenceHelper().getUserImage();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getOntheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    getOntheLoad();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadProduct();
    setState(() {});
  }

  uploadProduct() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference storageRef =
          FirebaseStorage.instance.ref().child("ecomm").child(addId);

      final UploadTask task = storageRef.putFile(selectedImage!);
      final downloadUrl = await (await task).ref.getDownloadURL();

      await SharedPreferenceHelper().saveUserImage(downloadUrl);
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        centerTitle: true,
        title: Text("PROFILE", style: AppWidget.boldTextStyle()),
      ),
      body: img == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Column(children: [
                GestureDetector(
                  onTap: () => getImage(),
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            img!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                  )),
                ),
                Container(
                  margin: EdgeInsets.only(top:25.0,right:15.0,left:15.0),
                  child: Column(
                    children: [
                      Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 4.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.person_outlined, size: 30.0,),
                          SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("Name", style: AppWidget.lightTextStyle(),),
                             Text(name!, style: AppWidget.semiboldTextStyle(),),
                          ],
                        )
                      ],),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 4.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined, size: 30.0,),
                          SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("Email", style: AppWidget.lightTextStyle(),),
                             Text(email!, style: AppWidget.semiboldTextStyle(),),
                          ],
                        )
                      ],),
                    ),
                  ),
                   SizedBox(height: 20.0,),
                  Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 4.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Icon(Icons.logout_outlined, size: 30.0,),
                          SizedBox(width: 10.0,),
                        Text("Logout", style: AppWidget.semiboldTextStyle(),),
                        Spacer(),
                        Icon(Icons.arrow_forward_outlined)
                      ],),
                    ),
                  ),
                    ],
                  )
                ),
              ]),
            ),
    );
  }
}
