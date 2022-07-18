import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/model/user_model.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sample/screens/verify_passcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({Key? key, User? currentUser}) : super(key: key);

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    //text editing controller
    final passcodeEditingController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Passcode"
        ),
      ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    ),
                  Container(
                    child: PinCodeTextField(
                      autofocus: true,
                      controller: passcodeEditingController,
                      highlightColor: Colors.green,
                      defaultBorderColor: Colors.black,
                      maskCharacter: "*",
                      maxLength: 4,
                      pinBoxRadius: 15.0,
                      onDone: (passcodeEditingController){
                        save(passcodeEditingController, user!);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VerifyPasscode()));
                      },
                    ),
                  )
                ],
              ),
              ),
            ),
          ),
        ),
      );
    }
    void save(passcodeEditingController, User user) async{
        final prefs = await SharedPreferences.getInstance();
        int pin = int.parse(passcodeEditingController);
        prefs.setInt(user.uid, pin);
        Fluttertoast.showToast(msg: "${prefs.containsKey(user.uid)}");
    }
}



