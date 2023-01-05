import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/models/address.dart';
import 'package:foodship_seller_app/models/user.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

// ignore: library_prefixes
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterTableScreen extends StatefulWidget {
  const RegisterTableScreen({Key? key}) : super(key: key);

  @override
  State<RegisterTableScreen> createState() => _RegisterTableScreenState();
}

class _RegisterTableScreenState extends State<RegisterTableScreen> {
  final _phoneNumber = TextEditingController();

  final _flatNumber = TextEditingController();

  final _city = TextEditingController();

  final _state = TextEditingController();

  final _completeAddress = TextEditingController();

  final _locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<Placemark>? placemarks;

  Position? position;
  getUserLocationAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newPosition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placemarks![0];

    String fullAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = "";

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
            return ErrorDialog(message: "Vui lòng thêm ảnh!");
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
                  message: "",
                );
              });

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child('tables')
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
                return ErrorDialog(message: "Vui lòng nhập đầy đủ thông tin");
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  message: "Mật khẩu không khớp nhau ! Vui lòng nhập lại");
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
        Fluttertoast.showToast(msg: 'Tạo bàn thành công!');
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    final model = Address(
      name: nameController.text.trim(),
      state: _state.text.trim(),
      fullAddress: _completeAddress.text.trim(),
      phoneNumber: _phoneNumber.text.trim(),
      flatNumber: _flatNumber.text.trim(),
      city: _city.text.trim(),
      lat: 0.0,
      lng: 0.0,
    ).toJson();
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    final List<dynamic> allData =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    final List<UserModel> users = [];
    for (final e in allData) {
      users.add(UserModel.fromJson(e));
    }
    for (final UserModel user in users) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.userUID)
          .collection("userAddress")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(model);
    }

    FirebaseFirestore.instance.collection("tables").doc(currentUser.uid).set({
      "tableUID": currentUser.uid,
      "tableEmail": currentUser.email,
      "tableName": nameController.text.trim(),
      "tableAvatarUrl": sellerImageUrl,
      "status": "approve",
    });
    // save data locally
    // sharedPreferences = await SharedPreferences.getInstance();
    // await sharedPreferences!.setString('uid', currentUser.uid);
    // await sharedPreferences!.setString('email', currentUser.email.toString());
    // await sharedPreferences!.setString('name', nameController.text.trim());
    // await sharedPreferences!.setString('photoUrl', sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     child: Center(
      //   child: Column(
      //     children: const [
      //       SizedBox(
      //         height: 100,
      //       ),
      //       Text(
      //         'Please contact the admin to Register !!!',
      //         style: TextStyle(fontSize: 18),
      //       ),
      //     ],
      //   ),
      // )
      appBar: SimpleAppBar(
        title: 'Thêm bàn',
      ),
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
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.20,
                        color: Colors.grey,
                      )
                    : null,
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
                    hintText: "Tên bàn",
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
                    hintText: "Nhập lại Mật khẩu",
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
              child: Container(
                width: MediaQuery.of(context).size.width * .15,
                child: const Text(
                  "Đăng ký Bàn",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
