import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/models/address.dart';

import 'package:intl/intl.dart';

import '../widgets/progress_bar.dart';
import '../widgets/shipment_address.dart';
import '../widgets/simple_appbar.dart';
import '../widgets/status_banner.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? orderID;
  OrderDetailScreen({this.orderID});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = '';

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Order Detail'),
      body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.orderID)
                  .get(),
              builder: (c, snapshot) {
                Map? dataMap;
                if (snapshot.hasData) {
                  dataMap = snapshot.data!.data()! as Map<String, dynamic>;
                  orderStatus = dataMap['status'].toString();
                }
                return snapshot.hasData
                    ? Column(
                        children: [
                          StatusBanner(
                            status: dataMap!['isSuccess'],
                            orderStatus: orderStatus,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total :',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text('${dataMap['totalAmount']} VND',
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          Container(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order ID :',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text((dataMap['orderId']).toString(),
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(orderByUser)
                                .collection("userAddress")
                                .doc(dataMap["addressID"])
                                .get(),
                            builder: (c, snapshot) {
                              return snapshot.hasData
                                  ? ShipmentAddressDesign(
                                      model: Address.fromJson(snapshot.data!
                                          .data()! as Map<String, dynamic>),
                                      orderStatus: orderStatus,
                                      sellerId: sellerId,
                                      orderId: widget.orderID,
                                      orderByUser: orderByUser,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      )
                    : Center(child: circularProgress());
              })),
    );
  }
}
