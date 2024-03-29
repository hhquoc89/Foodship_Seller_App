import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/mainScreens/home_screen.dart';
import 'package:foodship_seller_app/models/menu.dart';
import 'package:foodship_seller_app/widgets/error_dialog.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storgeRef;
import 'package:intl/intl.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreen();
}

class _ItemsUploadScreen extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String _formatNumber(String s) {
    if (s == '') {
      s = "0";
    }
    return NumberFormat.decimalPattern(locale).format(int.parse(s));
  }

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: locale).currencySymbol;

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
          'Thêm món',
          style: TextStyle(fontSize: 20),
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
                  'Thêm món mới',
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

  itemsUploadFromScreen() {
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
          'Thêm món mới',
          style: TextStyle(fontSize: 20),
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
                'Thêm',
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
            width: MediaQuery.of(context).size.width * 0.5,
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
              height: 50,
              width: 20,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleInfoController,
                decoration: const InputDecoration(
                  labelText: 'Tên món',
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
              height: 50,
              width: 20,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  labelText: 'Giới thiệu ngắn về món',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.cyan,
            ),
            title: Container(
              height: 50,
              width: 20,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Thông tin của món',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.cyan,
            ),
            title: Container(
              height: 50,
              width: 20,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Giá tiền (VND)',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (string) {
                  string = _formatNumber(string.replaceAll(',', ''));
                  priceController.value = TextEditingValue(
                    text: string,
                    selection: TextSelection.collapsed(offset: string.length),
                  );
                },
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
            title: const Text('Chọn Ảnh từ ... '),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Chụp Ảnh từ Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Chọn từ Thư viện Ảnh",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Hủy",
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
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleInfoController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
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
              return ErrorDialog(message: "Vui lòng điền đầy đủ các thông tin");
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "Vui lòng thêm Ảnh cho món");
          });
    }
  }

  setKeyWordTitle(String textInput) {
    List<String> keywordsList = [];
    String temp = "";
    for (int i = 0; i < textInput.length; i++) {
      temp = temp + textInput[i];
      keywordsList.add(temp);
    }

    return keywordsList;
  }

  saveInfo(String dowloadUrl, String shortInfo, String titleMenu) {
    print(priceController.text.replaceAll(RegExp('[^0-9]'), ''));
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID)
        .collection('items');

    ref.doc(uniqueIdName).set({
      'itemID': uniqueIdName,
      'menuID': widget.model!.menuID,
      'sellerUID': sharedPreferences!.getString('uid'),
      'sellerName': sharedPreferences!.getString('name'),
      'shortInfo': shortInfoController.text.toString(),
      'longDescription': descriptionController.text.toString(),
      'price': int.parse(priceController.text.replaceAll(RegExp('[^0-9]'), '')),
      'title': titleInfoController.text.toString(),
      'title_keywords': setKeyWordTitle(titleInfoController.text.trim()),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': dowloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection('items');
      itemsRef.doc(uniqueIdName).set({
        'itemID': uniqueIdName,
        'menuID': widget.model!.menuID,
        'sellerUID': sharedPreferences!.getString('uid'),
        'sellerName': sharedPreferences!.getString('name'),
        'shortInfo': shortInfoController.text.toString(),
        'longDescription': descriptionController.text.toString(),
        'price':
            int.parse(priceController.text.replaceAll(RegExp('[^0-9]'), '')),
        'title': titleInfoController.text.toString(),
        'title_keywords': setKeyWordTitle(titleInfoController.text.toString()),
        'publishedDate': DateTime.now(),
        'status': 'available',
        'thumbnailUrl': dowloadUrl,
      });
    }).then((value) {
      clearMenuUploadForm();
      setState(() {
        uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadImage(mImageFile) async {
    // tạo 1 nhánh child menu trong firebase
    storgeRef.Reference reference =
        storgeRef.FirebaseStorage.instance.ref().child('items');
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
    return imageXFile == null ? defaultScreen() : itemsUploadFromScreen();
  }
}
