import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app/firebase_options.dart';
import 'package:salon_app/view_models/home_view_model.dart';
import 'package:salon_app/screens/introduction/splash_screen.dart';
import 'package:salon_app/utils/functions.dart';

// salon_user (key alias)
// salonuser (kstore pswd)
// ./gradlew signingReport (for generating debug SHA keys in android studio)


// Todo
//* Highlights
//! Warning
// Simple comment
//? log/print
// Bug

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
            create: ((context) => HomeViewModel()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Salon app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
