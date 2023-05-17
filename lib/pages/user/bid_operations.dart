import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BidOperations {
  static void acceptBid(BuildContext context, String bidId, String courierId,
      int price, String date, String shipmentId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      return; // If the user is not logged in, do nothing
    }

    final String currentUserId = currentUser.uid;

    final acceptedBidId =
        FirebaseFirestore.instance.collection('acceptedBids').doc().id;

    await FirebaseFirestore.instance
        .collection('acceptedBids')
        .doc(acceptedBidId)
        .set({
      'bidId': bidId,
      'courierId': courierId,
      'userId': currentUserId,
      'price': price,
      'date': date,
      'shipmentId': shipmentId,
    });

    await FirebaseFirestore.instance
        .collection('bids')
        .doc(bidId)
        .delete(); // Remove the bid from the 'bids' collection

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid accepted successfully.'),
      ),
    );
  }

  static void declineBid(BuildContext context, String bidId, String courierId,
      int price, String date, String shipmentId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    if (currentUser == null) {
      return; // If the user is not logged in, do nothing
    }

    final String currentUserId = currentUser.uid;

    final declinedBidId =
        FirebaseFirestore.instance.collection('declinedBids').doc().id;

    await FirebaseFirestore.instance
        .collection('declinedBids')
        .doc(declinedBidId)
        .set({
      'bidId': bidId,
      'courierId': courierId,
      'userId': currentUserId,
      'price': price,
      'date': date,
      'shipmentId': shipmentId,
    });

    await FirebaseFirestore.instance
        .collection('bids')
        .doc(bidId)
        .delete(); // Remove the bid from the 'bids' collection

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid declined successfully.'),
      ),
    );
  }
}
