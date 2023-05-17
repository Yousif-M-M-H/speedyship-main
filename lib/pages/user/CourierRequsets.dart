import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bid_operations.dart'; // Replace with the correct import path

class BidsPage extends StatefulWidget {
  @override
  _BidsPageState createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  List<String> _declinedBidIds = [];
  String? _acceptedBidShipmentId;

  void _onBidDeclined(String bidId) {
    setState(() {
      _declinedBidIds.add(bidId);
    });
  }

  void _onBidAccepted(String shipmentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('acceptedShipmentId', shipmentId);
    setState(() {
      _acceptedBidShipmentId = shipmentId;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thank you for accepting a bid.')),
    );
  }

  Future<String?> getAcceptedShipmentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('acceptedShipmentId');
  }

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
        title: Text('Bids'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('bids')
            .where('userId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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

          return FutureBuilder<String?>(
            future: getAcceptedShipmentId(),
            builder: (BuildContext context,
                AsyncSnapshot<String?> shipmentIdSnapshot) {
              if (shipmentIdSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final String? acceptedShipmentId = shipmentIdSnapshot.data;

              final List<DocumentSnapshot<Map<String, dynamic>>> bidDocuments =
                  snapshot.data!.docs;

              final List<DocumentSnapshot<Map<String, dynamic>>>
                  filteredBidDocuments = bidDocuments
                      .where((document) =>
                          !_declinedBidIds.contains(document.id) &&
                          document.data()?.containsKey('shipmentId') == true &&
                          document.data()?['shipmentId'] != acceptedShipmentId)
                      .toList();

              if (filteredBidDocuments.isEmpty) {
                return Center(
                  child: Text('No bids available.'),
                );
              }

              return ListView.builder(
                itemCount: filteredBidDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot<Map<String, dynamic>> document =
                      filteredBidDocuments[index];
                  final Map<String, dynamic>? data = document.data();

                  if (data == null) {
                    // Skip rendering if data is null
                    return SizedBox.shrink();
                  }

                  final String bidId = document.id;
                  final String courierId = data['courierId'] as String;
                  final int price = data['price'] as int;
                  final String date = data['date'] as String;
                  final String shipmentId = data['shipmentId'] as String;

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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _onBidAccepted(shipmentId);
                          },
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _onBidDeclined(bidId);
                            BidOperations.declineBid(context, bidId, courierId,
                                price, date, shipmentId);
                          },
                          child: Text('Decline'),
                        ),
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
