// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// [START set_up_environment]
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
// [END set_up_environment]

import 'package:firebase_snippets_app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  // [START get_firestore_instance]
  /// In the Firebase documentation, the code should look like the following example
  /// In this snippets app, we're using the FlutterFire CLI to generate FirebaseOptions
  ///```dart
  /// WidgetsFlutterBinding.ensureInitialized();
  /// await Firebase.initializeApp(
  ///   options: const FirebaseOptions(
  ///     apiKey: '### FIREBASE API KEY ###',
  ///     authDomain: '### FIREBASE AUTH DOMAIN ###',
  ///     projectId: '### CLOUD FIRESTORE PROJECT ID ###'
  ///   )
  /// );
  /// final firestore = FirebaseFirestore.instance;
  /// ```
  // [END get_firestore_instance]

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;
  // [START access_data_offline_configure_offline_persistence]
  final settings = db.settings.copyWith(persistenceEnabled: true);
  // [END access_data_offline_configure_offline_persistence]

  // [START access_data_offline_configure_offline_persistence]
  final updatedSettings =
      db.settings.copyWith(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  db.settings = settings;
  // [END access_data_offline_configure_offline_persistence]

  // [START get_started_get_singleton_object]
  FirebaseRemoteConfig firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  // [END get_started_get_singleton_object]

  // [START auth_persistingAuthState]
  await FirebaseAuth.instance.setPersistence(Persistence.NONE);
  // [END auth_persistingAuthState]

  if (!kReleaseMode) db.useFirestoreEmulator('localhost', 8080);

  runApp(
    MyApp(
      firestore: db,
      firebaseRemoteConfig: firebaseRemoteConfig,
    ),
  );
}
