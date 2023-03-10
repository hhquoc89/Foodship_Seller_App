import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/order_detail_screen.dart';
import 'package:foodship_seller_app/mainScreens/placed_order_screen.dart';
import 'package:foodship_seller_app/models/order.dart';

class OrderCardNew extends StatefulWidget {
  final Orders? orders;

  const OrderCardNew({
    Key? key,
    this.orders,
  }) : super(key: key);

  @override
  State<OrderCardNew> createState() => _OrderCardNewState();
}

class _OrderCardNewState extends State<OrderCardNew> {
  late Timer timer;

  String orderStatus = "";

  String sellerId = '';
  String orderTotalAmount = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(
                      orderID: widget.orders!.orderId,
                    ),
                  ));
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
                    Colors.white54,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              height: widget.orders!.ordersList!.length * 130,
              width: MediaQuery.of(context).size.width * .8,
              child: ListView.separated(
                itemCount: widget.orders!.ordersList!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final listOrdersList = widget.orders!.ordersList ?? [];

                  final OrdersList ordersList = listOrdersList[index];

                  return PlacedOrderCard(
                    orders: widget.orders,
                    ordersList: ordersList,
                    func: () {},
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * .01);
                },
              ),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * .1,
          //   height: MediaQuery.of(context).size.height * .11,
          //   child: FittedBox(
          //       child: FloatingActionButton.extended(
          //     backgroundColor: Colors.amber,
          //     label: Text('Xong đơn'),
          //     icon: const Icon(Icons.done),
          //     heroTag: null,
          //     onPressed: () {
          //       confirmParcelHasBeenMaking(
          //           widget.orderID, sellerId, orderByUser, '', 0.0, 0.0);
          //     },
          //   )),
          // )
        ],
      ),
    );
  }
}
