import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';

class ProductDetails extends StatefulWidget {
  final String name, price, image, details;
  const ProductDetails(
      {super.key,
      required this.name,
      required this.price,
      required this.image,
      required this.details});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                        fit: BoxFit.fill,
                        widget.image,
                        height: MediaQuery.of(context).size.width*0.7),
                  )),
                   Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0), shape: BoxShape.circle),
                        child: Icon(Icons.arrow_back_ios_new_outlined,weight: 900, color: Colors.black,),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: AppWidget.semiboldTextStyle().copyWith(fontSize: 14.0),
                          ),
                          Text(
                            "Rs "+widget.price,
                            style: AppWidget.semiboldTextStyle()
                                .copyWith(color: Colors.amber,fontSize: 14.0),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text("Details",
                          style: AppWidget.lightTextStyle()
                              .copyWith(fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              widget.details,
                            ),
                            
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.3, bottom: 10.0),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Text(
                                "Buy Now",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            )
                          ],
                        ),
                      ),
                    ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
