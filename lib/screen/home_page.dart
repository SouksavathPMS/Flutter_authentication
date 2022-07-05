import 'package:auth_login/screen/login_screen.dart';
import 'package:auth_login/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        actions: [
          GestureDetector(
            onTap: auth.logOut,
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: SizedBox(
        child: auth.currentUser != null
            ? Column(
                children: [
                  const Text('HomePage', style: kLoginStyle),
                  const SizedBox(height: 10),
                  Text('User : ${auth.currentUser!.displayName}'),
                  Text('Email : ${auth.currentUser!.email}'),
                ],
              )
            : Container(),
      )),
    );
  }
}
