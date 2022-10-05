import 'package:flutter/material.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/mainScreens/earning_screen.dart';
import 'package:foodship_seller_app/mainScreens/history_screen.dart';
import 'package:foodship_seller_app/mainScreens/new_order_screen.dart';

import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // header drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(children: [
              Material(
                borderRadius: const BorderRadius.all(Radius.circular(90)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString('photoUrl')!)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(sharedPreferences!.getString('name')!,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 25, fontFamily: 'Acme')),
            ]),
          ),
          // body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(children: [
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: const Text(
                  'Home',
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((c) => const HomeScreen())));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((c) => EarningsScreen())));
                },
                leading: Icon(
                  Icons.monetization_on,
                  color: Colors.black,
                ),
                title: Text(
                  'My Earning',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(
                  Icons.post_add_outlined,
                  color: Colors.black,
                ),
                title: const Text(
                  'New Orders',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((c) => const NewOrdersScreen())));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((c) => HistoryScreen())));
                },
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.black,
                ),
                title: const Text(
                  'History Orders',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((c) => const AuthScreen())));
                    });
                  }),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
