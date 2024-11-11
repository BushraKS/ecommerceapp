import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/pages/category_products.dart';
import 'package:functionalitydemo/ecommerceapp/pages/product_details.dart';
import 'package:functionalitydemo/ecommerceapp/services/database.dart';
import 'package:functionalitydemo/ecommerceapp/services/shared_pref.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name, img;

  List categories = [
    "assets/images/ecommerce-images/headphone_icon.png",
    "assets/images/ecommerce-images/laptop.png",
    "assets/images/ecommerce-images/watch.png",
    "assets/images/ecommerce-images/TV.png"
  ];

  List categoryList = ["Headphone", "Laptop", "Watch", "TV"];

  getSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    img = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  getOntheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  getListOnLoad() {
    DatabaseMethods().search("a").then((QuerySnapshot docs) {
      print(docs.docs.length);
      productListSize = docs.docs.length;
      for (int i = 0; i < productListSize; i++) {
        queryResultSet.add(docs.docs[i].data());
      }
      queryResultSet.forEach((element) {
        setState(() {
          customList.add(element);
        });
      });
    });
  }

  @override
  void initState() {
    getOntheLoad();
    getListOnLoad();
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];
  var customList = [];
  var productListSize;
  bool search = false;

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {});
    }
    setState(() {
      search = true;
    });

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1).toUpperCase();
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        print(docs.docs.length);
        productListSize = docs.docs.length;
        for (int i = 0; i < productListSize; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
        queryResultSet.forEach((element) {
          String str = element['SearchKey'];

          if (str.startsWith(str)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        String str = element['UpdateName'];

        if (str.startsWith(capitalizedValue) ||
            str.contains(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
          child: (img == null || name == null)
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Hi, " + name!.toUpperCase(),
                                        style: AppWidget.boldTextStyle()),
                                    Text(
                                      "Good morning",
                                      style: AppWidget.lightTextStyle(),
                                    ),
                                  ]),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    img!,
                                    height: 70.0,
                                    width: 70.0,
                                    fit: BoxFit.cover,
                                  )),
                            ]),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Products",
                              hintStyle: AppWidget.lightTextStyle(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        search
                            ? ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                shrinkWrap: true,
                                itemCount: tempSearchStore.length,
                                itemBuilder: (context, index) {
                                  var el = tempSearchStore.map((element) {
                                    return buildListItem(element);
                                  }).toList();
                                  return el[index];
                                },
                              )
                            : Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Categories",
                                            style:
                                                AppWidget.semiboldTextStyle()),
                                        Text("see all",
                                            style: AppWidget.semiboldTextStyle()
                                                .copyWith(
                                                    color: Colors.amber,
                                                    fontSize: 14.0)),
                                      ]),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        padding: EdgeInsets.all(15.0),
                                        margin: EdgeInsets.only(right: 15.0),
                                        child: Center(
                                            child: Text("All",
                                                style: AppWidget
                                                        .semiboldTextStyle()
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14.0))),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 120,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: categories.length,
                                              itemBuilder: (context, index) {
                                                return CategoryTile(
                                                    image: categories[index],
                                                    title: categoryList[index]);
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("All Products",
                                            style:
                                                AppWidget.semiboldTextStyle()),
                                        Text("see all",
                                            style: AppWidget.semiboldTextStyle()
                                                .copyWith(
                                                    color: Colors.amber,
                                                    fontSize: 14.0)),
                                      ]),
                                  SizedBox(height: 10.0),
                                  SizedBox(
                                    height: 300,
                                    child: getCustomList(),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget buildListItem(element) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              element["Image"],
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            Text(element['UpdateName']),
          ],
        ));
  }

  getCustomList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: customList.length,
      itemBuilder: (context, index) {
        var el = customList.map((element) {
          return buildCustomListItem(element);
        }).toList();
        return el[index];
      },
    );
  }

  buildCustomListItem(element) {
    return Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(right: 5.0),
        width: 150,
        height: 150,
        child: Column(
          children: [
            Image.network(
              element["Image"],
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10.0,),
            Text(
              element['UpdateName'],
              style: AppWidget.semiboldTextStyle().copyWith(fontSize: 12.0),
            ),
            SizedBox(height: 10.0,),
            GestureDetector(
              onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDetails(name: element["Product"],price: element["Price"], image: element["Image"],details: element["Details"],))),
              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                    child: Text(
                                  "Buy Now",
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
            )
          ],
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final String image, title;
  const CategoryTile({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryProducts(
                category: title,
              ))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
