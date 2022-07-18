import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/model/user_model.dart';
import 'package:sample/screens/home_screen.dart';
import 'package:sample/screens/login_screen.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sample/screens/security_screen.dart';
import 'package:sample/screens/verify_passcode.dart';
import 'package:sample/screens/verify_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'screens/login_screen.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
 Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: Future.value(SharedPreferences.getInstance()),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        User? user = FirebaseAuth.instance.currentUser;
        Widget widget;
        if(user != null) {
          final String? pattern = snapshot.data?.getString(user.uid);
          Fluttertoast.showToast(msg: "$pattern");
          if (pattern != null) {
            widget = const VerifyPattern();
          }
          else {
            widget = const VerifyPasscode();
          }
        }
        else{
          widget = const LoginScreen();
        }
        return MaterialApp(
            color: Colors.white,
            home: widget,
            debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}