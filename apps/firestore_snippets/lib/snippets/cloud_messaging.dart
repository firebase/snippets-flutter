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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_snippets/snippets/snippet.dart';

class CloudMessagingSnippets implements DocSnippet {
  @override
  void runAll() {
    setUp_retrieveTheCurrentRegistrationToken();
    sendATestMessage_monitorTokenRefresh();
    sendMessagesToMultipleDevices_subscribeClientAppToTopic();
    sendMessagesToMultipleDevices_onMessageReceived();
    sendMessagesToMultipleDevices_onBackgroundMessageReceived();
  }

  void setUp_retrieveTheCurrentRegistrationToken() {
    // [START set_up_retrieve_the_current_registration_token]
    FirebaseMessaging.instance.getToken().then(
          (token) => print("Received token: $token"),
          onError: (e) => print("Error completing: $e"),
        );
    // [END set_up_retrieve_the_current_registration_token]
  }

  void _sendRegistrationToServer(String t) => {};

  void sendATestMessage_monitorTokenRefresh() {
    // [START send_a_test_message_monitor_token_refresh]
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Refreshed token: $newToken");
      _sendRegistrationToServer(newToken);
    });
    // [END send_a_test_message_monitor_token_refresh]
  }

  void sendMessagesToMultipleDevices_subscribeClientAppToTopic() {
    // [START send_messages_to_multiple_devices_subscribe_client_app_to_topic]
    FirebaseMessaging.instance.subscribeToTopic("weather");
    // [END send_messages_to_multiple_devices_subscribe_client_app_to_topic]
  }

  void sendMessagesToMultipleDevices_onMessageReceived() {
    // [START send_messages_to_multiple_devices_override_on_message_received]
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("Received new message: ${event.data}");
    });
    // [END send_messages_to_multiple_devices_override_on_message_received]
  }

  void sendMessagesToMultipleDevices_onBackgroundMessageReceived() {
    // [START send_messages_to_multiple_devices_override_on_background_message_received]
    FirebaseMessaging.onBackgroundMessage((RemoteMessage event) async {
      print("Received new message: ${event.data}");
    });
    // [END send_messages_to_multiple_devices_override_on_background_message_received]
  }
}
