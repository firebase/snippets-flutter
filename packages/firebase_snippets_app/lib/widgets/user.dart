// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:flutter/material.dart';

import '../snippets/firestore_odm/user_model.dart';

// Not currently in the docs, so not currently being tested.
class UserLabel extends StatelessWidget {
  const UserLabel(this.id);

  final String id;

  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<UserDocumentSnapshot>(
        // Access a specific document
        ref: usersRef.doc(id),
        builder: (context, AsyncSnapshot<UserDocumentSnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return const Text('Something went wrong!');
          if (!snapshot.hasData) return const Text('Loading user...');

          // Access the UserDocumentSnapshot
          UserDocumentSnapshot documentSnapshot = snapshot.requireData;

          if (!documentSnapshot.exists) {
            return const Text('User does not exist.');
          }

          User user = documentSnapshot.data!;

          return Text('User name: ${user.name}, age ${user.age}');
        });
  }
}
