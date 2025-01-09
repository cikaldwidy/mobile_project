import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mailcontroller = TextEditingController();

  String email = "";

  final _formkey = GlobalKey<FormState>();

  // Fungsi untuk mereset password
  resetPassword() async {
    try {
      // Mengirim email reset password
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password Reset Email has been sent!",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "No user found for that email.",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 70.0),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Perbaiki Kata Sandi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Masukkan email anda",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: mailcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white70,
                              size: 30.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      GestureDetector(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              email = mailcontroller
                                  .text; // Menyimpan email yang dimasukkan
                            });
                            resetPassword(); // Memanggil fungsi untuk mereset password
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              "Kirim Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum Punya Akun?",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                          SizedBox(height: 50.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              " Create",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
