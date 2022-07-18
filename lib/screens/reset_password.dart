import 'package:flutter/material.dart';
import 'package:sample/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _formKey = GlobalKey<FormState>();
  /*User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  void initState(){
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }*/
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //password field
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
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
    //reset password btn
    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          reset(emailController.value.text);
        },
        child: Text("Send Reset Link", textAlign: TextAlign.center,
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
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          emailField,
                          SizedBox(height: 25,),
                          resetButton,
                        ],
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
  void reset(String email) async {
    if(_formKey.currentState!.validate()){
      await _auth.sendPasswordResetEmail(email: email);
    }
  }
}
