import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firestore_chat_app/chat/chat_helper.dart';
import 'package:flutter_firestore_chat_app/firestoreUser/group_db_helper.dart';
import 'package:flutter_firestore_chat_app/firestoreUser/user_db_helper.dart';
import 'package:flutter_firestore_chat_app/screens/login_screen.dart';
import 'package:flutter_firestore_chat_app/screens/sign_up_screen.dart';
import 'package:flutter_firestore_chat_app/screens/user_home.dart';
import 'package:provider/provider.dart';

import 'firebaseAuth/auth_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
          ChangeNotifierProvider<GroupProvider>(create: (_) => GroupProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return oldMethod();
  }

  Widget oldMethod() {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user != null) {
            print("user is logged in as : $user ");

            return UserHome();
          } else {
            print("user is not logged in");
            return LoginPage();
          }
        },
      ),
    );
  }
}
