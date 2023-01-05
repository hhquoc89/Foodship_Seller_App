import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

import 'package:image_picker/image_picker.dart';
// ignore: library_prefixes
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String userImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: const Text(
                "Cảnh báo",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "Hình như là thiếu ảnh đại diện ? Bạn muốn tiếp tục",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Không"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    userImageUrl == '';
                    Navigator.pop(context);
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      if (confirmPasswordController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          nameController.text.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return LoadingDialog(
                                message: "Đang đăng kí tài khoản ,",
                              );
                            });
                        if (userImageUrl != '') {
                          String fileName =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          fStorage.Reference reference = fStorage
                              .FirebaseStorage.instance
                              .ref()
                              .child('users')
                              .child(fileName);
                          fStorage.UploadTask uploadTask =
                              reference.putFile(File(imageXFile!.path));
                          fStorage.TaskSnapshot taskSnapshot =
                              await uploadTask.whenComplete(() {});
                          await taskSnapshot.ref.getDownloadURL().then((url) {
                            userImageUrl = url;
                            // save information to firestore
                            authenticateSellerAndSignUp();
                          });
                        }
                        authenticateSellerAndSignUp();
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorDialog(
                                  message: "Vui lòng nhập đủ thông tin");
                            });
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorDialog(
                                message:
                                    "Mật khẩu không khớp ! Vui lòng nhập lại");
                          });
                    }
                  },
                  child: const Text("Có"),
                ),
              ],
            );
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Đang đăng kí tài khoản ,",
                );
              });

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child('users')
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl = url;
            // save information to firestore
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(message: "Vui lòng nhập đủ thông tin ");
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  message: "Mật khẩu không khớp ! Vui lòng nhập lại");
            });
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((auth) {
        currentUser = auth.user;
      });
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    }

    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        Navigator.pop(context);
        //send user to homePage
        Fluttertoast.showToast(msg: 'Tạo tài khoản thành công!!!');
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userPhone": '',
      "userIDCard": '',
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "userName": nameController.text.trim(),
      "userAvatarUrl": userImageUrl,
      "status": "approve",
      "userCart": []
    });
    // save data locally
    // sharedPreferences = await SharedPreferences.getInstance();
    // await sharedPreferences!.setString('uid', currentUser.uid);
    // await sharedPreferences!.setString('email', currentUser.email.toString());
    // await sharedPreferences!.setString('name', nameController.text.trim());
    // await sharedPreferences!.setString('photoUrl', sellerImageUrl);
    // await sharedPreferences!.setStringList('userCart', ['itemValue']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Đăng kí tài khoản'),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundColor: Colors.white,
                      backgroundImage: imageXFile == null
                          ? null
                          : FileImage(File(
                              imageXFile!.path,
                            )),
                      child: imageXFile == null
                          ? Icon(
                              Icons.add_photo_alternate,
                              size: MediaQuery.of(context).size.width * 0.20,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const Positioned(
                    child: CircleAvatar(
                      child: Icon(
                        Icons.add,
                        size: 25,
                      ),
                    ),
                    top: 1,
                    right: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Tên",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Mật khẩu",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Nhập lại mật khẩu",
                    isObsecre: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () {
                formValidation();
              },
              child: const Text(
                "Đăng kí",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
