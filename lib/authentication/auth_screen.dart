import 'package:flutter/material.dart';
import 'package:foodship_seller_app/authentication/login.dart';
import 'package:foodship_seller_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
               colors:  [
                 Colors.cyan,
                 Colors.amber,
               ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "iFood",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Lobster"
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs:[
              Tab(
                icon: Icon(Icons.lock,color: Colors.white,),
                text:"Login",
              ),
              Tab(
                icon: Icon(Icons.person,color: Colors.white,),
                text:"Register",
              ),
            ],
            indicatorColor: Colors.white54,
            indicatorWeight: 3,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
            )
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
