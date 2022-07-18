

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sample/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample/model/user_model.dart';
import 'package:sample/screens/home_screen.dart';



class VerifyPasscode extends StatefulWidget {
  const VerifyPasscode({Key? key}) : super(key: key);

  @override
  State<VerifyPasscode> createState() => _VerifyPasscodeState();
}

class _VerifyPasscodeState extends State<VerifyPasscode> {
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController passcodeEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Enter Passcode"
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
                      onDone: (passcodeEditingController) async {
                        final prefs = await SharedPreferences.getInstance();
                        final int pin = prefs.getInt(user!.uid) ?? 0;
                        int input = int.parse(passcodeEditingController);
                        Fluttertoast.showToast(msg: "$pin");
                        if(pin == input){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                        }
                        else{
                          Fluttertoast.showToast(msg: "Pin does not match");
                        }
                      }
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

  /*Future<bool> verifyPasscode(passcodeEditingController, User? user) async {
      final prefs = await SharedPreferences.getInstance();
      final int passcode = prefs.getInt(user!.uid) ?? 0;
      Fluttertoast.showToast(msg: "${prefs.containsKey(user.uid)}");
      Fluttertoast.showToast(msg: "$passcode");
      bool flag = false;
      if(passcode == passcodeEditingController){
        flag = true;
      }
      else{
        Fluttertoast.showToast(msg: "Pin does not match");
      }
      return flag;
  }*/

}


