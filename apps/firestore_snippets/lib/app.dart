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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firestore_snippets/snippets/cloud_messaging.dart';
import 'package:firestore_snippets/snippets/firestore.dart';
import 'package:firestore_snippets/snippets/remote_config.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.firestore,
    required this.firebaseRemoteConfig,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseRemoteConfig firebaseRemoteConfig;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirestoreSnippets _firestoreSnippets;
  late final RemoteConfigSnippets _remoteConfigSnippets;
  late final CloudMessagingSnippets _cloudMessagingSnippets;

  @override
  void initState() {
    _firestoreSnippets = FirestoreSnippets(widget.firestore);
    _remoteConfigSnippets = RemoteConfigSnippets(widget.firebaseRemoteConfig);
    _cloudMessagingSnippets = CloudMessagingSnippets();

    _firestoreSnippets.runAll();
    _remoteConfigSnippets.runAll();
    _cloudMessagingSnippets.runAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Snippet Test'),
        ),
      ),
    );
  }
}
