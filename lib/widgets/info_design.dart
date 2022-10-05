import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/mainScreens/items_screen.dart';
import 'package:foodship_seller_app/models/items.dart';

import 'package:foodship_seller_app/models/menu.dart';

class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});
  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteMenu(String menuID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(menuID)
        .delete();
    Fluttertoast.showToast(msg: 'Menu Deleted Successfully!!!');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 15),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.model!.menuInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Container(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteMenu(widget.model!.menuID!);
                      },
                      icon: const Icon(
                        Icons.delete_sweep,
                      ),
                      color: Colors.red,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// return InkWell(
//       splashColor: Colors.amber,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           height: 100,
//           width: MediaQuery.of(context).size.width,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Divider(
//                 height: 4,
//                 thickness: 3,
//                 color: Colors.grey[300],
//               ),
//               SizedBox(height: 10),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.model!.itemTitle!,
//                     style: const TextStyle(
//                       color: Colors.cyan,
//                       fontSize: 20,
//                     ),
//                   ),
//                   Text(
//                     widget.model!.itemInfo!,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               Image.network(
//                 widget.model!.thumbnailUrl!,
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(
//                 height: 1.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );