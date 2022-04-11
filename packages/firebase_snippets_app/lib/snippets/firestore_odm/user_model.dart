// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:firebase_snippets_app/snippets/firestore_odm/address_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
    required this.name,
    required this.age,
    required this.email,
    required this.address,
  }) {
    _$assertUser(this);
  }

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  final String name;
  final String email;
  final Address address;

  @Min(0)
  final int age;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
// [END defining_models]

// [START references_collection_ref]
@Collection<User>('users')
@Collection<Address>('users/*/addresses')
final usersRef = UserCollectionReference();
// [END references_collection_ref]
