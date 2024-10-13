import 'package:flutter/material.dart';
import 'package:mocking_first_mocktail/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenNew extends StatefulWidget {
  final Authentication auth;
  const LoginScreenNew({super.key, required this.auth});

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {

  bool isLoggedIn = false, showLoader = false;
  final _userNameController = TextEditingController(),
      _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                validator: (name) => widget.auth.validateUserName(name),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('password'),
                controller: _passwordController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter Password'),
                validator: (password) => widget.auth.validatePassword(password),
              ),
              const SizedBox(height: 40),
              if (showLoader) ...[
                CircularProgressIndicator()
              ] else ...[
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showLoader = true;
                        });

                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                        setState(() {
                          showLoader = false;
                        });
                        if (!isLoggedIn) {
                          _userNameController.clear();
                          _passwordController.clear();
                        }
                      }
                    },
                    child: Text(
                      isLoggedIn ? 'Press to Logout' : 'Press to LogIn',
                      maxLines: 2,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
