import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/adjust_user_screen.dart';
import 'package:foodship_seller_app/mainScreens/home_screen.dart';
import 'package:foodship_seller_app/models/address.dart';
import 'package:foodship_seller_app/models/user.dart';
import 'package:foodship_seller_app/widgets/loading_dialog.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

class AllBlockedTableScreen extends StatefulWidget {
  const AllBlockedTableScreen({Key? key}) : super(key: key);

  @override
  State<AllBlockedTableScreen> createState() => _AllBlockedTableScreenState();
}

class _AllBlockedTableScreenState extends State<AllBlockedTableScreen> {
  QuerySnapshot? allTables;

  displayDialogBoxForBlockingAccount(userDocumentID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Mở khóa Bàn",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Bạn muốn mở khóa chức năng của bàn này ?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Không"),
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return LoadingDialog(
                          message: ' ',
                        );
                      });
                  Map<String, dynamic> tableDataMap = {
                    "status": "not approved",
                  };
                  for (int i = 0; i < allTables!.size; i++) {
                    final model = Address(
                      name: allTables!.docs[i].get("tableName"),
                      state: '',
                      fullAddress: '',
                      phoneNumber: '',
                      flatNumber: '',
                      city: '',
                      lat: 0.0,
                      lng: 0.0,
                    ).toJson();
                    CollectionReference collectionRef =
                        FirebaseFirestore.instance.collection('users');
                    // Get docs from collection reference
                    QuerySnapshot querySnapshot = await collectionRef.get();

                    // Get data from docs and convert map to List
                    final List<dynamic> allData =
                        querySnapshot.docs.map((doc) => doc.data()).toList();

                    final List<UserModel> users = [];
                    for (final e in allData) {
                      users.add(UserModel.fromJson(e));
                    }
                    for (final UserModel user in users) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.userUID)
                          .collection("userAddress")
                          .doc(allTables!.docs[i].get("tableName"))
                          .set(model);
                    }
                  }
                  Map<String, dynamic> userDataMap = {
                    "status": "approve",
                  };
                  FirebaseFirestore.instance
                      .collection("tables")
                      .doc(userDocumentID)
                      .update(userDataMap)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const HomeScreen()));

                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Mở khóa thành công.",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.cyan,
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: const Text("Có"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("tables")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allTables = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsersDesign() {
      if (allTables != null) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: allTables!.docs.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            child: const Icon(
                              Icons.table_restaurant,
                              color: Colors.black,
                              size: 50,
                            ),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                          ),
                          Text(
                            allTables!.docs[i].get("tableName"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Mở khóa Bàn".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        displayDialogBoxForBlockingAccount(
                            allTables!.docs[i].id);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return circularProgress();
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(
        title: "Danh sách Bàn",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .9,
          child: displayVerifiedUsersDesign(),
        ),
      ),
    );
  }
}
