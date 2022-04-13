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
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_snippets_app/snippets/analytics.dart';
import 'package:firebase_snippets_app/snippets/auth.dart';
import 'package:firebase_snippets_app/snippets/cloud_functions.dart';
import 'package:firebase_snippets_app/snippets/cloud_messaging.dart';
import 'package:firebase_snippets_app/snippets/cloud_storage.dart';
import 'package:firebase_snippets_app/snippets/crashlytics.dart';
import 'package:firebase_snippets_app/snippets/database.dart';
import 'package:firebase_snippets_app/snippets/dynamic_links.dart';
import 'package:firebase_snippets_app/snippets/firebase_performance.dart';
import 'package:firebase_snippets_app/snippets/firestore.dart';
import 'package:firebase_snippets_app/snippets/ml_model_downloader.dart';
import 'package:firebase_snippets_app/snippets/remote_config.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.firestore,
    required this.firebaseRemoteConfig,
    this.initialLink,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseRemoteConfig firebaseRemoteConfig;
  final PendingDynamicLinkData? initialLink;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    final List<DocSnippet> _allSnippets = [
      // Build Products
      AuthenticationSnippets(),
      RealtimeDatabaseSnippets(),
      FirestoreSnippets(widget.firestore),
      CloudStorageSnippets(),
      MLModelDownloaderSnippets(),
      CloudFunctionsSnippets(),

      // Release and Monitor Products
      CrashlyticsSnippets(),
      FirebasePerformanceMonitoringSnippets(),

      // Engage Products
      AnalyticsSnippets(),
      RemoteConfigSnippets(widget.firebaseRemoteConfig),
      CloudMessagingSnippets(),
      DynamicLinkSnippets(),
    ];

    for (var snippet in _allSnippets) {
      snippet.runAll();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Snippet Test'),
        ),
        body: HomePage(
          initialLink: widget.initialLink,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    this.initialLink,
  }) : super(key: key);

  final PendingDynamicLinkData? initialLink;

  @override
  Widget build(BuildContext context) {
    // [START receive_dynamic_link_handle_initial_link]
    if (initialLink != null) {
      final Uri? deepLink = initialLink!.link;
      // Example of using the dynamic link to push the user to a different screen
      Navigator.pushNamed(context, deepLink!.path);
    }
    // [END receive_dynamic_link_handle_initial_link]

    // [START receive_dynamic_link_listen_in_background]
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      // Handle errors
    });
    // [END receive_dynamic_link_listen_in_background]

    return Container();
  }
}
