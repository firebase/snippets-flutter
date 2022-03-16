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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firestore_snippets/snippets/snippet.dart';

class CloudFunctionsSnippets implements DocSnippet {
  late final FirebaseFunctions functions;

  CloudFunctionsSnippets() {
    functions = FirebaseFunctions.instance;
  }

  @override
  void runAll() {
    // TODO: implement runAll
  }

  // [START call_functions_from_your_app_call_the_function]
  Future<HttpsCallableResult> addMessage(String text) {
    final data = {
      "text": text,
      "push": true,
    };

    final addMessage = functions.httpsCallable("addMessage");
    return addMessage(data);
  }
  // [END call_functions_from_your_app_call_the_function]

  void callFunctionsFromYourApp_handleErrorsOnTheClient() {
    // [START call_functions_from_your_app_handle_errors_on_the_client]
    final addMessage = functions.httpsCallable("addMessage");
    addMessage({"text": "message text"}).then(
      // Read result of the Cloud Function.
      (result) => print(result.data['text']),
      onError: (e) => print("Error calling function: $e"),
    );
    // [END call_functions_from_your_app_handle_errors_on_the_client]
  }
}
