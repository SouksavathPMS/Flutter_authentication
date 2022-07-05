import 'dart:async';

import 'package:auth_login/service/auth_service.dart';
import 'package:flutter/material.dart';

const kLoginStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.red,
);
const kOrStyle = TextStyle(
  fontSize: 16,
  color: Colors.orange,
);
const kOrError = TextStyle(
  fontSize: 16,
  color: Colors.red,
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.auth}) : super(key: key);
  final AuthService auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  bool _isRegister = false;
  bool _isShowingPassword = true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late StreamController<String?> errorController;
  late Stream<String?> errorStream;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    errorController = StreamController<String?>.broadcast();
    errorStream = errorController.stream;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildErrorText(),
            _buildContent(),
          ],
        ),
      ),
    ));
  }

  Widget _buildErrorText() {
    return StreamBuilder<String?>(
      stream: errorStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                snapshot.data.toString(),
                style: kOrError,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildContent() {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                child: Text(
                  _isRegister ? 'Register Form' : 'Login Form',
                  style: kLoginStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              _buildEmailField(),
            ],
          );
  }

  Widget _buildEmailField() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter valid email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            onChanged: (value) {
              errorController.add(null);
            },
          ),
          Stack(
            children: [
              TextFormField(
                obscureText: _isShowingPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some password';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  errorController.add(null);
                },
              ),
              Positioned(
                right: 0,
                top: 25,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingPassword = !_isShowingPassword;
                    });
                  },
                  child: _isShowingPassword
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _isRegister,
                onChanged: (value) {
                  setState(() {
                    _isRegister = value!;
                  });
                },
              ),
              Text(_isRegister ? 'Uncheck to LOGIN' : 'Check to REGISTER'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // if (!_formKey.currentState!.validate()) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')),
                  //   );
                  // } else {
                  setState(() {
                    _loading = true;
                  });

                  if (_isRegister) {
                    try {
                      await widget.auth.creataUserWithEmail(
                          email: emailController.text,
                          password: passwordController.text);
                    } catch (e) {
                      errorController.add(getErrorMessage(
                        e.toString(),
                      ));
                    }
                  } else {
                    try {
                      await widget.auth.logInWithEmail(
                          email: emailController.text,
                          password: passwordController.text);
                    } catch (e) {
                      errorController.add(getErrorMessage(
                        e.toString(),
                      ));
                    }
                  }
                  setState(() {
                    _loading = false;
                  });

                  // }
                },
                child: Text(_isRegister ? 'Register' : 'Login'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  emailController.clear();
                  passwordController.clear();
                  errorController.add(null);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  await widget.auth.signInWithGoogle();
                },
                child: SizedBox(
                    width: 80,
                    child: Image.asset('assets/images/google-icon.png')),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  await widget.auth.signInWithFacebook();
                },
                child: SizedBox(
                    width: 80,
                    child: Image.asset('assets/images/Facebook.png')),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getErrorMessage(String errorText) {
    List<String> result = errorText.split('] ');
    return result.last;
  }
}
