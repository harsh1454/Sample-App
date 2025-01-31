import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/screens/home_screen.dart';
import 'package:sample/screens/registration_screen.dart';
import 'package:sample/screens/reset_password.dart';
import 'package:sample/screens/verify_passcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sample/screens/verify_pattern.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controller


  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase auth
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator:(value) {
        if(value!.isEmpty){
          return ("Please enter your email");
        }
        //reg exp for email val
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return ("Please enter a valid email");
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ("Password required");
        }
        if(!regex.hasMatch(value)){
          return ("Enter a valid Password");
        }
    },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //login button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          signIn(emailController.text, passwordController.text);
          },
        child: const Text("Login", textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      "assets/logo.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 45,),
                  emailField,
                  const SizedBox(height: 25,),
                  passwordField,
                  const SizedBox(height: 35,),
                  loginButton,
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account? "),
                      GestureDetector(onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegistrationScreen()));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResetPassword()));
                  },
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
            )
          ),
        ),
      ),
    );
  }

  //login fn
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
      {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false),
      }).catchError((err) {
        Fluttertoast.showToast(msg: err!.message);
      });
    }
  }

}
