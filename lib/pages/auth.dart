import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedyship/pages/courier/courier_main.dart';
import 'package:speedyship/pages/introduction/login.dart';
import 'package:speedyship/pages/homepage.dart';
import 'package:speedyship/pages/introduction/signup.dart';
import 'package:speedyship/pages/user/user_main_page.dart';
//import 'package:speedyship/pages/admin/admin_main_page.dart';
//import 'package:speedyship/pages/courier/courier_main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if user is logged in
          if (snapshot.hasData) {
            // Get the user's ID
            String uid = snapshot.data!.uid;
            // Get the user's role from Firestore
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  // Get the user's role
                  String role = snapshot.data!.get('role');
                  // Check the user's role and return the appropriate page
                  if (role == 'admin') {
                    return HomePage();
                  } else if (role == 'user') {
                    return UserMainPage();
                  } else if (role == 'courier') {
                    return CourierMainPage();
                  } else {
                    return LoginPage();
                  }
                } else {
                  return LoginPage();
                }
              },
            );
          } else {
            // User is not logged in, show the login page
            return LoginPage();
          }
        },
      ),
    );
  }
}
