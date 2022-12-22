import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_chat_app/firebaseAuth/auth_helper.dart';
import 'package:flutter_firestore_chat_app/firestoreUser/user_db_helper.dart';
import 'package:flutter_firestore_chat_app/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  late String imageUrl;

  var email = '';
  var password = '';
  var name = '';
  var phone = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  _getFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(imageFile!.path);
      });
    }
  }

  // uploading of image
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      File? file = File(pickedFile!.path);

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/imageName')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  imageFile == null
                      ? Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 70,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    // _getFromGallery();
                                    uploadImage();
                                  },
                                  icon: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.blue,
                                  )),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            CircleAvatar(
                              // backgroundColor: Colors.grey,
                              backgroundImage: FileImage(File(imageFile!.path)),
                              radius: 70,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    // _getFromGallery();
                                    uploadImage();
                                  },
                                  icon: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.blue,
                                  )),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //text field for name
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Name',
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
                              return 'Please Enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //text field for phone
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'phone',
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
                              return 'Please Enter phone no.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // email text field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            } else if (!value.contains('.')) {
                              return 'Please Enter .';
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
                            } else if (value.length < 6) {
                              return 'password should be >6 char long';
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
                                email = emailController.text.trim();
                                password = passwordController.text.trim();
                                name = nameController.text.trim();
                                phone = phoneController.text.trim();
                              });
                              // sign in function will be called from here
                              bool created = await context
                                  .read<AuthProvider>()
                                  .creatUser(email, password);

                              print(created);
                              if (created) {
                                print(
                                    'user added to auth now going to add into database..');
                                context
                                    .read<UserProvider>()
                                    .addUserToDb(name, email, phone);
                                Navigator.pop(context);
                              } else {
                                print(
                                    'Error Occured while adding new user to database');
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
                              // signin  page
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text("Already have an account? click here")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
