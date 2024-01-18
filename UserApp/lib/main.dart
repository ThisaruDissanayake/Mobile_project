import 'package:appecommerce/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:appecommerce/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:appecommerce/ui/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Wait for Firebase to initialize

   // Initialize Firebase In-App Messaging
  FirebaseInAppMessaging.instance;
  
  Stripe.publishableKey =
      'pk_test_51OZPqXL8vLmen1m4Wq3CaSR3XHdkfxGZJWDdn7ezzF7wpBefCCavRRX07PKuVfez2opcS2AzkmjKUWFHBfVLtJ7T00iDxd5KOR';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter E commerce',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen(),
            
            // Define your routes here
            routes: {
              '/login': (context) => LoginScreen(),
              // Other routes...
            },
            
            // Set the initial route or home
            initialRoute: '/', // You can set it to '/login' if you want LoginScreen as the initial screen
          );
        },
      ),
    );
  }
}
