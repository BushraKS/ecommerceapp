import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255,234,235,231),
        body: SafeArea(
          child: Column(
              children:[
                  Image.asset("assets/images/ecommerce-images/headphone.PNG"),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("Explore\nthe best products", style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.0,),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                        ),
                        child: Text("Next", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15.0),),
                      ),
                    ],
                  )
              ]
          ),
        )
    );
  }
}