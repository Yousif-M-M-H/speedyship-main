import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'IndvidualUserSh.dart';

// import 'individual_user_shipment.dart';

class ShowShipments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('shipments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final shipments = snapshot.data!.docs;
            return ListView.builder(
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];

                // Retrieve the shipment data
                final location = shipment.get('location');
                final destination = shipment.get('destination');
                final category = shipment.get('category');
                final height = shipment.get('height');
                final weight = shipment.get('weight');
                final width = shipment.get('width');
                final length = shipment.get('length');

                // Retrieve the username based on userId
                final userId = shipment.get('userId');

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasData) {
                      final username = userSnapshot.data!.get('firstName');

                      return ListTile(
                        title: Text(username),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: $location'),
                            Text('Destination: $destination'),
                            Text('Category: $category'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualUserShipment(
                                location: location,
                                destination: destination,
                                category: category,
                                height: height,
                                weight: weight,
                                width: width,
                                length: length,
                                username: username,
                                userId: userId,
                                shipmentId:
                                    shipment.id, // pass the shipmentId here
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (userSnapshot.hasError) {
                      return ListTile(
                        title: Text('Error retrieving username'),
                      );
                    }
                    return ListTile(
                      title: Text('Loading username...'),
                    );
                  },
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving shipments'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
