import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/admin/add_product.dart';
import 'package:functionalitydemo/ecommerceapp/admin/admin_login.dart';
import 'package:functionalitydemo/ecommerceapp/pages/bottom_nav.dart';
import 'package:functionalitydemo/ecommerceapp/pages/home.dart';
import 'package:functionalitydemo/ecommerceapp/pages/login.dart';
import 'package:functionalitydemo/ecommerceapp/pages/onboarding.dart';
import 'package:functionalitydemo/ecommerceapp/pages/product_details.dart';
import 'package:functionalitydemo/ecommerceapp/pages/signup.dart';
import 'package:functionalitydemo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Signup(), 
      //home: AdminLogin(),
      //home: AddProduct(),
      //home: BottomNav(),
    );
  }
}
