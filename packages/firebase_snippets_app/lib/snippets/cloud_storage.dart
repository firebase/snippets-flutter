// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class CloudStorageSnippets implements DocSnippet {
  @override
  void runAll() {
    uploadFiles_fullExample();
  }

  void getStarted_setUpCloudStorage() {
    // [START get_started_set_up_cloud_storage]
    final storage = FirebaseStorage.instance;
    // [END get_started_set_up_cloud_storage]
  }

  void getStarted_useMultipleCloudStorageBuckets() {
    // [START get_started_use_multiple_cloud_storage_buckets]
    // Get a non-default Storage bucket
    final storage =
        FirebaseStorage.instanceFor(bucket: "gs://my-custom-bucket");
    // [END get_started_use_multiple_cloud_storage_buckets]
  }

  void getStarted_useACustomerFirebaseApp() {
    // [START get_started_use_a_customer_firebase_app]
    final secondApp = Firebase.app('SecondaryApp');
    final storage = FirebaseStorage.instanceFor(app: secondApp);

    final customStorage = FirebaseStorage.instanceFor(
      app: secondApp,
      bucket: 'gs://my-custom-bucket',
    );
    // [END get_started_use_a_customer_firebase_app]
  }

  void createAReference_createAReference() {
    // [START create_a_reference_create_a_reference]
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref();
    // [END create_a_reference_create_a_reference]

    // [START create_a_reference_create_a_reference2]
    // Create a child reference
    // imagesRef now points to "images"
    final imagesRef = storageRef.child('images');

    // Child references can also take paths
    // spaceRef now points to "images/space.jpg
    // imagesRef still points to "images"
    final spaceRef = storageRef.child("images/space.jpg");
    // [END create_a_reference_create_a_reference2]

    // [START create_a_reference_navigate_with_references]
    // parent allows us to move our reference to a parent node
    // parentRef now points to 'images'
    final parentRef = spaceRef.parent;

    // root allows us to move all the way back to the top of our bucket
    // rootRef now points to the root
    final rootRef = spaceRef.root;
    // [END create_a_reference_navigate_with_references]

    // [START create_a_reference_navigate_with_references_2]
    // References can be chained together multiple times
    // earthRef points to 'images/earth.jpg'
    final earthRef = spaceRef.parent?.child("earth.jpg");

    // nullRef is null, since the parent of root is null
    final nullRef = spaceRef.root.parent;
    // [END create_a_reference_navigate_with_references_2]
  }

  // Not run in CI. All code is covered in function [uploadFiles_fullExample].
  void uploadFiles_createReference() async {
    // [START upload_files_create_reference]
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child("mountains.jpg");
    // Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child("images/mountains.jpg");
    // While the file names are the same, the references point to different files
    assert(mountainsRef.name == mountainImagesRef.name);
    assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
    // [END upload_files_create_reference]

    // [START upload_files_upload_from_files]
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.absolute}/mountains.jpg';
    final file = File(filePath);

    try {
      storageRef.child('images').putFile(file);
    } on FirebaseException catch (e) {
      // handle error
    }
    // [END upload_files_upload_from_files]

    // [START upload_files_upload_from_a_string]
    String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';
    try {
      await mountainsRef.putString(dataUrl, format: PutStringFormat.dataUrl);
    } on FirebaseException catch (e) {
      // ...
    }
    // [END upload_files_upload_from_a_string]

    // [START upload_files_add_file_metadata]
    try {
      storageRef.child('images').putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
    } on FirebaseException catch (e) {
      // handle error
    }
    // [END upload_files_add_file_metadata]
  }

  void uploadFiles_getADownloadURL() async {
    // [START upload_files_get_a_download_url]
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("mountains.jpg");
    await mountainsRef.getDownloadURL();
    // [END upload_files_get_a_download_url]
  }

  // Not run in CI. All code is covered in function [uploadFiles_fullExample].
  void uploadFiles_manageUploads() async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("mountains.jpg");
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.absolute}/mountains.jpg';
    final largeFile = File(filePath);
    // [START upload_files_manage_uploads]
    final task = mountainsRef.putFile(largeFile);
    // Pause the upload.
    bool paused = await task.pause();
    print('paused, $paused');
    // Resume the upload.
    bool resumed = await task.resume();
    print('resumed, $resumed');
    // Cancel the upload.
    bool canceled = await task.cancel();
    print('canceled, $canceled');
    // [END upload_files_manage_uploads]
  }

  // Not run in CI. All code is covered in function [uploadFiles_fullExample].
  void uploadFiles_monitorStatus() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.absolute}/mountains.jpg';
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("mountains.jpg");

    // [START upload_files_monitor_status]
    mountainsRef.putFile(file).snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // ...
          break;
        case TaskState.paused:
          // ...
          break;
        case TaskState.success:
          // ...
          break;
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          // ...
          break;
      }
    });
    // [END upload_files_monitor_status]
  }

  void uploadFiles_fullExample() async {
    // [START upload_files_full_example]
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child("mountains.jpg");

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");
    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("images/path/to/mountains.jpg")
        .putFile(file, metadata);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
    // [END upload_files_full_example]
  }

  void downloadFiles_createAReference() {
    // [START download_files_create_a_reference]

    // [END download_files_create_a_reference]
  }
}
