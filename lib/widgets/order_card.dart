import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/order_detail_screen.dart';
import 'package:foodship_seller_app/models/items.dart';
import 'package:foodship_seller_app/models/order.dart';
import 'package:foodship_seller_app/widgets/placed_order_end.dart';

class OrderCard extends StatefulWidget {
  final Orders? orders;

  OrderCard({
    Key? key,
    this.orders,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
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
          )),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: widget.orders!.ordersList!.length * 130,
          width: MediaQuery.of(context).size.width * .9,
          child: ListView.separated(
            itemCount: widget.orders!.ordersList!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final listOrdersList = widget.orders!.ordersList ?? [];

              final OrdersList ordersList = listOrdersList[index];

              return PlacedOrderCardEnd(
                orders: widget.orders,
                ordersList: ordersList,
                func: () {},
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: MediaQuery.of(context).size.height * .01);
            },
          ),
        ),
      ),
    );
  }
}
