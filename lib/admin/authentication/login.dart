
import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:final_emeds/admin/authentication/signup.dart';
import 'package:final_emeds/admin/menu.dart';
import 'package:final_emeds/main.dart';
import 'package:final_emeds/user/menubar/user_menu.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // ignore: non_constant_identifier_names
  String CorrectUsername = 'admin@gmail.com';
  // ignore: non_constant_identifier_names
  String CorrectPassword = '1234';

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showError = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String enteredUsername = emailController.text.trim();
      String enteredPassword = passwordController.text.trim();
      if (enteredUsername == CorrectUsername &&
          enteredPassword == CorrectPassword) {
        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setBool(SAVEKEY, true);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Mymenu()));
      } else {
        login(emailController.text, passwordController.text, context);
      }

      //   login(
//    emailController.text,
//    passwordController.text,
//    context,
//  );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In  ",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 35.0),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset('asset/img/emeds.png'),
                       const  SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty && showError) {
                              return 'Please enter your email';
                            }

                            if (value.isNotEmpty &&
                                !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                    .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              showError = false;
                            });
                          },
                          onFieldSubmitted: (_) {
                            setState(() {
                              showError = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            filled: true,
                            prefixIcon: const Icon(Icons.key),
                            labelText: 'password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 2.0,
                              ),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 45), backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    ),
                                    ),
                                    
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an Account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const signin()),
                                );
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String password, BuildContext context) async {
    final usersBox =
        await Hive.openBox<Data>('users'); // Open the Hive box for users

    Data? user;

    for (var i = 0; i < usersBox.length; i++) {
      final currentUser = usersBox.getAt(i);

      if (currentUser?.email == email && currentUser?.password == password) {
        user = currentUser;
        break;
      }
    }

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid email or password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
