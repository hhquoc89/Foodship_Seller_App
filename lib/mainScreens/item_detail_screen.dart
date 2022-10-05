import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/models/items.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

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
    Fluttertoast.showToast(msg: 'Detele Item Successfully!!!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: sharedPreferences!.getString('name') ?? '' + 'Details',
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
              widget.model!.price!.toString() + " VND",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: () {
                deleteItem(widget.model!.itemID!);
              },
              child: Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width - 13,
                height: 50,
                child: Center(
                  child: Text(
                    'Delete Item ',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
