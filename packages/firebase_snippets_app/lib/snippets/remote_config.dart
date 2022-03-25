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

// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class RemoteConfigSnippets extends DocSnippet {
  final FirebaseRemoteConfig firebaseRemoteConfig;

  RemoteConfigSnippets(this.firebaseRemoteConfig);

  @override
  void runAll() {}

  void getStarted_setMinimumIntervalFetch() {
    // [START get_started_set_minimum_interval_fetch]
    firebaseRemoteConfig.settings.minimumFetchInterval =
        const Duration(milliseconds: 3600000);
    // [END get_started_set_minimum_interval_fetch]
  }

  void getStarted_setDefaultValues() {
    // [START get_started_set_default_values]
    firebaseRemoteConfig.setDefaults(<String, dynamic>{
      'welcome_message': 'this is the default welcome message',
    });
    // [END get_started_set_default_values]
  }

  void getStarted_getDefaultValues() {
    // [START get_started_get_default_values]
    final val = firebaseRemoteConfig.getValue("welcome_messsage");
    // [END get_started_get_default_values]
  }

  void getStarted_fetchAndActivateValues() {
    // [START get_started_fetch_and_activate_values]
    firebaseRemoteConfig.fetchAndActivate().then((bool success) {
      if (success) {
        final updatedConfig = firebaseRemoteConfig.getAll();
        print("Config params updated: $updatedConfig");
      }
    });
    // [END get_started_fetch_and_activate_values]
  }
}
