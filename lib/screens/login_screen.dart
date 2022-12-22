import 'package:flutter/material.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';
import 'package:flutter_firestore_chat_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var email = '';
  var password = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.all(16),
                          fillColor: Colors.grey.withOpacity(0.2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.all(16),
                          fillColor: Colors.grey.withOpacity(0.2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            // sign in function will be called from here
                            bool log = await context
                                .read<AuthProvider>()
                                .signInWithEmailandPass(
                                    email.trim(), password.trim());
                            if (log) {
                              print('log in succesfull');
                              //Navigator.pu
                            } else {
                              print('error occured during log in ');
                            }
                          }
                        },
                        child: Text('Sign In'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            // sign up page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text("New User? Click here")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
