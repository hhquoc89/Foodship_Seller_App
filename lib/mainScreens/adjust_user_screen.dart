import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class AdjustUserScreen extends StatefulWidget {
  final String? userID;
  final String? userName;
  final String? userAvatarUrl;
  AdjustUserScreen({this.userID, this.userName, this.userAvatarUrl});

  @override
  State<AdjustUserScreen> createState() => _AdjustUserScreenState();
}

class _AdjustUserScreenState extends State<AdjustUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController IDCardController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = '';

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
            return ErrorDialog(message: "Vui lòng chọn ảnh");
          });
    } else {
      if (nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          IDCardController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(
                message: "Đang cập nhật ,",
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
          sellerImageUrl = url;
          // save information to firestore
          authenticateSellerAndSignUp();
        });
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(message: "Vui lòng điền đầy đủ thông tin");
            });
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    saveDataToFireStore();
    nameController.clear();
    phoneController.clear();
    IDCardController.clear();
    Navigator.pop(context);
    Navigator.pop(context);
    //send user to homePage
    Fluttertoast.showToast(msg: 'Đã cập nhật tài khoản!!!');
  }

  Future saveDataToFireStore() async {
    FirebaseFirestore.instance.collection("users").doc(widget.userID).update({
      "userName": nameController.text.trim(),
      "userPhone": phoneController.text.trim(),
      "userAvatarUrl": sellerImageUrl,
      "userIDCard": IDCardController.text.trim(),
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
    String urlImage = widget.userAvatarUrl ?? '';
    return Scaffold(
      appBar: SimpleAppBar(title: 'Cập nhật tài khoản'),
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
                          // ? Icon(
                          //     Icons.add_photo_alternate,
                          //     size: MediaQuery.of(context).size.width * 0.20,
                          //     color: Colors.grey,
                          //   )
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: urlImage == ''
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent),
                                      child: Center(
                                          child: Text(
                                        widget.userName
                                            .toString()
                                            .toUpperCase()[0],
                                        style: TextStyle(
                                            fontSize: 40, color: Colors.black),
                                      )),
                                    )
                                  : CircleAvatar(
                                      radius: 200,
                                      backgroundImage: NetworkImage(
                                        widget.userAvatarUrl!,
                                      ),
                                    ))
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
                    hintText: widget.userName,
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Số điện thoại",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.card_membership,
                    controller: IDCardController,
                    hintText: "Số CMND/CCCD",
                    isObsecre: false,
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Thay đổi tài khoản",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          "Bạn muốn cập nhật thông tin này?",
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
                            onPressed: () {
                              formValidation();
                            },
                            child: const Text("Có"),
                          ),
                        ],
                      );
                    });
              },
              child: const Text(
                "Thay đổi",
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
