// ignore_for_file: non_constant_identifier_names

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class DynamicLinkSnippets implements DocSnippet {
  @override
  void runAll() {
    // TODO: implement runAll
  }

  void createDynamicLinks_createParams() async {
    // [START create_dynamic_links_create_params]
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.example.com/"),
      uriPrefix: "https://example.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.app.android"),
      iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    // [END create_dynamic_links_create_params]
  }

  void createDynamicLinks_shortLinks() async {
    // [START create_dynamic_links_short_links]
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.example.com/"),
      uriPrefix: "https://example.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.app.android"),
      iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    // [END create_dynamic_links_short_links]

    // [START create_dynamic_links_unguessable]
    final unguessableDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    // [END create_dynamic_links_unguessable]
  }

  void createDynamicLinks_params() async {
    // [START create_dynamic_links_params]
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.example.com/"),
      uriPrefix: "https://example.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.example.app.android",
        minimumVersion: 30,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.app.ios",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        source: "twitter",
        medium: "social",
        campaign: "example-promo",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Example of a Dynamic Link",
        imageUrl: Uri.parse("https://example.com/image.png"),
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    // [END create_dynamic_links_params]
  }

  void receiveDynamicLinks_testExactLink() async {
    // [START receive_dynamic_links_test_exact_link]
    String link = 'https://dynamic-link-domain/ke2Qa';

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(link));
    // [END receive_dynamic_links_test_exact_link]
  }

  void receiveDynamicLink_listenInBackground() async {}
}
