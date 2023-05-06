import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speedyship/pages/shipments/shipmentForm.dart';
import 'package:speedyship/pages/shipments/showShipments.dart';
import 'admin/admin_main.dart';
import 'introduction/EditUserInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'introduction/signup.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //signout
  void signout() {
    FirebaseAuth.instance.signOut();
  }

  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Flutter App'),
          actions: [IconButton(onPressed: signout, icon: Icon(Icons.logout))],
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                'Welcome to my Flutter app!',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdminHome(),
                    ),
                  );
                },
                child: Text("Admin page")),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditUserInfo(),
                    ),
                  );
                },
                child: Text("Edit profile")),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: Text("Sign Up")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShipmentForm(),
                    ),
                  );
                },
                child: Text("Shipment form")),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShipmentList(),
                  ),
                );
              },
              child: Text("added shipment"),
            ),
          ],
        ),
      ),
    );
  }
}
