import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speedyship/pages/courier/newcourierpage.dart';
import 'UserDashboard.dart';
import 'courierDashboard.dart';
import 'ProductsDashboard.dart';

class AdminHome extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminHome> {
  Color iconColor = Color.fromRGBO(231, 123, 0, 1.0);

  Widget _buildDashboardButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 180,
      width: 180,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: iconColor,
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 75, 75, 75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(9, 147, 120, 1.0),
        title: Center(child: Text('Welcome Admin')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDashboardButton('USERS', Icons.people, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDashboard()),
                  );
                }),
                SizedBox(width: 16),
                _buildDashboardButton('COURIERS', Icons.local_shipping, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourierDashboard()),
                  );
                }),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDashboardButton('SHIPMENT', Icons.inventory, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsDashboard()),
                  );
                }),
                SizedBox(width: 16),
                _buildDashboardButton('APPLICANTS', Icons.local_shipping, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewCourierPage()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
