import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodship_seller_app/mainScreens/adjust_user_screen.dart';
import 'package:foodship_seller_app/mainScreens/home_screen.dart';
import 'package:foodship_seller_app/widgets/progress_bar.dart';
import 'package:foodship_seller_app/widgets/simple_appbar.dart';

class AllBlockedUsersScreen extends StatefulWidget {
  const AllBlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllBlockedUsersScreen> createState() => _AllBlockedUsersScreenState();
}

class _AllBlockedUsersScreenState extends State<AllBlockedUsersScreen> {
  QuerySnapshot? allUsers;

  displayDialogBoxForBlockingAccount(userDocumentID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Kích hoạt tài khoản",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Bạn có muốn kích hoạt tài khoản ?",
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
                onPressed: () {
                  Map<String, dynamic> userDataMap = {
                    "status": "approve",
                  };
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(userDocumentID)
                      .update(userDataMap)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const HomeScreen()));

                    SnackBar snackBar = const SnackBar(
                      content: Text(
                        "Kích hoạt thành công!",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.white,
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
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allUsers = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsersDesign() {
      if (allUsers != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: allUsers!.docs.length,
          itemBuilder: (context, i) {
            String userPhone = allUsers!.docs[i].get('userPhone') ?? 'empty';
            String userIDCard = allUsers!.docs[i].get('userIDCard') ?? 'empty';

            String userAvatarUrl =
                allUsers!.docs[i].get('userAvatarUrl') ?? 'empty';

            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: userAvatarUrl != ''
                          ? Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      allUsers!.docs[i].get("userAvatarUrl")),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Center(
                                  child: Text(allUsers!.docs[i]
                                      .get("userName")
                                      .toString()
                                      .toUpperCase()[0])),
                            ),
                      title: Text(
                        allUsers!.docs[i].get("userName"),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .01,
                              ),
                              Text(
                                allUsers!.docs[i].get("userEmail"),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .01,
                              ),
                              Text(
                                userPhone != '' ? userPhone : 'chưa cập nhật',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.card_membership,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .01,
                              ),
                              Text(
                                userIDCard != '' ? userIDCard : 'chưa cập nhật',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Kích hoạt tài khoản".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        displayDialogBoxForBlockingAccount(
                            allUsers!.docs[i].id);
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
        title: "Danh sách tài khoản",
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
