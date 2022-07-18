import 'package:flutter/material.dart';
import 'package:sample/screens/passcode_screen.dart';
import 'package:sample/screens/pattern_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final setPatternBtn = Material(
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PatternScreen()));
        },
        child: Text(
          "Set Pattern",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
    final setPasscodeBtn = Material(
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PasscodeScreen()));
        },
        child: Text(
            "Set Passcode",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("App Security"),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 50,),
          Icon(Icons.security,size: 80,textDirection: TextDirection.rtl,),
          SizedBox(height: 80,),
          Text(
            "Secure your account",
            textAlign: TextAlign.left,
            /*style: TextStyle(
              fontSize: 50,
              color: Colors.black,
              fontFamily: 'Hind',
            ),*/
            style: GoogleFonts.lato(fontSize: 50),
          ),
          const SizedBox(height: 40,),
          setPasscodeBtn,
          const SizedBox(height: 15,),
          setPatternBtn,
        ],
      ),
    );
  }
}
