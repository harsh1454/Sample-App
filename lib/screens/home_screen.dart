import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/model/user_model.dart';
import 'package:sample/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,
              child: Image.asset("assets/logo.jpg", fit: BoxFit.contain,),
              ),
              Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              SizedBox(height: 10,),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                )
              ),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  )
              ),
              SizedBox(height: 15,),
              ActionChip(label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
