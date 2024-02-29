
import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:final_emeds/admin/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


// ignore: camel_case_types
class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

// ignore: camel_case_types
class _signinState extends State<signin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      signup(emailController.text, passwordController.text, context,
          nameController.text, phoneNumberController.text);
    }
  }
  bool isValidEmail(String email) {
     final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(31, 195, 172, 89),
                          filled: true,
                          prefixIcon:
                              const Icon(Icons.supervised_user_circle_outlined),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                          
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          fillColor:const Color.fromARGB(31, 195, 172, 89),
                          filled: true,
                          prefixIcon: const Icon(Icons.phone),
                          labelText: 'Phone number',
                          border: OutlineInputBorder(


borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                          
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length > 10) {
                            return 'Phone number must contain atleast 10 digit';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // _password = value!;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor:const Color.fromARGB(31, 195, 172, 89),
                          filled: true,
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'yourname@gmail.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                            
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          }
                          if (!isValidEmail(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                        },
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          fillColor:const  Color.fromARGB(31, 195, 172, 89),
                          filled: true,
                          prefixIcon: const Icon(Icons.key),
                          labelText: 'Password',
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
                        onSaved: (value) {
                          // _password = value!;
                        },
                      ),
                      const SizedBox(height: 100.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        
                        style: ElevatedButton.styleFrom(
                            
                            fixedSize: const Size(400,
                                45), 
                                // Set the background color of the button to black

shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors
                                .white, // Set the text color of the button to white
                          ),
                        ),
                      ),const SizedBox(height: 40,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an Account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>const LoginForm(),
                                      ),
                                    
                                );
                                
                              },
                               style: TextButton.styleFrom(
                              foregroundColor: Colors.teal, 
  ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.blue),
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
    );
    
  }
}

void signup(String email, String password, BuildContext context, String name,
    String number) async {
      
  // await Hive.initFlutter();
  await Hive.openBox<Data>('users'); // Open the Hive box for users

  final usersBox = Hive.box<Data>('users');

  final userExists = usersBox.values.any((user) => user.email == email);
  if (userExists) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('User already exists'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    final user =
        Data(email: email, password: password, name: name, number: number);
    usersBox.add(user);
    // ignore: use_build_context_synchronously
    showDialog(  
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Account created successfully'),
          actions: [
            TextButton(
              onPressed: () {
                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>const LoginForm()),
                                );
          
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}