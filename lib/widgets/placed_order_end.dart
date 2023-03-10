// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/models/items.dart';
import 'package:foodship_seller_app/models/order.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';

class PlacedOrderCardEnd extends StatefulWidget {
  final Orders? orders;
  final OrdersList? ordersList;
  final Function? func;
  PlacedOrderCardEnd({
    Key? key,
    this.func,
    this.ordersList,
    this.orders,
  }) : super(key: key);

  @override
  State<PlacedOrderCardEnd> createState() => _PlacedOrderCardEndState();
}

class _PlacedOrderCardEndState extends State<PlacedOrderCardEnd> {
  @override
  Widget build(BuildContext context) {
    final OrdersList ordersList = widget.ordersList!;
    final List<OrdersList> listOrdersList = widget.orders!.ordersList!;
    bool checkLength = false;
    int count = 0;
    for (int i = 0; i < listOrdersList.length; i++) {
      if (listOrdersList[i].status == 'done') {
        count++;
      }
    }
    if (listOrdersList.length - count == 1) {
      checkLength = true;
    }

    final Future<DocumentSnapshot<Object?>> _itemsStream = FirebaseFirestore
        .instance
        .collection('items')
        .doc(ordersList.itemID)
        .get();
    return FutureBuilder<DocumentSnapshot>(
        future: _itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final Items item = Items.fromJson(data);
            return Row(
              children: [
                Image.network(
                  item.thumbnailUrl!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              item.title!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Acme",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            "x ",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ordersList.qty.toString(),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return circularProgress();
        });
  }
}
