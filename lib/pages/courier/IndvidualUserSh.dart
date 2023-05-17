import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'CourierBids.dart';

class IndividualUserShipment extends StatelessWidget {
  final String location;
  final String destination;
  final String category;
  final int height;
  final int weight;
  final int width;
  final int length;
  final String username;
  final String userId;
  final String shipmentId;

  const IndividualUserShipment({
    required this.location,
    required this.destination,
    required this.category,
    required this.height,
    required this.weight,
    required this.width,
    required this.length,
    required this.username,
    required this.userId,
    required this.shipmentId,
  });

  Future<bool> checkIfBidPlaced(String userId, String shipmentId) async {
    // Check if the courier has already placed a bid for this shipment
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bids')
        .where('userId', isEqualTo: userId)
        .where('shipmentId', isEqualTo: shipmentId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Shipment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Destination: $destination',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Height: $height',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Weight: $weight',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Width: $width',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Length: $length',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 18),
            ),
            Center(
              child: ElevatedButton(
                child: Text("Make a bid"),
                onPressed: () async {
                  final bidPlaced = await checkIfBidPlaced(userId, shipmentId);
                  if (bidPlaced) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Bid Already Placed'),
                          content: Text(
                              'You have already placed a bid for this shipment.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourierBidsForm(
                          userId: userId,
                          shipmentId: shipmentId,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
