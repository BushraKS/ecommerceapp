import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((onData) {
      setState(() {
        _user = onData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google SignIn"),
      ),
      body: _user != null ? _userInfo(context) : _googleSignIn(context),
    );
  }

  Widget _googleSignIn(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(
          Buttons.google,
          onPressed: _handleSignIn,
          text: "Sign in with Google",
        ),
      ),
    );
  }

  Widget _userInfo(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  _user!.photoURL!,
                ),
              ),
            ),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
              color: Colors.deepPurple,
              child: Text("SIGN OUT"),
              onPressed: _auth.signOut),
        ]));
  }

  void _handleSignIn() {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleProvider);
    } catch (err) {
      print(err);
    }
  }
}
