import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodship_seller_app/authentication/register_table.dart';
import 'package:foodship_seller_app/authentication/register_user.dart';
import 'package:foodship_seller_app/global/global.dart';
import 'package:foodship_seller_app/mainScreens/all_table_screen.dart';
import 'package:foodship_seller_app/mainScreens/all_user_screen.dart';
import 'package:foodship_seller_app/mainScreens/block_table_screen.dart';
import 'package:foodship_seller_app/mainScreens/block_user_screen.dart';
import 'package:foodship_seller_app/mainScreens/earning_screen.dart';
import 'package:foodship_seller_app/mainScreens/history_screen.dart';
import 'package:foodship_seller_app/mainScreens/new_order_screen.dart';
import 'package:foodship_seller_app/mainScreens/test_screen.dart';
import 'package:intl/intl.dart';

import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String timeText = "";
  String dateText = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  getCurrentLiveTime() {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentDate(timeNow);

    if (this.mounted) {
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    //time
    timeText = formatCurrentLiveTime(DateTime.now());

    //date
    dateText = formatCurrentDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTime();
    });
  }

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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 25, fontFamily: 'Acme')),
            ]),
          ),
          Center(
            child: Text(
              timeText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              dateText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
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
                  'Trang chủ',
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((c) => const HomeScreen())));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ExpansionTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text('Quản lý tài khoản nhân viên bồi bàn'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.key,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Đăng kí nhân viên bồi bàn',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const RegisterUserScreen())));
                            },
                          ),
                          const Divider(
                            height: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.check,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Nhân viên hiện tại',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const AllVerifiedUsersScreen())));
                            },
                          ),
                          const Divider(
                            height: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Nhân viên hạn chế',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const AllBlockedUsersScreen())));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ExpansionTile(
                leading: const Icon(
                  Icons.table_view,
                  color: Colors.black,
                ),
                title: const Text('Quản lý bàn ăn'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.table_restaurant,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Thêm bàn',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const RegisterTableScreen())));
                            },
                          ),
                          const Divider(
                            height: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.list,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Danh sách bàn ăn',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const AllTableScreen())));
                            },
                          ),
                          const Divider(
                            height: 10,
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            title: const Text(
                              'Bàn hạn chế',
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((c) =>
                                          const AllBlockedTableScreen())));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((c) => const EarningsScreen())));
                },
                leading: const Icon(
                  Icons.monetization_on,
                  color: Colors.black,
                ),
                title: const Text(
                  'Thu nhập',
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
                  'Các đơn hàng hiện tại',
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
                  'Lịch sử đơn hàng',
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
                    'Đăng xuất',
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
              // ListTile(
              //     leading: const Icon(
              //       Icons.logout,
              //       color: Colors.black,
              //     ),
              //     title: const Text(
              //       'Tesst',
              //       style: TextStyle(color: Colors.black),
              //     ),
              //     onTap: () {
              //       firebaseAuth.signOut().then((value) {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: ((c) => MyHomePage(
              //                       title: 'abc',
              //                     ))));
              //       });
              //     }),
            ]),
          )
        ],
      ),
    );
  }
}
