import 'package:flutter/material.dart';
import 'package:mocking_first_mocktail/article_7/form_widget.dart';
import 'package:mocking_first_mocktail/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing_page/landing_page.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final auth = Authentication(localStorage: prefs, logger: Logger());

  runApp(MaterialApp(
      routes: {
        '/homePage': (context) => const LandingPage(),
      },
      home: LoginScreen()
      // home:LoginScreenNew(auth: auth)
      ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Authentication auth;
  bool isLoggedIn = false;
  final _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> initAuthInstance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      auth = Authentication(localStorage: prefs, logger: Logger());

      isLoggedIn = auth.isLoggedIn();
    });
  }

  @override
  void initState() {
    super.initState();
    initAuthInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isLoggedIn)
            TextButton(
              onPressed: () {
                setState(() {
                  isLoggedIn = false;
                  auth.setLoginStatus(false);
                  _formKey.currentState!.reset();
                });
              },
              child:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('welcome User'),
              TextFormField(
                key: const ValueKey('userName'),
                controller: _userNameController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter User Name'),
                validator: (name) => auth.validateUserName(name),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('password'),
                autofocus: true,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Enter Password'),
                validator: (password) => auth.validatePassword(password),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoggedIn = true;
                      });
                      auth.setLoginStatus(true).then((value) {
                        auth.setUserName(_userNameController.text);
                        Navigator.pushNamed(context, '/homePage');
                      });
                    }
                  },
                  child: const Text(
                    'Press to Log In',
                    maxLines: 2,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
