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

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_snippets_app/model/firestore_add_data_custom_objects_snippet.dart';
import 'package:firebase_snippets_app/model/restaurant.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class FirestoreSnippets extends DocSnippet {
  @override
  final FirebaseFirestore db;

  FirestoreSnippets(this.db);

  @override
  void runAll() {
    getStarted_addData();
    getStarted_addData2();
    getStarted_readData();
    dataModel_references();
    dataModel_subCollections();
  }

  void getStarted_addData() async {
    // [START get_started_add_data_1]
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };

    // Add a new document with a generated ID
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    // [END get_started_add_data_1]
  }

  void getStarted_addData2() async {
    // [START get_started_add_data_2]
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": "Alan",
      "middle": "Mathison",
      "last": "Turing",
      "born": 1912
    };

    // Add a new document with a generated ID
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    // [END get_started_add_data_2]
  }

  void getStarted_readData() async {
    // [START get_started_read_data]
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
    // [END get_started_read_data]
  }

  void dataModel_references() {
    // [START data_model_references]
    final alovelaceDocumentRef = db.collection("users").doc("alovelace");
    // [END data_model_references]

    // [START data_model_references2]
    final usersCollectionRef = db.collection("users");
    // [END data_model_references2]

    // [START data_model_references3]
    final aLovelaceDocRef = db.doc("users/alovelace");
    // [END data_model_references3]
  }

  void dataModel_subCollections() {
    // [START data_model_sub_collections]
    final messageRef = db
        .collection("rooms")
        .doc("roomA")
        .collection("messages")
        .doc("message1");
    // [END data_model_sub_collections]
  }

  void dataBundles_loadingClientBundles() {
    // [START data_bundles_loading_client_bundles]
    // TODO - currently in scratch file
    // [END data_bundles_loading_client_bundles]
  }

  void addData_setADocument() {
    // [START add_data_set_document_1]
    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };

    db
        .collection("cities")
        .doc("LA")
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));
    // [END add_data_set_document_1]
  }

  void addData_setADocument2() {
    // [START add_data_set_document_2]
    // Update one field, creating the document if it does not already exist.
    final data = {"capital": true};

    db.collection("cities").doc("BJ").set(data, SetOptions(merge: true));
    // [END add_data_set_document_2]
  }

  void addData_dataTypes() {
    // [START add_data_data_types]
    final docData = {
      "stringExample": "Hello world!",
      "booleanExample": true,
      "numberExample": 3.14159265,
      "dateExample": Timestamp.now(),
      "listExample": [1, 2, 3],
      "nullExample": null
    };

    final nestedData = {
      "a": 5,
      "b": true,
    };

    docData["objectExample"] = nestedData;

    db
        .collection("data")
        .doc("one")
        .set(docData)
        .onError((e, _) => print("Error writing document: $e"));
    // [END add_data_data_types]
  }

  void addData_customObjects2() async {
    // [START add_data_custom_objects2]
    final city = City(
      name: "Los Angeles",
      state: "CA",
      country: "USA",
      capital: false,
      population: 5000000,
      regions: ["west_coast", "socal"],
    );
    final docRef = db
        .collection("cities")
        .withConverter(
          fromFirestore: City.fromFirestore,
          toFirestore: (City city, options) => city.toFirestore(),
        )
        .doc("LA");
    await docRef.set(city);
    // [END add_data_custom_objects2]
  }

  void addData_addADocument() {
    // [START add_data_add_a_document]
    db.collection("cities").doc("new-city-id").set({"name": "Chicago"});
    // [END add_data_add_a_document]
  }

  void addData_addADocument2() {
    // [START add_data_add_a_document_2]
    // Add a new document with a generated id.
    final data = {"name": "Tokyo", "country": "Japan"};

    db.collection("cities").add(data).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
    // [END add_data_add_a_document_2]
  }

  void addData_addADocument3() {
    // [START add_data_add_a_document_3]
    // Add a new document with a generated id.
    final data = <String, dynamic>{};

    final newCityRef = db.collection("cities").doc();

    // Later...
    newCityRef.set(data);

    // [END add_data_add_a_document_3]
  }

  void addData_updateADocument() {
    // [START add_data_update_a_document]
    final washingtonRef = db.collection("cites").doc("DC");
    washingtonRef.update({"capital": true}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    // [END add_data_update_a_document]
  }

  void addData_serverTimestamp() {
    // [START add_data_server_timestamp]
    final docRef = db.collection("objects").doc("some-id");
    final updates = <String, dynamic>{
      "timestamp": FieldValue.serverTimestamp(),
    };

    docRef.update(updates).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    // [END add_data_server_timestamp]
  }

  void addData_updateFieldsInNestedObjects() {
    // [START add_data_update_fields_in_nested_objects]
    // Assume the document contains:
    // {
    //   name: "Frank",
    //   favorites: { food: "Pizza", color: "Blue", subject: "recess" }
    //   age: 12
    // }
    db
        .collection("users")
        .doc("frank")
        .update({"age": 13, "favorites.color": "Red"});
    // [END add_data_update_fields_in_nested_objects]
  }

  void addData_updateElementsInArray() {
    // [START add_data_update_elements_in_array]
    final washingtonRef = db.collection("cities").doc("DC");

    // Atomically add a new region to the "regions" array field.
    washingtonRef.update({
      "regions": FieldValue.arrayUnion(["greater_virginia"]),
    });

    // Atomically remove a region from the "regions" array field.
    washingtonRef.update({
      "regions": FieldValue.arrayRemove(["east_coast"]),
    });
    // [END add_data_update_elements_in_array]
  }

  void addData_incrementANumericValue() {
    // [START add_data_increment_a_numeric_value]
    var washingtonRef = db.collection('cities').doc('DC');

    // Atomically increment the population of the city by 50.
    washingtonRef.update(
      {"population": FieldValue.increment(50)},
    );
    // [END add_data_increment_a_numeric_value]
  }

  void transactions_updatingDataWithTransactions() {
    // [START transactions_updating_data_with_transactions]
    final sfDocRef = db.collection("cities").doc("SF");
    db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);
      // Note: this could be done without a transaction
      //       by updating the population using FieldValue.increment()
      final newPopulation = snapshot.get("population") + 1;
      transaction.update(sfDocRef, {"population": newPopulation});
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
    // [END transactions_updating_data_with_transactions]
  }

  void transactions_passingInformationOutOfTransactions() {
    // TODO: ewindmill@ - either the above example (using asnyc) or this example
    // using (then) is "more correct". Figure out which one.
    // [START transactions_passing_information_out_of_transactions]
    final sfDocRef = db.collection("cities").doc("SF");
    db.runTransaction((transaction) {
      return transaction.get(sfDocRef).then((sfDoc) {
        final newPopulation = sfDoc.get("population") + 1;
        transaction.update(sfDocRef, {"population": newPopulation});
        return newPopulation;
      });
    }).then(
      (newPopulation) => print("Population increased to $newPopulation"),
      onError: (e) => print("Error updating document $e"),
    );
    // [END transactions_passing_information_out_of_transactions]
  }

  void transactions_batchedWrites() {
    // [START transactions_batched_writes]
    // Get a new write batch
    final batch = db.batch();

    // Set the value of 'NYC'
    var nycRef = db.collection("cities").doc("NYC");
    batch.set(nycRef, {"name": "New York City"});

    // Update the population of 'SF'
    var sfRef = db.collection("cities").doc("SF");
    batch.update(sfRef, {"population": 1000000});

    // Delete the city 'LA'
    var laRef = db.collection("cities").doc("LA");
    batch.delete(laRef);

    // Commit the batch
    batch.commit().then((_) {
      // ...
    });
    // [END transactions_batched_writes]
  }

  void deleteData_deleteDocs() {
    // [START delete_data_delete_docs]
    db.collection("cities").doc("DC").delete().then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
    // [END delete_data_delete_docs]
  }

  void deleteData_deleteFields() {
    // [START delete_data_delete_fields]
    final docRef = db.collection("cities").doc("BJ");

    // Remove the 'capital' field from the document
    final updates = <String, dynamic>{
      "capital": FieldValue.delete(),
    };

    docRef.update(updates);
    // [END delete_data_delete_fields]
  }

  void getDataOnce_exampleData() {
    // [START get_data_once_example_data]
    final cities = db.collection("cities");
    final data1 = <String, dynamic>{
      "name": "San Francisco",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 860000,
      "regions": ["west_coast", "norcal"]
    };
    cities.doc("SF").set(data1);

    final data2 = <String, dynamic>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 3900000,
      "regions": ["west_coast", "socal"],
    };
    cities.doc("LA").set(data2);

    final data3 = <String, dynamic>{
      "name": "Washington D.C.",
      "state": null,
      "country": "USA",
      "capital": true,
      "population": 680000,
      "regions": ["east_coast"]
    };
    cities.doc("DC").set(data3);

    final data4 = <String, dynamic>{
      "name": "Tokyo",
      "state": null,
      "country": "Japan",
      "capital": true,
      "population": 9000000,
      "regions": ["kanto", "honshu"]
    };
    cities.doc("TOK").set(data4);

    final data5 = <String, dynamic>{
      "name": "Beijing",
      "state": null,
      "country": "China",
      "capital": true,
      "population": 21500000,
      "regions": ["jingjinji", "hebei"],
    };
    cities.doc("BJ").set(data5);
    // [END get_data_once_example_data]
  }

  void getDataOnce_getADocument() {
    // [START get_data_once_get_a_document]
    final docRef = db.collection("cities").doc("SF");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // [END get_data_once_get_a_document]
  }

  void getDataOnce_sourceOptions() {
    // [START get_data_once_source_options]
    final docRef = db.collection("cities").doc("SF");

    // Source can be CACHE, SERVER, or DEFAULT.
    const source = Source.cache;

    docRef.get(const GetOptions(source: source)).then(
          (res) => print("Successfully completed"),
          onError: (e) => print("Error completing: $e"),
        );
    // [END get_data_once_source_options]
  }

  void getDataOnce_customObjects() async {
    // [START get_data_once_custom_objects]
    final ref = db.collection("cities").doc("LA").withConverter(
          fromFirestore: City.fromFirestore,
          toFirestore: (City city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    final city = docSnap.data(); // Convert to City object
    if (city != null) {
      print(city);
    } else {
      print("No such document.");
    }
    // [END get_data_once_custom_objects]
  }

  void getDataOnce_multipleDocumentsFromACollection() {
    // [START get_data_once_multiple_documents_from_a_collection]
    db.collection("cities").where("capital", isEqualTo: true).get().then(
          (querySnapshot) {
            print("Successfully completed");
            for (var docSnapshot in querySnapshot.docs) {
              print('${docSnapshot.id} => ${docSnapshot.data()}');
            }
          },
          onError: (e) => print("Error completing: $e"),
        );
    // [END get_data_once_multiple_documents_from_a_collection]
  }

  void getDataOnce_getAllDocumentsInACollection() {
    // [START get_data_once_get_all_documents_in_a_collection]
    db.collection("cities").get().then(
          (querySnapshot) {
            print("Successfully completed");
            for (var docSnapshot in querySnapshot.docs) {
              print('${docSnapshot.id} => ${docSnapshot.data()}');
            }
          },
          onError: (e) => print("Error completing: $e"),
        );
    // [END get_data_once_get_all_documents_in_a_collection]
  }

  void getDataOnce_listSubCollections() {
    // [START get_data_once_list_sub_collections]
    // Not currently available in Dart SDK
    // [END get_data_once_list_sub_collections]
  }

  void listenToRealtimeUpdates_listenForUpdates() {
    // [START listen_to_realtime_updates_listen_for_updates]
    final docRef = db.collection("cities").doc("SF");
    docRef.snapshots().listen(
          (event) => print("current data: ${event.data()}"),
          onError: (error) => print("Listen failed: $error"),
        );

    // [END listen_to_realtime_updates_listen_for_updates]
  }

  void listenToRealtimeUpdates_eventsForLocalChanges() {
    // [START listen_to_realtime_updates_events_for_local_changes]
    final docRef = db.collection("cities").doc("SF");
    docRef.snapshots().listen(
      (event) {
        final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";
        print("$source data: ${event.data()}");
      },
      onError: (error) => print("Listen failed: $error"),
    );

    // [END listen_to_realtime_updates_events_for_local_changes]
  }

  void listenToRealtimeUpdates_eventsOnMetadataChanges() {
    // [START listen_to_realtime_updates_events_on_metadata_changes]
    final docRef = db.collection("cities").doc("SF");
    docRef.snapshots(includeMetadataChanges: true).listen((event) {
      // ...
    });
    // [END listen_to_realtime_updates_events_on_metadata_changes]
  }

  void listenToRealtimeUpdates_listToMultipleDocuments() {
    // [START listen_to_realtime_updates_list_to_multiple_documents]
    db
        .collection("cities")
        .where("state", isEqualTo: "CA")
        .snapshots()
        .listen((event) {
      final cities = [];
      for (var doc in event.docs) {
        cities.add(doc.data()["name"]);
      }
      print("cities in CA: ${cities.join(", ")}");
    });
    // [END listen_to_realtime_updates_list_to_multiple_documents]
  }

  void listenToRealtimeUpdates_viewUpdatesBetweenChanges() {
    // [START listen_to_realtime_updates_view_updates_between_changes]
    db
        .collection("cities")
        .where("state", isEqualTo: "CA")
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print("New City: ${change.doc.data()}");
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            print("Removed City: ${change.doc.data()}");
            break;
        }
      }
    });
    // [END listen_to_realtime_updates_view_updates_between_changes]
  }

  void listenToRealtimeUpdates_detachAListener() {
    // [START listen_to_realtime_updates_detach_a_listener]
    final collection = db.collection("cities");
    final listener = collection.snapshots().listen((event) {
      // ...
    });
    listener.cancel();
    // [END listen_to_realtime_updates_detach_a_listener]
  }

  void listenToRealtimeUpdates_handleListenErrors() {
    // [START listen_to_realtime_updates_handle_listen_errors]
    final docRef = db.collection("cities");
    docRef.snapshots().listen(
          (event) => print("listener attached"),
          onError: (error) => print("Listen failed: $error"),
        );
    // [END listen_to_realtime_updates_handle_listen_errors]
  }

  void performSimpleAndCompoundQueries_exampleData() {
    // [START perform_simple_and_compound_queries_example_data]
    final cities = db.collection("cities");
    final data1 = <String, dynamic>{
      "name": "San Francisco",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 860000,
      "regions": ["west_coast", "norcal"]
    };
    cities.doc("SF").set(data1);

    final data2 = <String, dynamic>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 3900000,
      "regions": ["west_coast", "socal"],
    };
    cities.doc("LA").set(data2);

    final data3 = <String, dynamic>{
      "name": "Washington D.C.",
      "state": null,
      "country": "USA",
      "capital": true,
      "population": 680000,
      "regions": ["east_coast"]
    };
    cities.doc("DC").set(data3);

    final data4 = <String, dynamic>{
      "name": "Tokyo",
      "state": null,
      "country": "Japan",
      "capital": true,
      "population": 9000000,
      "regions": ["kanto", "honshu"]
    };
    cities.doc("TOK").set(data4);

    final data5 = <String, dynamic>{
      "name": "Beijing",
      "state": null,
      "country": "China",
      "capital": true,
      "population": 21500000,
      "regions": ["jingjinji", "hebei"],
    };
    cities.doc("BJ").set(data5);
    // [END perform_simple_and_compound_queries_example_data]
  }

  void performSimpleAndCompoundQueries_simpleQueries() {
    // [START perform_simple_and_compound_queries_simple_queries]
    // Create a reference to the cities collection
    final citiesRef = db.collection("cities");

    // Create a query against the collection.
    final query = citiesRef.where("state", isEqualTo: "CA");
    // [END perform_simple_and_compound_queries_simple_queries]
  }

  void performSimpleAndCompoundQueries_simpleQueries2() {
    // [START perform_simple_and_compound_queries_simple_queries2]
    final capitalcities =
        db.collection("cities").where("capital", isEqualTo: true);
    // [END perform_simple_and_compound_queries_simple_queries2]
  }

  void performSimpleAndCompoundQueries_executeAQuery() {
    // [START perform_simple_and_compound_queries_execute_a_query]
    db.collection("cities").where("capital", isEqualTo: true).get().then(
          (res) => print("Successfully completed"),
          onError: (e) => print("Error completing: $e"),
        );
    // [END perform_simple_and_compound_queries_execute_a_query]
  }

  void performSimpleAndCompoundQueries_queryOperators() {
    // [START perform_simple_and_compound_queries_query_operators]
    final citiesRef = db.collection("cities");
    final stateQuery = citiesRef.where("state", isEqualTo: "CA");
    final populationQuery = citiesRef.where("population", isLessThan: 100000);
    final nameQuery = citiesRef.where("name", isEqualTo: "San Francisco");
    // [END perform_simple_and_compound_queries_query_operators]
  }

  void performSimpleAndCompoundQueries_notEqual() {
    // [START perform_simple_and_compound_queries_not_equal]
    final citiesRef = db.collection("cities");
    final notCapitals = citiesRef.where("capital", isNotEqualTo: true);
    // [END perform_simple_and_compound_queries_not_equal]
  }

  void performSimpleAndCompoundQueries_arrayMembership() {
    // [START perform_simple_and_compound_queries_array_membership]
    final citiesRef = db.collection("cities");
    final westCoastcities =
        citiesRef.where("regions", arrayContains: "west_coast");
    // [END perform_simple_and_compound_queries_array_membership]
  }

  void performSimpleAndCompoundQueries_inNotInArrayContainsAny() {
    // [START perform_simple_and_compound_queries_in_not_in_array_contains_any]
    final citiesRef = db.collection("cities");
    final cities = citiesRef.where("country", whereIn: ["USA", "Japan"]);
    // [END perform_simple_and_compound_queries_in_not_in_array_contains_any]
  }

  void performSimpleAndCompoundQueries_notIn() {
    // [START perform_simple_and_compound_queries_not_in]
    final citiesRef = db.collection("cities");
    final cities = citiesRef.where("country", whereNotIn: ["USA", "Japan"]);
    // [END perform_simple_and_compound_queries_not_in]
  }

  void performSimpleAndCompoundQueries_arrayContainsAny() {
    // [START perform_simple_and_compound_queries_array_contains_any]
    final citiesRef = db.collection("cities");
    final cities = citiesRef
        .where("regions", arrayContainsAny: ["west_coast", "east_coast"]);
    // [END perform_simple_and_compound_queries_array_contains_any]
  }

  void performSimpleAndCompoundQueries_inArray() {
    // [START perform_simple_and_compound_queries_array_wherein]
    final citiesRef = db.collection("cities");
    final cities = citiesRef.where("regions", whereIn: [
      ["west_coast"],
      ["east_coast"]
    ]);
    // [END perform_simple_and_compound_queries_array_wherein]
  }

  void performSimpleAndCompoundQueries_compoundQueries() {
    // [START perform_simple_and_compound_queries_compound_queries]
    final citiesRef = db.collection("cities");
    citiesRef
        .where("state", isEqualTo: "CO")
        .where("name", isEqualTo: "Denver");
    citiesRef
        .where("state", isEqualTo: "CA")
        .where("population", isLessThan: 1000000);
    // [END perform_simple_and_compound_queries_compound_queries]
  }

  // TODO: remember to document this naming convention in README
  void performSimpleAndCompoundQueries_compoundQueries_validRangeFilters() {
    // [START perform_simple_and_compound_queries_compound_queries_valid_range_filters]
    final citiesRef = db.collection("cities");
    citiesRef
        .where("state", isGreaterThanOrEqualTo: "CA")
        .where("state", isLessThanOrEqualTo: "IN");
    citiesRef
        .where("state", isEqualTo: "CA")
        .where("population", isGreaterThan: 1000000);
    // [END perform_simple_and_compound_queries_compound_queries_valid_range_filters]
  }

  void performSimpleAndCompoundQueries_compoundQueries_invalidRangeFilters() {
    // [START perform_simple_and_compound_queries_compound_queries_invalid_range_filters]
    final citiesRef = db.collection("cities");
    citiesRef
        .where("state", isGreaterThanOrEqualTo: "CA")
        .where("population", isGreaterThan: 1000000);
    // [END perform_simple_and_compound_queries_compound_queries_invalid_range_filters]
  }

  void performSimpleAndCompoundQueries_collectionGroups() {
    // [START perform_simple_and_compound_queries_collection_groups]
    final citiesRef = db.collection("cities");

    final ggbData = {"name": "Golden Gate Bridge", "type": "bridge"};
    citiesRef.doc("SF").collection("landmarks").add(ggbData);

    final lohData = {"name": "Legion of Honor", "type": "museum"};
    citiesRef.doc("SF").collection("landmarks").add(lohData);

    final gpData = {"name": "Griffth Park", "type": "park"};
    citiesRef.doc("LA").collection("landmarks").add(gpData);

    final tgData = {"name": "The Getty", "type": "museum"};
    citiesRef.doc("LA").collection("landmarks").add(tgData);

    final lmData = {"name": "Lincoln Memorial", "type": "memorial"};
    citiesRef.doc("DC").collection("landmarks").add(lmData);

    final nasaData = {
      "name": "National Air and Space Museum",
      "type": "museum"
    };
    citiesRef.doc("DC").collection("landmarks").add(nasaData);

    final upData = {"name": "Ueno Park", "type": "park"};
    citiesRef.doc("TOK").collection("landmarks").add(upData);

    final nmData = {
      "name": "National Musuem of Nature and Science",
      "type": "museum"
    };
    citiesRef.doc("TOK").collection("landmarks").add(nmData);

    final jpData = {"name": "Jingshan Park", "type": "park"};
    citiesRef.doc("BJ").collection("landmarks").add(jpData);

    final baoData = {"name": "Beijing Ancient Observatory", "type": "musuem"};
    citiesRef.doc("BJ").collection("landmarks").add(baoData);
    // [END perform_simple_and_compound_queries_collection_groups]
  }

  void performSimpleAndCompoundQueries_collectionGroups2() {
    // [START perform_simple_and_compound_queries_collection_groups2]
    db
        .collectionGroup("landmarks")
        .where("type", isEqualTo: "museum")
        .get()
        .then(
          (res) => print("Successfully completed"),
          onError: (e) => print("Error completing: $e"),
        );
    // [END perform_simple_and_compound_queries_collection_groups2]
  }

  void aggregationQuery_count() {
    // [START count_aggregate_collection]
    // Returns number of documents in users collection
    db
      .collection("users")
      .count()
      .get()
      .then(
        (res) => print(res.data().count), 
        onError: (e) => print("Error completing: $e"),
      );
    // [END count_aggregate_collection]
  }

  void aggregationQuery_count2() {
    // [START count_aggregate_query]
    // This also works with collectionGroup queries.
    db
      .collection("users")
      .where("age", isGreaterThan: 10)
      .count()
      .get()
      .then(
        (res) => print(res.data().count), 
        onError: (e) => print("Error completing: $e"),
      );
    // [END count_aggregate_query]
  }

  void orderAndLimitData_orderAndLimitData() {
    // [START order_and_limit_data_order_and_limit_data]
    final citiesRef = db.collection("cities");
    citiesRef.orderBy("name").limit(3);
    // [END order_and_limit_data_order_and_limit_data]
  }

  void orderAndLimitData_orderAndLimitData2() {
    // [START order_and_limit_data_order_and_limit_data2]
    final citiesRef = db.collection("cities");
    citiesRef.orderBy("name", descending: true).limit(3);
    // [END order_and_limit_data_order_and_limit_data2]
  }

  void orderAndLimitData_orderAndLimitData3() {
    // [START order_and_limit_data_order_and_limit_data3]
    final citiesRef = db.collection("cities");
    citiesRef.orderBy("state").orderBy("population", descending: true);
    // [END order_and_limit_data_order_and_limit_data3]
  }

  void orderAndLimitData_orderAndLimitData4() {
    // [START order_and_limit_data_order_and_limit_data4]
    final citiesRef = db.collection("cities");
    citiesRef
        .where("population", isGreaterThan: 100000)
        .orderBy("population")
        .limit(2);
    // [END order_and_limit_data_order_and_limit_data4]
  }

  void orderAndLimitData_limitations_valid() {
    // [START order_and_limit_data_limitations_valid]
    final citiesRef = db.collection("cities");
    citiesRef.where("population", isGreaterThan: 100000).orderBy("population");
    // [END order_and_limit_data_limitations_valid]
  }

  void orderAndLimitData_limitations_invalid() {
    // [START order_and_limit_data_limitations_invalid]
    final citiesRef = db.collection("cities");
    citiesRef.where("population", isGreaterThan: 100000).orderBy("country");
    // [END order_and_limit_data_limitations_invalid]
  }

  void paginateData_addASimpleCursor() {
    // [START paginate_data_add_a_simple_cursor]
    db.collection("cities").orderBy("population").startAt([1000000]);
    // [END paginate_data_add_a_simple_cursor]
  }

  void paginateData_addASimpleCursor2() {
    // [START paginate_data_add_a_simple_cursor2]
    db.collection("cities").orderBy("population").endAt([1000000]);
    // [END paginate_data_add_a_simple_cursor2]
  }

  void paginateData_useADocSnapshotToDefineCursorQuery() {
    // [START paginate_data_use_a_doc_snapshot_to_define_cursor_query]
    db.collection("cities").doc("SF").get().then(
      (documentSnapshot) {
        final biggerThanSf = db
            .collection("cities")
            .orderBy("population")
            .startAt([documentSnapshot]);
      },
      onError: (e) => print("Error: $e"),
    );
    // [END paginate_data_use_a_doc_snapshot_to_define_cursor_query]
  }

  void paginateData_paginateAQuery() {
    // [START paginate_data_paginate_a_query]
    // Construct query for first 25 cities, ordered by population
    final first = db.collection("cities").orderBy("population").limit(25);

    first.get().then(
      (documentSnapshots) {
        // Get the last visible document
        final lastVisible = documentSnapshots.docs[documentSnapshots.size - 1];

        // Construct a new query starting at this document,
        // get the next 25 cities.
        final next = db
            .collection("cities")
            .orderBy("population")
            .startAfter([lastVisible]).limit(25);

        // Use the query for pagination
        // ...
      },
      onError: (e) => print("Error completing: $e"),
    );
    // [END paginate_data_paginate_a_query]
  }

  void paginateData_setCursorBasedOnMultipleFields() {
    // [START paginate_data_set_cursor_based_on_multiple_fields]
    // Will return all Springfields
    db
        .collection("cities")
        .orderBy("name")
        .orderBy("state")
        .startAt(["Springfield"]);

    // Will return "Springfield, Missouri" and "Springfield, Wisconsin"
    db
        .collection("cities")
        .orderBy("name")
        .orderBy("state")
        .startAt(["Springfield", "Missouri"]);
    // [END paginate_data_set_cursor_based_on_multiple_fields]
  }

  void accessDataOffline_configure() async {
    // [START access_data_offline_configure_offline_persistence]
    // Apple and Android
    db.settings = const Settings(persistenceEnabled: true);

    // Web
    await db
        .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
    // [END access_data_offline_configure_offline_persistence]
  }

  void accessDataOffline_configureCache() {
    // [START access_data_offline_configure_cache_size]
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    // [END access_data_offline_configure_cache_size]
  }

  void accessDataOffline_listenToOfflineData() {
    // [START access_data_offline_listen_to_offline_data]
    db
        .collection("cities")
        .where("state", isEqualTo: "CA")
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final source =
              (querySnapshot.metadata.isFromCache) ? "local cache" : "server";

          print("Data fetched from $source}");
        }
      }
    });
    // [END access_data_offline_listen_to_offline_data]
  }

  void accessDataOffline_disableNetwork() {
    // [START access_data_offline_disable_network]
    db.disableNetwork().then((_) {
      // Do offline things
    });
    // [END access_data_offline_disable_network]
  }

  void accessDataOffline_enableNetwork() {
    // [START access_data_offline_enable_network]
    db.enableNetwork().then((_) {
      // Back online
    });
    // [END access_data_offline_enable_network]
  }

  void solutions_aggregationQueries() {
    // [START solutions_aggregation_queries]
    db
        .collection("restaurants")
        .doc("arinell-pizza")
        .collection("ratings")
        .get();
    // [END solutions_aggregation_queries]
  }

  void solutions_aggregationQueries2() {
    // [START solutions_aggregation_queries_2]
    final arinellDoc = {
      'name': 'Arinell Pizza',
      'avgRating': 4.65,
      'numRatings': 683
    };
    // [END solutions_aggregation_queries_2]
  }

  void solutions_aggregationQueries3() {
    // [START solutions_aggregation_queries_3]
    void addRating(DocumentReference restaurantRef, double rating) async {
      // Create reference for new rating, for use inside the transaction
      final ratingRef = restaurantRef.collection("ratings").doc();

      // In a transaction, add the new rating and update the aggregate totals
      return db.runTransaction((transaction) async {
        final restaurant = await transaction.get(restaurantRef).then((snap) {
          final data = snap.data() as Map<String, dynamic>;
          return Restaurant.fromFirestore(data);
        });

        // Compute new number of ratings
        final newNumRatings = restaurant.numRatings + 1;

        // Compute new average rating
        final oldRatingTotal = restaurant.avgRating * restaurant.numRatings;
        final newAvgRating = (oldRatingTotal + rating) / newNumRatings;

        // Set new restaurant info
        restaurant.numRatings = newNumRatings;
        restaurant.avgRating = newAvgRating;

        // Update restaurant
        transaction.set(restaurantRef, restaurant);

        // Update rating
        final data = {
          "rating": rating,
        };

        transaction.set(ratingRef, data, SetOptions(merge: true));
      });
    }

    // [END solutions_aggregation_queries_3]
    final docRef = db.collection("restaurants").doc("arinell-pizza");
    addRating(docRef, 2.3);
  }

  void solutions_distributedCounters2() {
    // [START solutions_distributed_counters2]
    void createCounter(DocumentReference ref, int numShards) {
      final batch = db.batch();
      // Initialize the counter document
      batch.set(ref, Counter(numShards));

      // Initialize each shard with count=0
      ref.set(Counter(numShards)).then((value) {
        for (var i = 0; i < numShards; ++i) {
          final shardRef = ref.collection('shards').doc(i.toString());
          batch.set(shardRef, Shard(0));
        }
      });

      // Commit the write batch
      batch.commit();
    }
    // [END solutions_distributed_counters2]
  }

  void solutions_distributedCounters3() {
    // [START solutions_distributed_counters3]
    void incrementCounter(db, ref, numShards) {
      // Select a shard of the counter at random
      final randomShardId = Random().nextInt(numShards);
      final shardId = (randomShardId * numShards).floor().toString();
      final shardRef = ref.collection('shards').doc(shardId);

      // Update count
      shardRef.update("count", FieldValue.increment(1));
    }
    // [END solutions_distributed_counters3]
  }

  // todo: this needs to be cleaned up vis a vis types
  void solutions_distributedCounters4() {
    // [START solutions_distributed_counters4]
    getCount(DocumentReference ref) {
      // Select a shard of the counter at random
      return ref.collection('shards').get().then(
        (snapshot) {
          num totalCount = 0;
          for (var doc in snapshot.docs) {
            totalCount += (doc.data as Map<String, dynamic>)["count"] as int;
          }
          return totalCount;
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    // [END solutions_distributed_counters4]
  }

  // todo: Firebase functions aren't supported in Dart
  void deleteDataWithCallableCloudFunc_clientInvocation() {
    // [START delete_data_with_callable_cloud_func_client_invocation]
    /*

   */
    // [END delete_data_with_callable_cloud_func_client_invocation]
  }
}

// [START solutions_distributed_counters]
class Counter {
  int numShards;
  Counter(this.numShards);
}

class Shard {
  int count;
  Shard(this.count);
}
// [END solutions_distributed_counters]
