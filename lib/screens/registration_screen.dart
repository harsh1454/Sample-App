import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/model/user_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sample/screens/passcode_screen.dart';
import 'package:sample/screens/pattern_screen.dart';
import 'package:sample/screens/security_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth =FirebaseAuth.instance;
  //form key
  final _formKey = GlobalKey<FormState>();
  //editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //FirstName Field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("Firsy name cannot be empty");
        }
        if(!regex.hasMatch(value)){
          return ("Enter a valid Password(Min 3 characters)");
        }
      },
      onSaved: (value){
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //SecondName Field
    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if(value!.isEmpty){
          return ("First name cannot be empty");
        }
        return null;
      },
      onSaved: (value){
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator:(value) {
        if(value!.isEmpty){
          return ("Please enter your email");
        }
        //reg exp for email val
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value) || !EmailValidator.validate(value)){
          return ("Please enter a valid email");
        }
        return null;
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

    //Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if(value!.isEmpty){
          return ("Password required");
        }
        if(!regex.hasMatch(value)){
          return ("Password should be at least 8 characters long"
                  "\nAt least 1 upper case, 1 lower case"
                  "\n1 digit(0-9)"
                  "\n1 special character(!@#\$&*~)");
        }
      },
      onSaved: (value){
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //confirmPassword Field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator:(value) {
        if(passwordEditingController.text.length > 6 && passwordEditingController.text != confirmPasswordEditingController.text){
          return ("Password doesn't match");
        }
        return null;
      },
      onSaved: (value){
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    //signup button
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text("Register", textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                      SizedBox(height: 45,),
                      firstNameField,
                      SizedBox(height: 20,),
                      secondNameField,
                      SizedBox(height: 20,),
                      emailField,
                      SizedBox(height: 20,),
                      passwordField,
                      SizedBox(height: 20,),
                      confirmPasswordField,
                      SizedBox(height: 20,),
                      signupButton,
                      SizedBox(height: 15,),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postDetailsToFirestore(),
      }).catchError((err){
        Fluttertoast.showToast(msg: err!.message);
      });
    }
  }


  postDetailsToFirestore() async{
    //calling firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    //calling user model
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    //send the values
    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context)=> SecurityScreen()), (route) => false);
  }
}
