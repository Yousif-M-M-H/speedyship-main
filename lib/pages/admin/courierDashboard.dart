import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String phoneNumber;
  String address;

  User(this.name, this.email, this.phoneNumber, this.address);
}

class CourierDashboard extends StatefulWidget {
  @override
  _CourierDashboardState createState() => _CourierDashboardState();
}

class _CourierDashboardState extends State<CourierDashboard> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'courier')
        .get();

    final List<User> users = snapshot.docs
        .map((doc) => User(
            doc['firstName'], doc['email'], doc['PhoneNumber'], doc['role']))
        .toList();

    setState(() {
      this.users = users;
    });
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void deleteUser(User user) {
    setState(() {
      users.remove(user);
    });
  }

  void editUser(BuildContext context, User user) {
    TextEditingController nameController =
        TextEditingController(text: user.name);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);
    TextEditingController addressController =
        TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    user.name = nameController.text;
                    user.email = emailController.text;
                    user.phoneNumber = phoneController.text;
                    user.address = addressController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(9, 147, 120, 1.0),
        title: Text('Courier Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromRGBO(9, 147, 120, 1.0),
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(user.phoneNumber),
                          Text(user.address),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: Color.fromARGB(255, 18, 146, 77)),
                          onPressed: () {
                            editUser(context, user);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: Color.fromARGB(255, 222, 114, 25)),
                          onPressed: () {
                            deleteUser(user);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
