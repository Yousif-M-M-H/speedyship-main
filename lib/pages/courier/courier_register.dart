import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class DocumentUploader extends StatefulWidget {
  @override
  _DocumentUploaderState createState() => _DocumentUploaderState();
}

Future<void> addUserStatusPending(String userId) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .update({"status": "pending"});
}

Future<String> getUserFullName(String uid) async {
  String fullName = '';
  try {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    String firstName = userData['firstName'] as String;
    String lastName = userData['lastName'] as String;
    fullName = '$firstName $lastName';
  } catch (error) {
    print('Error getting user: $error');
  }
  return fullName;
}

class _DocumentUploaderState extends State<DocumentUploader> {
  File? _file1;
  File? _file2;

  void _pickFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file1 = File(result.files.single.path!);
      });
    }
  }

  void _pickFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file2 = File(result.files.single.path!);
      });
    }
  }

  void _uploadFiles() async {
    if (_file1 != null && _file2 != null) {
      // Get the current user's ID and retrieve first name and last name from Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final firstName = userDoc.get("firstName");
      final lastName = userDoc.get("lastName");

      // Create a new folder for the user if it doesn't already exist
      final folderRef = FirebaseStorage.instance
          .ref()
          .child("courier_records/$uid/$firstName" + "_" + "$lastName");

      // Upload _file1 to Firebase Storage
      final file1Name = basename(_file1!.path);
      final file1Ref = folderRef.child(file1Name);
      await file1Ref.putFile(_file1!);

      // Upload _file2 to Firebase Storage
      final file2Name = basename(_file2!.path);
      final file2Ref = folderRef.child(file2Name);
      await file2Ref.putFile(_file2!);

      // Define uid before calling addUserStatusPending function
      final usid = currentUser!.uid;
      await addUserStatusPending(usid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile1,
              child: Text("Upload Drivers License"),
            ),
            SizedBox(height: 16),
            _file1 == null ? Text("No file selected") : Text(_file1!.path),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _pickFile2,
              child: Text("Upload Conviction Record"),
            ),
            SizedBox(height: 16),
            _file2 == null ? Text("No file selected") : Text(_file2!.path),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _uploadFiles,
              child: Text("Upload Files"),
            ),
          ],
        ),
      ),
    );
  }
}
