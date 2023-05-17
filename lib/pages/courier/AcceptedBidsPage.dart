import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AcceptedBidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    final String currentUserId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Bids'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('acceptedBids')
            .where('courierId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No accepted bids available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              final String bidId = data['bidId'];
              final String courierId = data['courierId'];
              final int price = data['price'];
              final String date = data['date'];
              final String shipmentId = data['shipmentId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(courierId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Shipment ID: $shipmentId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Courier ID: $courierId'),
                          Text('Price: $price'),
                          Text('Date: $date'),
                        ],
                      ),
                    );
                  }

                  final Map<String, dynamic> userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final String firstName = userData['firstName'];
                  final String lastName = userData['lastName'];

                  return ListTile(
                    title: Text('Shipment ID: $shipmentId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Courier: $firstName $lastName'),
                        Text('Price: $price'),
                        Text('Date: $date'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
