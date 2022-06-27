// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:flutter/foundation.dart';

class RealtimeDatabaseSnippets implements DocSnippet {
  @override
  void runAll() {
    start_initializeDatabase();
    readAndWrite_grabAReference();
    listsOfData_appendToAList();
    offline_keepSynced();
    offline_fullExample();
  }

  void start_initializeDatabase() async {
    // [START start_initialize_database]
    final FirebaseDatabase database = FirebaseDatabase.instance;
    // [END start_initialize_database]

    // [START start_initialize_secondary]
    FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    FirebaseDatabase secondaryDatabase =
        FirebaseDatabase.instanceFor(app: secondaryApp);
    // [END start_initialize_secondary]
  }

  void readAndWrite_grabAReference() async {
    // [START read_and_write_grab_a_reference]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    // [END read_and_write_grab_a_reference]
  }

  void readAndWrite_basicWriteOperation() async {
    // [START read_and_write_basic_write_operation]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
    // [END read_and_write_basic_write_operation]
  }

  void readAndWrite_updateRef() async {
    // [START read_and_write_update_ref]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.update({
      "age": 19,
    });
    // [END read_and_write_update_ref]
  }

  void readAndWrite_updateSubPaths() async {
    // [START read_and_write_update_sub_paths]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    await ref.update({
      "123/age": 19,
      "123/address/line1": "1 Mountain View",
    });
    // [END read_and_write_update_sub_paths]
  }

  void readAndWrite_readDataByListening() async {
    // [START read_and_write_read_data_by_listening]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    const postId = '123';
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('posts/$postId/starCount');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      // ... work with data
    });
    // [END read_and_write_read_data_by_listening]
  }

  void readAndWrite_readDataOnce() async {
    // [START read_and_write_read_data_once]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    const userId = '123';
    final dbRef = FirebaseDatabase.instance.ref();

    try {
      final snapshot = await dbRef.child('users/$userId').get();
      if (snapshot.exists) {
        // ...
      }
    } on FirebaseException catch (e) {
      // ...
    }
    // [END read_and_write_read_data_once]
  }

  void readAndWrite_updateSpecificFields() async {
    // [START read_and_write_update_specific_fields]
    // A post entry.
    final postData = {
      'author': 'example user',
      'uid': '123',
      'body': 'A wonderful post',
      'title': 'Example Post',
      'starCount': 0,
    };

    // Get a key for a new Post.
    final newPostKey =
        FirebaseDatabase.instance.ref().child('posts').push().key;

    // Write the new post's data simultaneously in the posts list and the
    // user's post list.
    final Map<String, Map> updates = {};
    updates['/posts/$newPostKey'] = postData;
    updates['/user-posts/${postData['uid']}/$newPostKey'] = postData;

    return await FirebaseDatabase.instance.ref().update(updates);

    // [END read_and_write_update_specific_fields]
  }

  void readAndWrite_addCompletionCallback() async {
    // [START read_and_write_add_completion_callback]
    FirebaseDatabase.instance
        .ref('users/123/email')
        .set('user@example.com')
        .then((_) {
      // Data saved successfully!
    }).catchError((error) {
      // The write failed...
    });
    // [END read_and_write_add_completion_callback]
  }

  void readAndWrite_runATransaction() async {
    // [START read_and_write_run_a_transaction]
    void toggleStar(String uid) async {
      DatabaseReference postRef =
          FirebaseDatabase.instance.ref("posts/foo-bar-123");

      TransactionResult result = await postRef.runTransaction((Object? post) {
        // Ensure a post at the ref exists.
        if (post == null) {
          return Transaction.abort();
        }

        Map<String, dynamic> _post = Map<String, dynamic>.from(post as Map);
        if (_post["stars"] is Map && _post["stars"][uid] != null) {
          _post["starCount"] = (_post["starCount"] ?? 1) - 1;
          _post["stars"][uid] = null;
        } else {
          _post["starCount"] = (_post["starCount"] ?? 0) + 1;
          if (!_post.containsKey("stars")) {
            _post["stars"] = {};
          }
          _post["stars"][uid] = true;
        }

        // Return the new data.
        return Transaction.success(_post);
      });
      // ...
    }
    // [END read_and_write_run_a_transaction]
  }

  void readAndWrite_transactionResult() async {
    // [START read_and_write_transaction_result]
    void toggleStar(String uid) async {
      DatabaseReference postRef =
          FirebaseDatabase.instance.ref("posts/foo-bar-123");
      TransactionResult result = await postRef.runTransaction((Object? post) {
        // Ensure a post at the ref exists.
        if (post == null) {
          return Transaction.abort();
        }

        Map<String, dynamic> _post = Map<String, dynamic>.from(post as Map);
        if (_post["stars"] is Map && _post["stars"][uid] != null) {
          _post["starCount"] = (_post["starCount"] ?? 1) - 1;
          _post["stars"][uid] = null;
        } else {
          _post["starCount"] = (_post["starCount"] ?? 0) + 1;
          if (!_post.containsKey("stars")) {
            _post["stars"] = {};
          }
          _post["stars"][uid] = true;
        }

        // Return the new data.
        return Transaction.success(_post);
      });

      print('Committed? ${result.committed}'); // true / false
      print('Snapshot? ${result.snapshot}'); // DataSnapshot
      // [END read_and_write_transaction_result]
    }
  }

  void readAndWrite_cancelTransaction() async {
    // [START read_and_write_cancel_transaction]
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    TransactionResult result = await ref.runTransaction((Object? user) {
      if (user != null) {
        return Transaction.abort();
      }
      // ...
      return Transaction.success('success!');
    });

    print(result.committed); // false
    // [END read_and_write_cancel_transaction]
  }

  void readAndWrite_atomicServersideIncrements() async {
    // [START read_and_write_atomic_serverside_increments]
    void addStar(uid, key) async {
      Map<String, Object?> updates = {};
      updates["posts/$key/stars/$uid"] = true;
      updates["posts/$key/starCount"] = ServerValue.increment(1);
      updates["user-posts/$key/stars/$uid"] = true;
      updates["user-posts/$key/starCount"] = ServerValue.increment(1);
      return FirebaseDatabase.instance.ref().update(updates);
    }
    // [END read_and_write_atomic_serverside_increments]
  }

  void listsOfData_appendToAList() async {
    // [START lists_of_data_append_to_a_list]
    DatabaseReference postListRef = FirebaseDatabase.instance.ref("posts");
    DatabaseReference newPostRef = postListRef.push();
    newPostRef.set({
      // ...
    }).catchError((e) {
      // ...
    });
    // [END lists_of_data_append_to_a_list]
  }

  void listsOfData_listenForChildEvents() async {
    // [START lists_of_data_listen_for_child_events]
    final commentsRef = FirebaseDatabase.instance.ref("post-comments/123");
    commentsRef.onChildAdded.listen((event) {
      // A new comment has been added, so add it to the displayed list.
    });
    commentsRef.onChildChanged.listen((event) {
      // A comment has changed; use the key to determine if we are displaying this
      // comment and if so displayed the changed comment.
    });
    commentsRef.onChildRemoved.listen((event) {
      // A comment has been removed; use the key to determine if we are displaying
      // this comment and if so remove it.
    });
    // [END lists_of_data_listen_for_child_events]
  }

  void listsOfData_listenForValueEvents() async {
    // [START lists_of_data_listen_for_value_events]
    DatabaseReference postListRef = FirebaseDatabase.instance.ref("posts");
    postListRef.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        // Handle the post.
      }
    }, onError: (error) {
      // Error.
    });
    // [END lists_of_data_listen_for_value_events]
  }

  void listsOfData_sorting() async {
    // [START lists_of_data_sorting]
    final myUserId = FirebaseAuth.instance.currentUser?.uid;
    final topUserPostsRef = FirebaseDatabase.instance
        .ref("user-posts/$myUserId")
        .orderByChild("starCount");
    // [END lists_of_data_sorting]
  }

  void listsOfData_orderByChild() async {
    // [START lists_of_data_order_by_child]
    final mostViewedPosts =
        FirebaseDatabase.instance.ref('posts').orderByChild('metrics/views');
    // [END lists_of_data_order_by_child]
  }

  void listsOfData_limitToLatest() async {
    // [START lists_of_data_limit_to_latest]
    final recentPostsRef =
        FirebaseDatabase.instance.ref('posts').limitToLast(100);
    // [END lists_of_data_limit_to_latest]
  }

  void offline_setDiskPersistence() async {
    // [START offline_set_disk_persistence]
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    // [END offline_set_disk_persistence]
  }

  void offline_keepSynced() async {
    // [START offline_keep_synced]
    final scoresRef = FirebaseDatabase.instance.ref("scores");
    scoresRef.keepSynced(true);
    // [END offline_keep_synced]
  }

  void offline_keepSyncedFalse() async {
    // [START offline_keep_synced_false]
    final scoresRef = FirebaseDatabase.instance.ref("scores");
    scoresRef.keepSynced(false);
    // [END offline_keep_synced_false]
  }

  void offline_queryDataOffline() async {
    // [START offline_query_data_offline]
    final scoresRef = FirebaseDatabase.instance.ref("scores");
    scoresRef.orderByValue().limitToLast(4).onChildAdded.listen((event) {
      debugPrint(
          "The ${event.snapshot.key} dinosaur's score is ${event.snapshot.value}.");
    });
    // [END offline_query_data_offline]
  }

  void offline_queryDataOffline2() async {
    // [START offline_query_data_offline_2]
    final scoresRef = FirebaseDatabase.instance.ref("scores");
    scoresRef.orderByValue().limitToLast(2).onChildAdded.listen((event) {
      debugPrint(
          "The ${event.snapshot.key} dinosaur's score is ${event.snapshot.value}.");
    });
    // [END offline_query_data_offline_2]
  }

  void offline_onDisconnect() async {
    // [START offline_on_disconnect]
    final presenceRef = FirebaseDatabase.instance.ref('disconnectmessage');
    // Write a string when this client loses connection
    presenceRef.onDisconnect().set('I disconnected!');
    // [END offline_on_disconnect]
  }

  void offline_howOnDisconnectWorks() async {
    // [START offline_how_on_disconnect_works]
    final presenceRef = FirebaseDatabase.instance.ref('disconnectmessage');
    try {
      await presenceRef.onDisconnect().remove();
    } catch (error) {
      debugPrint("Could not establish onDisconnect event: $error");
    }
    // [END offline_how_on_disconnect_works]
  }

  void offline_onDisconnectCancel() async {
    // [START offline_on_disconnect_cancel]
    final presenceRef = FirebaseDatabase.instance.ref('disconnectmessage');
    final onDisconnectRef = presenceRef.onDisconnect();
    onDisconnectRef.set("I disconnected");
    // ...
    // some time later when we change our minds
    // ...
    onDisconnectRef.cancel();
    // [END offline_on_disconnect_cancel]
  }

  void offline_detectingConnectionState() async {
    // [START offline_detecting_connection_state]
    final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        debugPrint("Connected.");
      } else {
        debugPrint("Not connected.");
      }
    });
    // [END offline_detecting_connection_state]
  }

  void offline_serverTimestamps() async {
    // [START offline_server_timestamps]
    final userLastOnlineRef =
        FirebaseDatabase.instance.ref("users/joe/lastOnline");
    userLastOnlineRef.onDisconnect().set(ServerValue.timestamp);
    // [END offline_server_timestamps]
  }

  void offline_clockSkew() async {
    // [START offline_clock_skew]
    final offsetRef = FirebaseDatabase.instance.ref(".info/serverTimeOffset");
    offsetRef.onValue.listen((event) {
      final offset = event.snapshot.value as num? ?? 0.0;
      final estimatedServerTimeMs =
          DateTime.now().millisecondsSinceEpoch + offset;
    });
    // [END offline_clock_skew]
  }

  void offline_fullExample() async {
    // [START offline_full_example]
    // Since I can connect from multiple devices, we store each connection
    // instance separately any time that connectionsRef's value is null (i.e.
    // has no children) I am offline.
    final myConnectionsRef =
        FirebaseDatabase.instance.ref("users/joe/connections");

    // Stores the timestamp of my last disconnect (the last time I was seen online)
    final lastOnlineRef =
        FirebaseDatabase.instance.ref("/users/joe/lastOnline");

    final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        final con = myConnectionsRef.push();

        // When this device disconnects, remove it.
        con.onDisconnect().remove();

        // When I disconnect, update the last time I was seen online.
        lastOnlineRef.onDisconnect().set(ServerValue.timestamp);

        // Add this device to my connections list.
        // This value could contain info about the device or a timestamp too.
        con.set(true);
      }
    });
    // [END offline_full_example]
  }
}
