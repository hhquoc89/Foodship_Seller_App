import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/item_detail_screen.dart';
import 'package:foodship_seller_app/mainScreens/items_screen.dart';
import 'package:foodship_seller_app/models/items.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});
  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidget();
}

class _ItemsDesignWidget extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
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
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
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