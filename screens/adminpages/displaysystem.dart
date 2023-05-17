import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/adminpages/orderdetails.dart';
import 'package:just_food/utils/colors.dart';

class DisplaySystem extends StatefulWidget {
  const DisplaySystem({super.key});

  @override
  State<DisplaySystem> createState() => _DisplaySystemState();
}

class _DisplaySystemState extends State<DisplaySystem> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('resid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('status', isEqualTo: "Received")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _playSoundIfNewItemAdded(snapshot.data!.docs);
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Kitchen Display System",
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
                        const SizedBox(height: 1),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.docs.length ?? 0,
                            itemBuilder: (ctx, index) => Container(
                              child: Column(
                                children: [
                                  Material(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Get.to(
                                            OrderDetails(
                                                orderid: snapshot
                                                    .data!.docs[index]
                                                    .data()['orderid']
                                                    .toString()),
                                            transition: Transition.downToUp);
                                      },
                                      child: Container(
                                        decoration: ShapeDecoration(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Order Number:${snapshot.data!.docs[index].data()['ordernumber'].toString()}",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "_____________________________________________",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Table:${snapshot.data!.docs[index].data()['tablename'].toString()}",
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            const SizedBox(height: 15),
                                            Material(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                onTap: () {
                                                  Get.to(
                                                      OrderDetails(
                                                          orderid: snapshot
                                                              .data!.docs[index]
                                                              .data()['orderid']
                                                              .toString()),
                                                      transition:
                                                          Transition.downToUp);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: ShapeDecoration(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                      Radius.circular(15),
                                                    )),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 1,
                                                      horizontal: 10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Current Status: ${snapshot.data!.docs[index].data()['status'].toString()} 🔽",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: blackcolor,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                            addAutomaticKeepAlives: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  int _lastItemCount = 0;
  void _playSoundIfNewItemAdded(List<QueryDocumentSnapshot> items) {
    int itemCount = items.length;

    if (!_isFirstLoad && itemCount > _lastItemCount) {
      flutterTts.speak('New Order Received');
    }
    _isFirstLoad = false;

    _lastItemCount = itemCount;
  }
}
