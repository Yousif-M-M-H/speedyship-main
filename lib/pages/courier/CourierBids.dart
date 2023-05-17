import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourierBidsForm extends StatefulWidget {
  final String userId;
  final String shipmentId;

  const CourierBidsForm({required this.userId, required this.shipmentId});

  @override
  _CourierBidsFormState createState() => _CourierBidsFormState();
}

class _CourierBidsFormState extends State<CourierBidsForm> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> submitBid(BuildContext context) async {
    final int price = int.tryParse(priceController.text) ?? 0;
    final String date = dateController.text.trim();
    final String selectedUserId = widget.userId;
    final String shipmentId = widget.shipmentId;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedUserId)
        .get();

    final String selectedUsername =
        '${userData.get('firstName')} ${userData.get('lastName')}';

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    if (currentUser != null) {
      final String currentUserId = currentUser.uid;
      final String bidId =
          FirebaseFirestore.instance.collection('bids').doc().id;

      await FirebaseFirestore.instance.collection('bids').doc(bidId).set({
        'courierId':
            currentUserId, // Id of the user who placed the bid (courier)
        'userId': selectedUserId, // Id of the user who the bid is for (user)
        'shipmentId': shipmentId, // Id of the shipment
        'price': price,
        'date': date,
      });

      // Clear the text fields after submitting
      priceController.clear();
      dateController.clear();

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bid Submitted'),
            content: Text('Your bid has been submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courier Bid"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => submitBid(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
