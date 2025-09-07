import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyDswYx0Zhg1iU4tk5U6uthnVjvMK6qr-50",
      appId: "1:511842590551:android:7bf37acba8efd3f1a26812",
      messagingSenderId: "511842590551",
      projectId: "talkbridge-dd414",
      storageBucket: "talkbridge-dd414.appspot.com",
      // ⚠️ authDomain hata do (ye sirf web ke liye hota hai)
      // ⚠️ measurementId bhi tabhi chahiye jab tum Firebase Analytics (web) use karo
    );
  }
}
