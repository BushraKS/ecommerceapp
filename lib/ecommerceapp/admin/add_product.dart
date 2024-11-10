import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/services/database.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final List<String> categoryList = ["Watch", "Laptop", "TV", "Headphone"];
  String? myitem = "Headphone";
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadProduct() async {
    if (selectedImage != null &&
        productController.text != "" &&
        priceController.text != "" &&
        detailsController.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference storageRef =
          FirebaseStorage.instance.ref().child("ecomm").child(addId);

      final UploadTask task = storageRef.putFile(selectedImage!);
      final downloadUrl = await (await task).ref.getDownloadURL();

      String firstLetter = productController.text.substring(0, 1);

      Map<String, dynamic> addProduct = {
        "Product": productController.text,
        "SearchKey": firstLetter,
        "UpdateName": productController.text.toUpperCase(),
        "Image": downloadUrl,
        "Price": priceController.text,
        "Details": detailsController.text,
      };

      await DatabaseMethods()
          .addProductDetails(addProduct, myitem!)
          .then((value) async {
        await DatabaseMethods().addAllProducts(addProduct);
        setState(() {
          selectedImage = null;
          productController.text = "";
          priceController.text = "";
          detailsController.text = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.amber[50],
              content: Text(
                "Product added Successfully",
                style:
                    AppWidget.semiboldTextStyle().copyWith(color: Colors.green),
              )),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("ADD PRODUCT", style: AppWidget.semiboldTextStyle()),
      ),
      body: Container(
        margin:
            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the product image",
                style: AppWidget.lightTextStyle(),
              ),
              SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                onTap: () => getImage(),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: selectedImage == null
                        ? Icon(Icons.camera_alt_outlined)
                        : Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ))),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Name",
                style: AppWidget.lightTextStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: productController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter product name",
                    hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Product Category",
                style: AppWidget.lightTextStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryList
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                            )))
                        .toList(),
                    hint: Text(
                      "Select Category",
                      style: AppWidget.lightTextStyle(),
                    ),
                    iconSize: 30.0,
                    onChanged: (String? value) {
                      setState(() {
                        myitem = value;
                      });
                    },
                    value: myitem,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Price",
                style: AppWidget.lightTextStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter product price",
                    hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Product Details",
                style: AppWidget.lightTextStyle(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextField(
                  maxLines: 5,
                  controller: detailsController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter product details",
                    hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () => uploadProduct(),
                    child: Text(
                      "Add Product",
                      style: AppWidget.lightTextStyle().copyWith(
                          fontWeight: FontWeight.w600, color: Colors.black54),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
