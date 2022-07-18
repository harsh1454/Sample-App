import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:sample/model/user_model.dart';
import 'package:sample/screens/verify_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternScreen extends StatefulWidget {
  const PatternScreen({Key? key}) : super(key: key);

  @override
  State<PatternScreen> createState() => _PatternScreenState();
}

class _PatternScreenState extends State<PatternScreen> {
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
        title: Text("Set Pattern"),
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
              onInputComplete: (List<int> input) {
                save(input, user);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyPattern()));
              },
            ))

          ],

        )
    );
  }
  void save(List<int> input, User? user) async{
    final prefs = await SharedPreferences.getInstance();
    String pattern = utf8.decode(input);
    prefs.setString(user!.uid, pattern);
  }
}
