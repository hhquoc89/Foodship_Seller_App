import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/order_detail_screen.dart';
import 'package:foodship_seller_app/models/items.dart';

class OrderCard extends StatefulWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;

  OrderCard({
    this.itemCount,
    this.data,
    this.orderID,
    this.seperateQuantitiesList,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(
                orderID: widget.orderID,
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
        height: widget.itemCount! * 125,
        child: ListView.builder(
          itemCount: widget.itemCount,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final seperateQuantitiesList =
                widget.seperateQuantitiesList ?? [''];
            Items model = Items.fromJson(
                widget.data![index].data()! as Map<String, dynamic>);

            return placedOrderDesignWidget(
                model, context, seperateQuantitiesList[index]);
          },
        ),
      ),
    );
  }
}

Widget placedOrderDesignWidget(
  Items model,
  BuildContext context,
  seperateQuantitiesList,
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title!,
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
                      seperateQuantitiesList,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 30,
                        fontFamily: "Acme",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
