import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class CrashlyticsSnippets implements DocSnippet {
  @override
  void runAll() {
    // Crashlytics testing isn't yet supported,
    // since it requires crashing the app to set up
    // and this will require additional CI work
  }
}
