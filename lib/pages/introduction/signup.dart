import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedyship/components/my_textfield.dart';
import 'package:speedyship/components/square_tile.dart';
import 'package:speedyship/components/my_button.dart';
import 'package:speedyship/components/my_button2.dart';
import 'package:speedyship/pages/auth.dart';
import 'package:speedyship/components/date_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:speedyship/pages/introduction/login.dart';
import 'package:speedyship/services/auth_service.dart';
import '../../components/image_picker.dart';
import 'package:speedyship/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  DateTime? _selectedDate;
  //text controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final repeatController = TextEditingController();

  final fnameController = TextEditingController();

  final lnameController = TextEditingController();

  final phonecontroller = TextEditingController();

  //sign up a user
  Future<void> signup() async {
    try {
      // Create user account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      final selectedDate = _selectedDate?.toIso8601String();

      // Add user data to Firestore collection
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'email': emailController.text,
        'firstName': fnameController.text,
        'lastName': lnameController.text,
        'PhoneNumber': phonecontroller.text,
        'DateOfBirth': selectedDate,
        'image': imageUrl,
        'role': 'user',
      });

      //Login a user after they sign up
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign-up errors here
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  String imageUrl = '';

  //rest of the code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 50),
              //logo
              Image.asset('lib/images/speedyshiptp.png'),

              const SizedBox(height: 50),
              //welcome back
              Text(
                'Welcome to SpeedyShip!',
                style: TextStyle(color: Colors.grey[700], fontSize: 18),
              ),

              const SizedBox(height: 25),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.grey),
                ),
                child: Stack(
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageUrl == null || imageUrl.isEmpty)
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera),
                          color: Colors.grey[600],
                          onPressed: () async {
                            String imageUrl = await uploadImage();
                            setState(() {
                              this.imageUrl = imageUrl;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              //username
              MyTextField(
                controller: emailController,
                hintText: 'Email Address',
                obscureText: false,
              ),

              const SizedBox(height: 15),
              //pwd
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),
              //repeat
              MyTextField(
                  controller: repeatController,
                  hintText: 'Repeat your password',
                  obscureText: true),

              const SizedBox(height: 15),

              //firstname
              MyTextField(
                controller: fnameController,
                hintText: 'First Name',
                obscureText: false,
              ),

              const SizedBox(height: 15),
              //last name
              MyTextField(
                controller: lnameController,
                hintText: 'Last Name',
                obscureText: false,
              ),

              const SizedBox(height: 15),
              //dob
              MyDatePicker(
                onDateSelected: (date) => setState(
                  () => _selectedDate = date,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ),

              const SizedBox(height: 15),

              MyTextField(
                  controller: phonecontroller,
                  hintText: "Phone Number",
                  obscureText: false),

              const SizedBox(height: 25),
              //sign in button
              MyButton2(
                onTap: () => signup(),
                buttonText: 'Sign Up',
              ),
              const SizedBox(height: 50),
              //or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[500],
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 50),
              //google and apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagepath: 'lib/images/google.png',
                  ),
                  SizedBox(width: 20),
                  //apple button
                  SquareTile(
                    onTap: () {
                      print("apple is pressed");
                    },
                    imagepath: 'lib/images/apple.png',
                  ),
                ],
              ),

              const SizedBox(height: 50),

              //not a mem? register

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      'Sign in now',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
