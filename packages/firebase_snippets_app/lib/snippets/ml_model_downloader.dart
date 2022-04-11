// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class MLModelDownloaderSnippets implements DocSnippet {
  @override
  void runAll() {
    // This plug in is in beta. It won't be tested for now.
  }

  void mlDownloader_createReference() async {
    // [START ml_downloader_create_reference]
    FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
    // [END ml_downloader_create_reference]

    // [START ml_downloader_secondary_app_reference]
    FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
    FirebaseModelDownloader secondaryDownloader =
        FirebaseModelDownloader.instanceFor(app: secondaryApp);
    // [END ml_downloader_secondary_app_reference]

    // [START ml_downloader_list_downloaded_models]
    List<FirebaseCustomModel> models =
        await FirebaseModelDownloader.instance.listDownloadedModels();
    // [END ml_downloader_list_downloaded_models]

    // [START ml_downloader_custom_model]
    List<FirebaseCustomModel> customModels =
        await FirebaseModelDownloader.instance.listDownloadedModels();

    for (var model in customModels) {
      print('Name: ${model.name}');
      print('Size: ${model.size}');
      print('Hash: ${model.hash}');
    }
    // [END ml_downloader_custom_model]

    // [START ml_downloader_download_model]
    FirebaseCustomModel model = await FirebaseModelDownloader.instance
        .getModel('myModel', FirebaseModelDownloadType.latestModel);
    // [END ml_downloader_download_model]

    // [START ml_downloader_conditions]
    // The following are the default conditions:
    FirebaseModelDownloadConditions conditions =
        FirebaseModelDownloadConditions(
      // Download whilst connected to cellular data
      iosAllowsCellularAccess: true,
      // Allow downloading in the background
      iosAllowsBackgroundDownloading: false,
      // Only download whilst charging
      androidChargingRequired: false,
      // Only download whilst on Wifi
      androidWifiRequired: false,
      // Only download whilst the device is idle
      androidDeviceIdleRequired: false,
    );

    FirebaseCustomModel modelWithConditions = await FirebaseModelDownloader
        .instance
        .getModel('myModel', FirebaseModelDownloadType.latestModel, conditions);
    // [END ml_downloader_conditions]

    // [START ml_downloader_delete_a_model]
    await FirebaseModelDownloader.instance.deleteDownloadedModel('myModel');
    // [END ml_downloader_delete_a_model]
  }
}
