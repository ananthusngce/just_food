import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/order_and_cart_methods.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class OrderPlaced extends StatefulWidget {
  String resid;
  OrderPlaced({super.key, required this.resid});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  void ratedishfunction(String rating, String dishid, String dishname,
      String dishpic, String dishprice) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String res = await OrderAndCart().ratedish(
      dishid: dishid,
      rating: rating,
      dishname: dishname,
      dishpic: dishpic,
      dishprice: dishprice,
    );
    if (res == "success") {
    } else {
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "JUST FOOD",
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Icon(
                        Icons.check_circle_outline,
                        color: whiteColor,
                        size: 80.0,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Your order has been received!',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        "Thank you Let's Eat Together",
                        style: TextStyle(fontSize: 16.0, color: whiteColor),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  decoration: const ShapeDecoration(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "____________________________________",
                    style: TextStyle(
                      fontSize: 14,
                      color: blackcolor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Please Consider rating our dishes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('cart')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('dishes')
                        .where('resid', isEqualTo: widget.resid)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: const ShapeDecoration(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  )),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            .data()['dishname']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      height: 40,
                                      decoration: ShapeDecoration(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data!.docs[index]
                                                .data()['dishpic']
                                                .toString(),
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.30),
                                              BlendMode.darken),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 20),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Material(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => ratedishfunction(
                                                '1',
                                                snapshot.data!.docs[index]
                                                    .data()['dishid']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishpic']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishprice']
                                                    .toString()),
                                            child: Container(
                                              child: Text(
                                                "1",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Material(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => ratedishfunction(
                                                '2',
                                                snapshot.data!.docs[index]
                                                    .data()['dishid']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishpic']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishprice']
                                                    .toString()),
                                            child: Container(
                                              child: Text(
                                                "2",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Material(
                                          color: yellow,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => ratedishfunction(
                                                '3',
                                                snapshot.data!.docs[index]
                                                    .data()['dishid']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishpic']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishprice']
                                                    .toString()),
                                            child: Container(
                                              child: Text(
                                                "3",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Material(
                                          color: Colors.lightGreen,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => ratedishfunction(
                                                '4',
                                                snapshot.data!.docs[index]
                                                    .data()['dishid']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishpic']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishprice']
                                                    .toString()),
                                            child: Container(
                                              child: Text(
                                                "4",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Material(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => ratedishfunction(
                                                '5',
                                                snapshot.data!.docs[index]
                                                    .data()['dishid']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishpic']
                                                    .toString(),
                                                snapshot.data!.docs[index]
                                                    .data()['dishprice']
                                                    .toString()),
                                            child: Container(
                                              child: Text(
                                                '5',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              decoration: const ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 15),
                Material(
                  color: blackcolor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.offAll(UserHome());
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
