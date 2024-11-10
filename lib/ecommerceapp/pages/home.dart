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

  @override
  void initState() {
    getOntheLoad();
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];
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
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
        queryResultSet.forEach((element) {
          //String str = element['UpdateName'];
          setState(() {
            tempSearchStore.add(element);
          });
        });
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        String str = element['UpdateName'];
        if (str.startsWith(capitalizedValue)) {
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
                                    Text("Hi, " + name!,
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
                                      height: 220,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 15.0),
                                              margin:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/ecommerce-images/headphone2.png",
                                                    height: 100.0,
                                                    width: 120.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Text(
                                                    "Headphone",
                                                    style: AppWidget
                                                            .semiboldTextStyle()
                                                        .copyWith(
                                                            fontSize: 14.0),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rs 3000",
                                                        style: AppWidget
                                                            .lightTextStyle(),
                                                      ),
                                                      SizedBox(
                                                        width: 45.0,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0)),
                                                        child: Icon(Icons.add,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 15.0),
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/ecommerce-images/laptop2.png",
                                                  height: 100.0,
                                                  width: 120.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  "Laptop",
                                                  style: AppWidget
                                                          .semiboldTextStyle()
                                                      .copyWith(fontSize: 14.0),
                                                ),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rs 20000",
                                                      style: AppWidget
                                                          .lightTextStyle(),
                                                    ),
                                                    SizedBox(
                                                      width: 45.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.amber,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0)),
                                                      child: Icon(Icons.add,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 15.0),
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/ecommerce-images/watch2.png",
                                                  height: 100.0,
                                                  width: 120.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  "Watch",
                                                  style: AppWidget
                                                          .semiboldTextStyle()
                                                      .copyWith(fontSize: 14.0),
                                                ),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Rs 8000",
                                                      style: AppWidget
                                                          .lightTextStyle(),
                                                    ),
                                                    SizedBox(
                                                      width: 45.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.amber,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0)),
                                                      child: GestureDetector(
                                                          onTap: () {},
                                                          child: Icon(Icons.add,
                                                              color: Colors
                                                                  .white)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
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
