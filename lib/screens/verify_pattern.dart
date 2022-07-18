import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:sample/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import 'home_screen.dart';

class VerifyPattern extends StatefulWidget {
  const VerifyPattern({Key? key}) : super(key: key);

  @override
  State<VerifyPattern> createState() => _VerifyPatternState();
}

class _VerifyPatternState extends State<VerifyPattern> {
  final _auth = FirebaseAuth.instance;
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Check Pattern"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
                child: PatternLock(
                  selectedColor: Colors.red,
                  pointRadius: 8,
                  showInput: true,
                  dimension: 3,
                  relativePadding: 0.7,
                  selectThreshold: 25,
                  fillPoints: true,
                  onInputComplete: (List<int> input) async {
                    final prefs = await SharedPreferences.getInstance();
                    final String? pattern = prefs.getString(user!.uid);
                    String inp = utf8.decode(input);
                    Fluttertoast.showToast(msg: "$pattern");
                    if(inp == pattern){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                    }
                  },
                ))

          ],

        )
    );
  }
}
