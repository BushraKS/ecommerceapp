import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/pages/product_details.dart';
import 'package:functionalitydemo/ecommerceapp/services/database.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  final String category;
  const CategoryProducts({super.key, required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream<QuerySnapshot>? categoryStream;

  getOnLoad() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  Widget allProduct() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (builder, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductDetails(name: doc["Product"],price: doc["Price"], image: doc["Image"],details: doc["Details"],))),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              doc["Image"],
                              height: 150.0,
                              width: 220.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                                doc["Product"],
                                style: AppWidget.semiboldTextStyle()
                                    .copyWith(fontSize: 10.0),
                              ),
                              Spacer(),
                              Text("Rs "+doc["Price"],style: AppWidget.semiboldTextStyle()
                                    .copyWith(fontSize: 12.0),),
                    
                        ],
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(child: allProduct()),
            ],
          ),
        ),
      ),
    );
  }
}
