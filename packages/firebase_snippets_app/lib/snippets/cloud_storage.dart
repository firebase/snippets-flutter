// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class CloudStorageSnippets implements DocSnippet {
  @override
  void runAll() {
    uploadFiles_fullExample();
    downloadFiles_fullExample();
    listFiles_listAllFiles();
    deleteFiles_deleteAFile();
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
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference with an initial file path and name
    final pathReference = storageRef.child("images/stars.jpg");
    // Create a reference to a file from a Google Cloud Storage URI
    final gsReference = FirebaseStorage.instance
        .refFromURL("gs://YOUR_BUCKET/images/stars.jpg");
    // Create a reference from an HTTPS URL
    // Note that in the URL, characters are URL escaped!
    final httpsReference = FirebaseStorage.instance.refFromURL(
        "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");
    // [END download_files_create_a_reference]
  }

  void downloadFiles_downloadInMemory() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START download_files_download_in_memory]
    final islandRef = storageRef.child("images/island.jpg");
    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      // Data for "images/island.jpg" is returned, use this as needed.
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
    // [END download_files_download_in_memory]
  }

  void downloadFiles_downloadToALocalFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START download_files_download_to_a_local_file]
    final islandRef = storageRef.child("images/island.jpg");
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/island.jpg";
    final file = File(filePath);
    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
    // [END download_files_download_to_a_local_file]
  }

  void downloadFiles_downloadViaUrl() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START download_files_download_via_url]
    final imageUrl =
        await storageRef.child("users/me/profile.png").getDownloadURL();
    // [END download_files_download_via_url]
  }

  void downloadFiles_fullExample() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START download_files_full_example]
    final islandRef = storageRef.child("images/island.jpg");
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/island.jpg";
    final file = File(filePath);
    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          // TODO: Handle this case.
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          // TODO: Handle this case.
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          break;
        case TaskState.error:
          // TODO: Handle this case.
          break;
      }
    });
    // [END download_files_full_example]
  }

  void useFileMetadata_getMetadata() async {
    // [START use_file_metadata_get_metadata]
    final storageRef = FirebaseStorage.instance.ref();
    // Create reference to the file whose metadata we want to retrieve
    final forestRef = storageRef.child("images/forest.jpg");
    // Get metadata properties
    final metadata = await forestRef.getMetadata();
    // Metadata now contains the metadata for 'images/forest.jpg'
    // [END use_file_metadata_get_metadata]
  }

  void useFileMetadata_updateMetadata() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START use_file_metadata_update_metadata]
    // Create reference to the file whose metadata we want to change
    final forestRef = storageRef.child("images/forest.jpg");
    // Create file metadata to update
    final newMetadata = SettableMetadata(
      cacheControl: "public,max-age=300",
      contentType: "image/jpeg",
    );
    // Update metadata properties
    final metadata = await forestRef.updateMetadata(newMetadata);
    // Updated metadata for 'images/forest.jpg' is returned
    // [END use_file_metadata_update_metadata]
  }

  void useFileMetadata_deleteMetadata() async {
    final storageRef = FirebaseStorage.instance.ref();
    final forestRef = storageRef.child("images/forest.jpg");
    // [START use_file_metadata_delete_metadata]
    // Delete the cacheControl property
    final newMetadata = SettableMetadata(cacheControl: null);
    final metadata = await forestRef.updateMetadata(newMetadata);
    // [END use_file_metadata_delete_metadata]
  }

  void useFileMetadata_customMetadata() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START use_file_metadata_custom_metadata]
    // Create reference to the file whose metadata we want to change
    final forestRef = storageRef.child("images/forest.jpg");
    // Create file metadata to update
    final newCustomMetadata = SettableMetadata(
      customMetadata: {
        "location": "Yosemite, CA, USA",
        "activity": "Hiking",
      },
    );
    // Update metadata properties
    final metadata = await forestRef.updateMetadata(newCustomMetadata);
    // Updated metadata for 'images/forest.jpg' is returned
    // [END use_file_metadata_custom_metadata]
  }

  void deleteFiles_deleteAFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    // [START delete_files_delete_a_file]
    // Create a reference to the file to delete
    final desertRef = storageRef.child("images/desert.jpg");
    // Delete the file
    await desertRef.delete();
    // [END delete_files_delete_a_file]
  }

  void listFiles_listAllFiles() async {
    // [START list_files_list_all_files]
    final storageRef = FirebaseStorage.instance.ref().child("files/uid");
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
    }
    for (var item in listResult.items) {
      // The items under storageRef.
    }
    // [END list_files_list_all_files]
  }

  void listFiles_PaginateList() async {
    final storageRef = FirebaseStorage.instance.ref().child("files/uid");
    // [START list_files_paginate_list]
    Stream<ListResult> listAllPaginated(Reference storageRef) async* {
      String? pageToken;
      do {
        final listResult = await storageRef.list(ListOptions(
          maxResults: 100,
          pageToken: pageToken,
        ));
        yield listResult;
        pageToken = listResult.nextPageToken;
      } while (pageToken != null);
    }
    // [END list_files_paginate_list]

    listAllPaginated(storageRef);
  }

  void handleErrors_handleErrors() async {
    // [START handle_errors_handle_errors]
    final storageRef = FirebaseStorage.instance.ref().child("files/uid");
    try {
      final listResult = await storageRef.listAll();
    } on FirebaseException catch (e) {
      // Caught an exception from Firebase.
      print("Failed with error '${e.code}': ${e.message}");
    }
    // [END handle_errors_handle_errors]
  }
}
