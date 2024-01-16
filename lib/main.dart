import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Presentation/login_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: 'gs://fluttermovierestapiproject.appspot.com',
          apiKey: 'AIzaSyDfZp6Y7tekwwMWlcYiCfizYS9n9lY9ADc',
          appId: '1:744505086852:android:896c729b85dfe9e44283d1',
          messagingSenderId: '744505086852',
          projectId: 'fluttermovierestapiproject'
      )
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),

  ));
}

