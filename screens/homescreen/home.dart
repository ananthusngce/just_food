import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/homescreen/adminhome.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var firebaseData = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Admin") {
          Get.offAll(
            const AdminHome(),
            transition: Transition.downToUp,
          );
        } else {
          Get.offAll(
            const UserHome(),
            transition: Transition.downToUp,
          );
        }
      } else {
        print('Document doesnt exist on the DB');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: blackcolor),
      ),
    );
  }
}
