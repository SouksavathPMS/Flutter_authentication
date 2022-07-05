import 'package:auth_login/screen/home_page.dart';
import 'package:auth_login/screen/login_screen.dart';
import 'package:auth_login/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late Stream<User?> user;
  late AuthService auth;

  @override
  void initState() {
    auth = AuthService();
    user = auth.authstateChange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(auth: auth);
        } else {
          return LoginScreen(auth: auth);
        }
      },
    );
  }
}
