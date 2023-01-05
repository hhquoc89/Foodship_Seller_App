import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:foodship_seller_app/global/global.dart';

import 'package:foodship_seller_app/models/menu.dart';

import 'package:foodship_seller_app/uploadScreens/menu_upload_screen.dart';
import 'package:foodship_seller_app/widgets/info_design.dart';
import 'package:foodship_seller_app/widgets/my_drawer.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const MenuUploadScreen()));
              },
              icon: const Icon(
                Icons.post_add,
                color: Colors.greenAccent,
              ))
        ],
      ),
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.transparent,
            title: Center(
                child: Text(
              'Menu',
              style: TextStyle(color: Colors.black),
            )),
            automaticallyImplyLeading: false,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sharedPreferences!.getString('uid'))
                .collection('menus')
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: GridView.custom(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4, //3
                          pattern: const [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(2, 2), //1,3
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Menus sModel = Menus.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);
                            // design display sellers

                            return InfoDesignWidget(
                              model: sModel,
                              context: context,
                            );
                          },
                          childCount: snapshot.data!.docs.length,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
