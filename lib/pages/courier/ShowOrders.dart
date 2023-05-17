import 'package:flutter/material.dart';
import 'AcceptedBidsPage.dart';
import 'RejectedBidsPage.dart';

class ShowOrders extends StatelessWidget {
  const ShowOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcceptedBidsPage(),
                  ),
                );
              },
              child: Text('Accepted Bids'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RejectedBidsPage(),
                  ),
                );
              },
              child: Text('Rejected Bids'),
            ),
          ],
        ),
      ),
    );
  }
}
