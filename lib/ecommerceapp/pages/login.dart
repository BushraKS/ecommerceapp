import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/pages/bottom_nav.dart';
import 'package:functionalitydemo/ecommerceapp/pages/signup.dart';
import 'package:functionalitydemo/ecommerceapp/widgets/support_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", pwd = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  loginUser() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.amber[50],
            content: Text(
              "Logged In Successfully",
              style:
                  AppWidget.semiboldTextStyle().copyWith(color: Colors.green),
            )),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } on FirebaseAuthException{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.amber[50],
            content: Text(
              "Error! Cannot Log In",
              style:
                  AppWidget.semiboldTextStyle().copyWith(color: Colors.red),
            )),
      );
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
                        child: Text("Sign In",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Colors.amber, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            pwd = pwdController.text;
                            email = emailController.text;
                          });
                        }
                        loginUser();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppWidget.lightTextStyle(),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
