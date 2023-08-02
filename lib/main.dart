import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olxclone/Providers/userrr_provider.dart';
import 'package:olxclone/Responsive_Layout/mobile_screen_layout.dart';
import 'package:olxclone/Responsive_Layout/responsive_layout.dart';
import 'package:olxclone/Providers/user_provider.dart'; // Import the UserProvider
import 'package:olxclone/Responsive_Layout/web_screen_layout.dart';
import 'package:olxclone/Screens/login_screen.dart';
import 'package:olxclone/Screens/sign_up_screen.dart';
import 'package:olxclone/Utils/colors.dart';
import 'package:provider/provider.dart'; // Import the provider package

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          // Wrap MaterialApp with the ChangeNotifierProvider
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<UserrrProviderr>(
          // Wrap MaterialApp with the ChangeNotifierProvider
          create: (_) => UserrrProviderr(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return LoginScreen();
            },
          )),
    );
  }
}
