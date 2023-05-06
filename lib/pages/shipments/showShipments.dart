import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShipmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('shipments').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong. Please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot> shipments = snapshot.data!.docs;
        if (shipments.isEmpty) {
          return Center(
            child: Text(
              'No shipment available.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        QueryDocumentSnapshot currentShipment = shipments.last;

        return Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Shipment',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text('Category: ${currentShipment['category']}'),
                SizedBox(height: 8.0),
                Text('Destination: ${currentShipment['destination']}'),
                SizedBox(height: 8.0),
                Text('Location: ${currentShipment['location']}'),
                SizedBox(height: 8.0),
                Text('City: ${currentShipment['city']}'),
                SizedBox(height: 8.0),
                Text('Height: ${currentShipment['height']}'),
                SizedBox(height: 8.0),
                Text('Length: ${currentShipment['length']}'),
                SizedBox(height: 8.0),
                Text('Width: ${currentShipment['width']}'),
                SizedBox(height: 16.0),
                Text('Age: ${currentShipment['weight']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
