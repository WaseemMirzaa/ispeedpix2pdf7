import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No Web options have been provided yet - configure Firebase for Web',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

 static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEI6BMIKtvGGDVpGu5cY7ojnacQkDOjtw',
    appId: '1:336767545818:ios:5f08e58bfec9ea80d210e3',
    messagingSenderId: '336767545818',
    projectId: 'tispeedpixtopdfios',
    storageBucket: 'ispeedpixtopdfios.firebasestorage.app',
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAV9O1cNRA5X_gvaI7auep9jhdkmNA_GT0',
    appId: '1:466315140538:android:212424e0a379183fed9183',
    messagingSenderId: '466315140538',
    projectId: 'tevin-eigh---ispeed-apps',
    storageBucket: 'tevin-eigh---ispeed-apps.firebasestorage.app',
  );
}
