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

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firestore_snippets/snippets/snippet.dart';

class CrashlyticsSnippets implements DocSnippet {
  @override
  void runAll() {}

  void getStarted_forceATestCrash() {
    // [START get_started_force_a_test_crash]
    FirebaseCrashlytics.instance.crash();
    // [END get_started_force_a_test_crash]
  }
}
