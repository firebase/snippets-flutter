# Firebase Flutter Snippets

This repository holds code snippets used in Flutter documentation
on [firebase.google.com](https://firebase.google.com/docs/).

These snippets are part of our documentation and best read in the context of a
documentation page rather than used directly.

Each snippet has a "region tag" which is defined by `// [START tag]`
and `// [END tag]` comments. The code between the tags can be included in our
documentation. Keeping the code on GitHub, rather than hard-coded into the HTML
of our documentation, allows us to ensure the code is correct and up to date.

## Set up / Running Instructions - WIP

- installed flutter, intellij, intellij plugins
- created firebase project, downloaded firebase CLI, installed flutterfirecli
- `flutter create firestore-snippets && cd firestore-snippets`
- `flutterfire-configure`

## Snippet structure

**Note**: Most snippets follow this structure, but in some cases multiple
snippets are located in a single function. In this case, the function name
represents which snippet the function name starts on.

Each Firebase product (that requires Flutter snippets) has its own file located
in the dir `apps/firestore_snippets/lib/snippets`.

Each of these files defines a class called [Firebase Product Name]Snippets.
These classes have a separate function for each snippet. These functions follow
the naming convention of `firebaseDocsPageName_snippetTitle`. For
example: `FirestoreSnippets.getStarted_addData`. Each snippet is also wrapped by
comments which define the beginning and ending of the snippet, and generally
excludes the function names. The code in this region, between the two comments,
is the code that appears in the Firebase documentation.

Example:

See translated snippet in
the [Firebase documentation](https://firebase.google.com/docs/firestore/quickstart#add_data)

```dart
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
```

[comment]: <> (## Example)

[comment]: <> (TODO: ewindmill@ fill this in when first snippets are live.)

[comment]: <> (## Contributing)

[comment]: <> (TODO: ewindmill@ create the "contributing" docs)

[comment]: <> (We love contributions! See [CONTRIBUTING.md]&#40;./CONTRIBUTING.md&#41; for guidelines.)

[comment]: <> (## Build Status)

[comment]: <> ([![Actions Status][gh-actions-badge]][gh-actions])

[comment]: <> ([gh-actions]: https://github.com/firebase/snippets-web/actions)

[comment]: <> ([gh-actions-badge]: https://github.com/firebase/snippets-web/workflows/CI%20Tests/badge.svg)