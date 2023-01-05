import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/models/items.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';
import 'package:intl/intl.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID!)
        .collection('items')
        .doc(itemID)
        .delete();
    Fluttertoast.showToast(msg: 'Xóa món thành công!!!');
    Navigator.pop(context);
  }

  adjustAvailableStatus(String itemID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID!)
        .collection('items')
        .doc(itemID)
        .update({'status': 'available'});
    FirebaseFirestore.instance
        .collection('items')
        .doc(itemID)
        .update({'status': 'available'});
    Fluttertoast.showToast(msg: 'Thay đổi trạng thái món ăn thành công!!!');
    Navigator.pop(context);
  }

  adjustEmptyStatus(String itemID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID!)
        .collection('items')
        .doc(itemID)
        .update({'status': 'empty'});
    FirebaseFirestore.instance
        .collection('items')
        .doc(itemID)
        .update({'status': 'empty'});
    Fluttertoast.showToast(msg: 'Thay đổi trạng thái món ăn thành công!!!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String? message;
    String? status = widget.model!.status;

    status == 'available' ? message = "Còn hàng" : message = "Hết hàng";
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Chi tiết món ăn',
      ),
      body: ListView(
        children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
            height: 400,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              oCcy.format(widget.model!.price!).toString() + 'đ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              status == 'available'
                  ? InkWell(
                      onTap: () {
                        adjustEmptyStatus(widget.model!.itemID!);
                      },
                      child: Container(
                        color: Colors.orange,
                        width: MediaQuery.of(context).size.width * .4,
                        height: 50,
                        child: const Center(
                          child: Text(
                            'Báo hết',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        adjustAvailableStatus(widget.model!.itemID!);
                      },
                      child: Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.width * .4,
                        height: 50,
                        child: Center(
                          child: const Text(
                            'Báo có hàng',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
              InkWell(
                onTap: () {
                  deleteItem(widget.model!.itemID!);
                },
                child: Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width * .4,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Xóa món',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
