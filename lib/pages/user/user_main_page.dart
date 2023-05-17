import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speedyship/pages/courier/become_courier.dart';
import 'package:speedyship/pages/courier/courier_main.dart';
import 'package:speedyship/pages/shipments/shipmentForm.dart';

import 'CourierRequsets.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserMainPage extends StatefulWidget {
  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  String _name = '';
  String _fname = '';
  String _lname = '';
  String _email = '';
  String _userId = '';

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = auth.currentUser;
    fetchUserData(_user!);

    //fetch the user data whenever the authentication state changes
    auth.authStateChanges().listen((user) {
      if (user != null) {
        _user = user;
        fetchUserData(user);
      }
    });
  }

  Future<void> fetchUserData(User user) async {
    final userData = await firestore.collection('users').doc(user.uid).get();
    setState(() {
      _userId = user.uid; // Store the user ID
      _fname = userData.get('firstName');
      _lname = userData.get('lastName');
      _name = ('$_fname $_lname');
      _email = userData.get('email');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              accountName: Text(_name),
              accountEmail: Text(_email),
              currentAccountPicture: CircleAvatar(
                child: Text('MA'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainProfilePage(),
                  ),
                );
              },*/
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOrders(),
                  ),
                );
              },*/
            ),
            ListTile(
              leading: Icon(Icons.star_rate),
              title: Text('Ratings'),
              /*onTap: () {
                // Add the desired functionality for Ratings here
              },*/
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              /*onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpPage(),
                  ),
                );
              },*/
            ),
            Divider(),
            Divider(),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text('Apply for Courier'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BecomeCourierPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hello text
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Hello,',
                  style: TextStyle(fontSize: 15),
                ),
              ),

              // Username text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              // Image and button container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 1,
                          blurRadius: 15)
                    ],
                  ),
                  child: Column(children: [
                    // Image
                    Container(
                      width: 300,
                      height: 200,
                      child: Image.asset(
                        'lib/images/img1.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Welcome to speedyShip
                    Text(
                      'Welcome to SpeedyShip',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BidsPage(
                                  // userId: _userId,
                                  ),
                            ),
                          );
                        },
                        child: Text("Courier Requests")),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Enjoy our fast shipping service',
                        style: TextStyle(
                            fontSize: 12,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white)),

                    //Start shipping button
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShipmentForm()));
                          },
                          child: Text('Start shipping'),
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 60),
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                    )
                  ]),
                ),
              ),

              SizedBox(
                height:
                    40, // Increased space between the big container and Quick Access section
              ),
              // Quick Access section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Access',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        _buildQuickAccessItem(
                          Icons.star_rate,
                          'Ratings',
                          Colors.teal,
                          () {},
                        ),
                        _buildQuickAccessItem(
                          Icons.shopping_cart,
                          'Orders',
                          Colors.teal,
                          () {},
                        ),
                        _buildQuickAccessItem(
                          Icons
                              .request_page, // Change the icon to 'request_page'
                          'Requests', // Change the label to 'Requests'
                          Colors.teal,
                          () {},
                        ),
                        _buildQuickAccessItem(
                          Icons.help,
                          'Help',
                          Colors.teal,
                          () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(
      IconData icon, String label, Color color, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the icons vertically
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
