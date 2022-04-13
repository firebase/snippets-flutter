import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:flutter/material.dart';

import '../snippets/firestore_odm/user_model.dart';

// Not currently in the docs, so not currently being tested.
class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<UserQuerySnapshot>(
        ref: usersRef,
        builder: (context, AsyncSnapshot<UserQuerySnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return const Text('Something went wrong!');
          if (!snapshot.hasData) return const Text('Loading users...');

          // Access the QuerySnapshot
          UserQuerySnapshot querySnapshot = snapshot.requireData;

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the User instance
              User user = querySnapshot.docs[index].data;

              return Text('User name: ${user.name}, age ${user.age}');
            },
          );
        });
  }
}
