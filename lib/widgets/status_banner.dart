import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;

  StatusBanner({this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "thành công" : message = "Unsuccessful";

    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            orderStatus == "ended"
                ? "Đơn đã làm xong $message"
                : "Đơn đặt $message",
            style: const TextStyle(color: Colors.green),
          ),
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.green,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
