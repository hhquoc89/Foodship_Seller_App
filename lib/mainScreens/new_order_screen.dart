import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/models/order.dart';
import 'package:foodship_seller_app/respository/assitant_method.dart';
import 'package:foodship_seller_app/widgets/order_card_new.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

import '../widgets/order_card.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({Key? key}) : super(key: key);

  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Các đơn hiện tại",
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("status", isEqualTo: "normal")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("orders")
                            .where('ordersList')
                            .get(),
                        builder: (c, snap) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          final orders = Orders.fromJson(data);
                          return snap.hasData
                              ? OrderCardNew(
                                  orders: orders,
                                )
                              : Center(child: circularProgress());
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
