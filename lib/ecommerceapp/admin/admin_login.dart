import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/admin/home_admin.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/ecommerce-images/login.png"),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                        child: Text("Admin Panel",
                            style: AppWidget.semiboldTextStyle())),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Username", style: AppWidget.semiboldTextStyle()),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFF4F5F9),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your username",
                          hintStyle: AppWidget.lightTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Password", style: AppWidget.semiboldTextStyle()),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFF4F5F9),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        obscureText: true,
                        controller: pwdController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your password",
                          hintStyle: AppWidget.lightTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        loginAdmin();
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                              child: Text("LOGIN",
                                  style: AppWidget.semiboldTextStyle()
                                      .copyWith(color: Colors.white))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                )),
          ),
        ));
  }

  loginAdmin() async {
    await FirebaseFirestore.instance.collection("admin").get().then(
      (snapshot) {
        snapshot.docs.forEach((doc) {
          if (doc.data()['username'] != usernameController.text.trim()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.amber[50],
                  content: Text(
                    "Username is incorrect!",
                    style: AppWidget.semiboldTextStyle()
                        .copyWith(color: Colors.red),
                  )),
            );
          } else if (doc.data()['password'] != pwdController.text.trim()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.amber[50],
                  content: Text(
                    "Password is incorrect!",
                    style: AppWidget.semiboldTextStyle()
                        .copyWith(color: Colors.red),
                  )),
            );
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeAdmin()));
          }
        });
      },
    );
  }
}
