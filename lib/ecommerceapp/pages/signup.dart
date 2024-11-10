import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/pages/bottom_nav.dart';
import 'package:functionalitydemo/ecommerceapp/pages/login.dart';
import 'package:functionalitydemo/ecommerceapp/services/database.dart';
import 'package:functionalitydemo/ecommerceapp/services/shared_pref.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? name, email, pwd;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registerUser() async {
    if (pwd != null && name != null && email != null) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: pwd!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.amber[50],
              content: Text(
                "Registered Successfully",
                style:
                    AppWidget.semiboldTextStyle().copyWith(color: Colors.green),
              )),
        );
        String randomId = randomAlphaNumeric(10);
        String img =
            "https://static.vecteezy.com/system/resources/previews/020/707/618/non_2x/hand-drawing-cartoon-girl-wearing-hijab-with-smile-face-vector.jpg";

        await SharedPreferenceHelper().saveUserId(randomId);
        await SharedPreferenceHelper().saveUserImage(img);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
       

        Map<String, dynamic> userinfoMap = {
          "Name": nameController.text,
          "Email": emailController.text,
          "Id": randomId,
          "Image": img,
        };
        await DatabaseMethods().addUserDetails(userinfoMap, randomId);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.amber[50],
                content: Text(
                  "Password too weak",
                  style:
                      AppWidget.semiboldTextStyle().copyWith(color: Colors.red),
                )),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.amber[50],
                content: Text(
                  "Email already exists",
                  style:
                      AppWidget.semiboldTextStyle().copyWith(color: Colors.red),
                )),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/ecommerce-images/login.png"),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                          child: Text("Sign Up",
                              style: AppWidget.semiboldTextStyle())),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                          child: Text("Kindly enter details to continue",
                              style: AppWidget.lightTextStyle())),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("Name", style: AppWidget.semiboldTextStyle()),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFF4F5F9),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your name",
                            hintStyle: AppWidget.lightTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Email", style: AppWidget.semiboldTextStyle()),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFF4F5F9),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your email",
                            hintStyle: AppWidget.lightTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
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
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          controller: pwdController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your password",
                            hintStyle: AppWidget.lightTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              pwd = pwdController.text;
                              name = nameController.text;
                              email = emailController.text;
                            });
                          }
                          registerUser();
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
                                child: Text("SIGN UP",
                                    style: AppWidget.semiboldTextStyle()
                                        .copyWith(color: Colors.white))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: AppWidget.lightTextStyle(),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
