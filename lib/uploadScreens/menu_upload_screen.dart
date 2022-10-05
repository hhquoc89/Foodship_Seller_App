import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/global/global.dart';

import 'package:foodship_seller_app/mainScreens/home_screen.dart';
import 'package:foodship_seller_app/widgets/error_dialog.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storgeRef;

class MenuUploadScreen extends StatefulWidget {
  const MenuUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now()
      .microsecondsSinceEpoch
      .toString(); // tạo id cho menu bằng cách lấy thời gian lúc tạo menu làm id

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
          'Add New Menu',
          style: TextStyle(fontFamily: 'Signatra', fontSize: 30),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const HomeScreen())));
          },
        ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_2,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  takeImage(context);
                },
                child: const Text(
                  'Add new Menu',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)))),
              )
            ],
          ),
        ),
      ),
    );
  }

  menuUploadFromScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
          'Uploading The Menu',
          style: TextStyle(fontFamily: 'Signatra', fontSize: 30),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
              onPressed: uploading ? null : () => validateUploadForm(),
              child: const Text(
                'Add',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(''),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
                child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(imageXFile!.path)),
                        fit: BoxFit.cover)),
              ),
            )),
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleInfoController,
                inputFormatters: [],
                decoration: const InputDecoration(
                  labelText: 'Menu Title',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.cyan,
            ),
            title: Container(
              height: 100,
              width: 20,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  labelText: 'Menu Information',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose Image '),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.end,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleInfoController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleInfoController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // upload image
        String dowloadUrl = await uploadImage(
            File(imageXFile!.path)); // url sau khi get được từ firebase về
        // save info to firebase
        saveInfo(
            dowloadUrl, shortInfoController.text, titleInfoController.text);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  message: "Please insert information or title menu");
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Please insert a image");
          });
    }
  }

  saveInfo(String dowloadUrl, String shortInfo, String titleMenu) {
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus');
    ref.doc(uniqueIdName).set({
      'menuID': uniqueIdName,
      'sellerUID': sharedPreferences!.getString('uid'),
      'menuInfo': shortInfoController.text.toString(),
      'menuTitle': titleInfoController.text.toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': dowloadUrl,
    });

    clearMenuUploadForm();
    uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
    ;
    uploading = false;
  }

  uploadImage(mImageFile) async {
    // tạo 1 nhánh child menu trong firebase
    storgeRef.Reference reference =
        storgeRef.FirebaseStorage.instance.ref().child('menus');
    // trong nhánh menus của firebase tạo ra 1 menu với dạng string bao gồm id và đường dẫn của file up lên firebase
    storgeRef.UploadTask uploadTask =
        reference.child(uniqueIdName + '.jpg').putFile(mImageFile);
    // đợi upload task xong thì tạo ra tasksnapshot
    storgeRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    // Sau khi tạo xong tasksnapshot thì nó sẽ trả về 1 string dowload url
    String dowloadURL = await taskSnapshot.ref.getDownloadURL();
    // sử dụng dowloadURL này để show menu từ firebase
    return dowloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menuUploadFromScreen();
  }
}
