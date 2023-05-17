import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/adminpages/orderdetails2.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/colors.dart';

class AllOrdersUser extends StatefulWidget {
  const AllOrdersUser({super.key});

  @override
  State<AllOrdersUser> createState() => _AllOrdersUserState();
}

class _AllOrdersUserState extends State<AllOrdersUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "All Orders",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (ctx, index) => Container(
                              child: Column(
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(15),
                                    color: cardColor,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                            OrderDetails2(
                                                orderid: snapshot
                                                    .data!.docs[index]
                                                    .data()['orderid']
                                                    .toString()),
                                            transition: Transition.downToUp);
                                      },
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Order Number:${snapshot.data!.docs[index].data()['ordernumber'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Date:${snapshot.data!.docs[index].data()['date'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Total Price:${snapshot.data!.docs[index].data()['totalprice'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: secondary,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    "Table:${snapshot.data!.docs[index].data()['tablename'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: blackgrey,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
