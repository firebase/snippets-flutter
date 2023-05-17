// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthenticationSnippets implements DocSnippet {
  @override
  void runAll() {
    getStarted_authStateChanges();
    getStarted_idTokenChanges();
    getStarted_userChanges();
    manageUsers_getProfile();
    passwordAuth_createPasswordBasedAccount();
    emailLinkAuth_sendAuthLinkEmail();
    social_google_sign_in();
    social_twitterAuth();
    social_facebookAuth();
    phoneAuth_verifyPhoneNumber();
    customAuth_withFirebase();
    anonymousAuth_withFirebase();
  }

  void getStarted_authStateChanges() async {
    // [START get_started_auth_state_changes]
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is signed in, see docs for a list of available properties
        // https://firebase.google.com/docs/reference/js/firebase.User
        final uid = user!.uid;
      } else {
        // User is signed out
        // ...
      }
    });
    // [END get_started_auth_state_changes]
  }

  void getStarted_authGetCurrentUser() async {
    // [START get_started_auth_get_current_user]
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is signed in, see docs for a list of available properties
      // https://firebase.google.com/docs/reference/js/firebase.User
      final uid = user!.uid;
    } else {
      // User is signed out
      // ...
    }
    // [END get_started_auth_get_current_user]
  }

  void getStarted_idTokenChanges() async {
    // [START get_started_id_token_changes]
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        // User is signed in, see docs for a list of available properties
        // ...
      } else {
        // User is signed out
        // ...
      }
    });
    // [END get_started_id_token_changes]
  }

  void getStarted_userChanges() async {
    // [START get_started_user_changes]
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    // [END get_started_user_changes]
  }

  void manageUsers_getProfile() async {
    // [START manage_users_get_profile]
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;
    }
    // [END manage_users_get_profile]
  }

  void manageUsers_getProviderSpecificProfile() async {
    // [START manage_users_get_provider_specific_profile]
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.cpm, etc.)
        final provider = providerProfile.providerId;

        // UID specific to the provider
        final uid = providerProfile.uid;

        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
      }
    }
    // [END manage_users_get_provider_specific_profile]
  }

  void manageUsers_updateProfile() async {
    // [START manage_users_update_profile]
    final user = FirebaseAuth.instance.currentUser;
    try {
      await user?.updateDisplayName("Jane Q. User");
      await user?.updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
    } on FirebaseAuthException catch (e) {
      // An error occurred
      // ..
    }
    // [END manage_users_update_profile]
  }

  void manageUsers_setEmail() async {
    // [START manage_users_set_email]
    final user = FirebaseAuth.instance.currentUser;
    await user?.updateEmail("janeq@example.com").then((result) {
      // Email updated!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });
    // [END manage_users_set_email]
  }

  void manageUsers_sendVerificationEmail() async {
    // [START manage_users_send_verification_email]
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification().then((result) {
      // Email sent!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });

    // [END manage_users_send_verification_email]
  }

  void manageUsers_setLocaleThenSendEmail() async {
    // [START manage_users_set_locale_then_send_email]
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseAuth.instance.setLanguageCode("fr");
    await user?.sendEmailVerification().then((result) {
      // Email sent!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });

    // [END manage_users_set_locale_then_send_email]
  }

  void manageUsers_setNewPassword() async {
    // [START manage_users_set_new_password]
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePassword('top.secret%PASSWORD').then((result) {
      // Password updated!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });

    // [END manage_users_set_new_password]
  }

  void manageUsers_sendResetEmail() async {
    // [START manage_users_send_reset_email]
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: 'user@example.com')
        .then((result) {
      // Email sent!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });

    // [END manage_users_send_reset_email]
  }

  void manageUsers_setLanguageCode() async {
    // [START manage_users_set_language_code]
    // All emails, SMS, and reCAPTCHA sent after this line is executed will have this language code.
    await FirebaseAuth.instance.setLanguageCode("fr").then((result) {
      // Language code updated!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });
    // [END manage_users_set_language_code]
  }

  void manageUsers_reAuthenticate() async {
    // [START manage_users_re_authenticate]
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'top.secret.PASSWORD',
      );
      final credential = userCredential.credential!;

      // Prompt the user to re-provide their sign-in credentials.
      // Then, use the credentials to reauthenticate:
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // an error occurred
      // ...
    }
    // [END manage_users_re_authenticate]
  }

  void manageUsers_deleteUser() async {
    // [START manage_users_delete_user]
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete().then((result) {
      // User deleted!
      // ...
    }, onError: (error) {
      // An error occurred
      // ..
    });
    ;
    // [END manage_users_delete_user]
  }

  void passwordAuth_createPasswordBasedAccount() async {
    const String emailAddress = 'user@example.com';
    const String password = 'sdf8798324jf673qf8h!';

    // [START password_auth_create_password_based_account]
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    // [END password_auth_create_password_based_account]

    await FirebaseAuth.instance.signOut();

    // [START password_auth_sign_in]
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    // [END password_auth_sign_in]

    // [START password_auth_sign_out]
    await FirebaseAuth.instance.signOut();
    // [END password_auth_sign_out]
  }

  void emailLinkAuth_sendAuthLinkEmail() async {
    // [START email_link_auth_action_code_settings]
    var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12',
    );
    // [END email_link_auth_action_code_settings]

    // [START email_link_auth_send_auth_link_email]
    var emailAuth = 'someemail@domain.com';
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError((error) => print('Error sending email verification $error'))
        .then((value) => print('Successfully sent email verification'));
    // [END email_link_auth_send_auth_link_email]

    await FirebaseAuth.instance.signOut();
  }

  // TODO: ewindmill@ : I'm missing a couple snippets for 'email link' that also require DynamicLinks

  void social_google_sign_in() async {
    // [START social_google_sign_in]
    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    // [END social_google_sign_in]

    // [START social_google_web_auth]
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
    // [END social_google_web_auth]
  }

  void social_googleOnWeb() async {
    // [START social_google_on_web]
    Future<UserCredential> signInWithGoogle() async {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    }
    // [END social_google_on_web]
  }

  void social_facebookAuth() async {
    // [START social_facebook_auth]
    Future<UserCredential> signInWithFacebook() async {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(facebookProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
    }
    // [END social_facebook_auth]
  }

  void social_appleAuth() async {
    // [START social_apple_auth]
    /// Generates a cryptographically secure random nonce, to be included in a
    /// credential request.
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    Future<UserCredential> signInWithApple() async {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    }
    // [END social_apple_auth]
  }

  void social_applePreferableAuth() async {
    // [START social_apple_preferable_auth]
    Future<UserCredential> signInWithApple() async {
      // Create and configure an OAuthProvider for Sign In with Apple.
      final provider = OAuthProvider("apple.com")
        ..addScope('email')
        ..addScope('name');

      // Sign in the user with Firebase.
      return await FirebaseAuth.instance.signInWithPopup(provider);
    }
    // [END social_apple_preferable_auth]
  }

  void social_twitterAuth() async {
    // [START social_twitter_auth]
    Future<UserCredential> signInWithTwitter() async {
      // Create a TwitterLogin instance
      final twitterLogin = TwitterLogin(
          apiKey: '<your consumer key>',
          apiSecretKey: ' <your consumer secret>',
          redirectURI: '<your_scheme>://');

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
    }
    // [END social_twitter_auth]
  }

  void social_twitterWebAuth() async {
    // [START social_twitter_web_auth]
    Future<UserCredential> signInWithTwitter() async {
      // Create a new provider
      TwitterAuthProvider twitterProvider = TwitterAuthProvider();

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(twitterProvider);

      // Or use signInWithRedirect
      // return await FirebaseAuth.instance.signInWithRedirect(twitterProvider);
    }
    // [END social_twitter_web_auth]
  }

  void phoneAuth_verifyPhoneNumber() async {
    // [START phone_auth_verify_phone_number]
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    // [END phone_auth_verify_phone_number]

    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      // [START phone_auth_verification_complete]
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      // [END phone_auth_verification_complete]
      // [START phone_auth_verification_fail]
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      // [END phone_auth_verification_fail]

      // [START phone_auth_code_sent]
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      // [END phone_auth_code_sent]

      // [START phone_auth_code_time_out]
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // auth resolution timed out...
      },
      // [END phone_auth_code_time_out]
    );
  }

  void phoneAuth_webAuth() async {
    if (kIsWeb) {
      // [START phone_auth_web_auth]
      FirebaseAuth auth = FirebaseAuth.instance;

      // Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
      ConfirmationResult confirmationResult =
          await auth.signInWithPhoneNumber('+44 7123 123 456');
      // [END phone_auth_web_auth]

      // [START phone_auth_web_confirmation]
      UserCredential userCredential =
          await confirmationResult.confirm('123456');
      // [END phone_auth_web_confirmation]

      // [START phone_auth_web_with_recaptcha]
      ConfirmationResult confirmationResultWithRecaptcha =
          await auth.signInWithPhoneNumber(
              '+44 7123 123 456',
              RecaptchaVerifier(
                auth: FirebaseAuthPlatform.instance,
                container: 'recaptcha',
                size: RecaptchaVerifierSize.compact,
                theme: RecaptchaVerifierTheme.dark,
              ));
      // [END phone_auth_web_with_recaptcha]

      // [START phone_auth_verify_recaptcha]
      RecaptchaVerifier(
        auth: FirebaseAuthPlatform.instance,
        onSuccess: () => print('reCAPTCHA Completed!'),
        onError: (FirebaseAuthException error) => print(error),
        onExpired: () => print('reCAPTCHA Expired!'),
      );
      // [END phone_auth_verify_recaptcha]
    }
  }

  void customAuth_withFirebase() async {
    const token = '1234superGoodToken';

    // [START custom_auth_with_firebase]
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(token);
      print("Sign-in successful.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          print("The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("The supplied token is for a different Firebase project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    // [END custom_auth_with_firebase]
    await FirebaseAuth.instance.signOut();
  }

  void anonymousAuth_withFirebase() async {
    // [START anonymous_auth_with_firebase]
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    // [END anonymous_auth_with_firebase]

    const idToken = 'googleSignInIdToken';
    const emailAddress = 'user@example.com';
    const password = 'jks74l8q238d9sds!';

    // [START anonymous_auth_get_credential]
    // Google Sign-in
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    // Email and password sign-in
    final emailAndPasswordCredential =
        EmailAuthProvider.credential(email: emailAddress, password: password);

    // Etc.
    // [END anonymous_auth_get_credential]

    // [START anonymous_auth_link_with_credential]
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
      // [END anonymous_auth_link_with_credential]
    }

    await FirebaseAuth.instance.signOut();
  }

  void link_accounts_get_credentials() async {
    const idToken = 'googleSignInIdToken';
    const emailAddress = 'user@example.com';
    const password = 'jks74l8q238d9sds!';
    // [START link_accounts_get_credentials]

    // Google Sign-in
    final credential = GoogleAuthProvider.credential(idToken: idToken);

    // Email and password sign-in
    final emailAndPasswordCredential =
        EmailAuthProvider.credential(email: emailAddress, password: password);

    // Etc.
    // [END link_accounts_get_credentials]

    // [START link_accounts_link_with_credential]
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
      // [END link_accounts_link_with_credential]
    }

    const providerId = 'google';
    // [START link_accounts_unlink_auth_provider]
    try {
      await FirebaseAuth.instance.currentUser?.unlink(providerId);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "no-such-provider":
          print("The user isn't linked to the provider or the provider "
              "doesn't exist.");
          break;
        default:
          print("Unkown error.");
      }
    }
    // [END link_accounts_unlink_auth_provider]
  }
}
