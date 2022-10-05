import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  String? title;
  SimpleAppBar({Key? key, this.bottom, this.title}) : super(key: key);
  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
      ),
      title: Text(
        title!,
        style: const TextStyle(fontFamily: 'Signatra', fontSize: 30),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
