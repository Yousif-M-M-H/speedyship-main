import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'UserFileListPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String status;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.status});
}

class NewCourierPage extends StatefulWidget {
  @override
  _NewCourierPageState createState() => _NewCourierPageState();
}

class _NewCourierPageState extends State<NewCourierPage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() async {
    // Get a reference to the "users" collection in Firestore
    final usersRef = FirebaseFirestore.instance.collection('users');

    // Query the "users" collection for users with a "pending" status
    final querySnapshot =
        await usersRef.where('status', isEqualTo: 'pending').get();

    // Convert the QuerySnapshot to a list of User objects
    final users = querySnapshot.docs
        .map((doc) => User(
            id: doc.id,
            firstName: doc.get('firstName'),
            lastName: doc.get('lastName'),
            status: doc.get('status')))
        .toList();

    // Set the _users list and update the state
    setState(() {
      _users = users;
    });
  }

  Future<void> _approveUser(User user) async {
    // Get a reference to the user's document in Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);

    // Update the user's role to "courier"
    await userRef.update({'role': 'courier'});

    // Remove the status field from the user's document
    await userRef.update({
      'status': FieldValue.delete(),
    });

    // Remove the user from the _users list and update the state
    setState(() {
      _users.remove(user);
    });
  }

  Future<void> _denyUser(User user) async {
    // Get a reference to the user's document in Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);

    // Remove the "status" field from the user's document
    await userRef.update({'status': FieldValue.delete()});

    // Remove the user from the _users list and update the state
    setState(() {
      _users.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Courier'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text('Status: ${user.status}'),
                  onTap: () {
                    // Navigate to the user's file list page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserFileListPage(
                          userId: user.id,
                          firstName: user.firstName,
                          lastName: user.lastName,
                        ),
                      ),
                    );
                  },
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () => _approveUser(user),
                      child: Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () => _denyUser(user),
                      child: Text('Deny'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
