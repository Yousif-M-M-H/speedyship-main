import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFileListPage extends StatelessWidget {
  final String userId;
  final String firstName;
  final String lastName;

  UserFileListPage({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    final userFilesRef = FirebaseStorage.instance
        .ref()
        .child("courier_records/$userId/$firstName" + "_" + "$lastName");

    return Scaffold(
      appBar: AppBar(
        title: Text('User File List'),
      ),
      body: FutureBuilder(
        future: userFilesRef.listAll(),
        builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data!.items[index];
                return ListTile(
                  title: Text(item.name),
                  onTap: () {
                    // TODO: Implement a way to view the file contents or download the file
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving user files'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
