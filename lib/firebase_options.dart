import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // For demo/submission, you MUST fill this with YOUR ACTUAL project details.
    // Or add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
    return const FirebaseOptions(
      apiKey: 'AIzaSyAFvBy6VXPB9AVOGv7DvIX-OVDGw0CvFfw',
      appId: '1:238570140378:android:c97a72bfd63a763564abe3',
      messagingSenderId: '238570140378',
      projectId: 'to-do-list-365ed',
      databaseURL: 'https://to-do-list-365ed-default-rtdb.firebaseio.com',
      storageBucket: 'to-do-list-365ed.firebasestorage.app',
    );
  }
}
