// ignore_for_file: non_constant_identifier_names

import 'package:firebase_snippets_app/snippets/firestore_odm/user_model.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class ODMSnippets extends DocSnippet {
  @override
  void runAll() {
    // TODO: implement runAll
  }

  void references_performQueries() async {
    // [START references_perform_queries]
    usersRef.whereName(isEqualTo: 'John');
    usersRef.whereAge(isGreaterThan: 18);
    usersRef.orderByAge();
    // ..etc!
    // [END references_perform_queries]
  }

  void subCollection_accessSubCollection() async {
    // [START sub_collection_access_sub_collection]
    AddressCollectionReference addressesRef =
        usersRef.doc('myDocumentID').addresses;
    // [END sub_collection_access_sub_collection]
  }
}
