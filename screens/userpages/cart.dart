import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/order_and_cart_methods.dart';
import 'package:just_food/screens/userpages/orderplaced.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class Cart extends StatefulWidget {
  String resid, tableid, tablename;
  Cart({
    super.key,
    required this.resid,
    required this.tableid,
    required this.tablename,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0;
  void deletefromcartfunction(String dishid) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String res = await OrderAndCart().deletefromcart(
      dishid: dishid,
    );
    if (res == "success") {
      showsnack(
          "Removed!!", "Dish removed from cart!", Icons.warning_amber_rounded);
    } else {
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  void updatequantityfunction(String dishid) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String res = await OrderAndCart().updatequantity(
      dishid: dishid,
    );
    if (res == "success") {
      showsnack("Incremented!!", "Dish incremented by one!", Icons.cake);
    } else {
      showsnack("Error!!", res, Icons.cake);
    }
  }

  void placeorderfunction(String total, String resid) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (double.parse(total) == 0) {
      showsnack("Cart is Empty", 'Add dishes to cart!', Icons.cake);
    } else {
      String res = await OrderAndCart().placeorder(
          total: total,
          resid: widget.resid,
          tableid: widget.tableid,
          tablename: widget.tablename);
      if (res == "success") {
        showsnack("Order Placed!!", "", Icons.cake);
        Get.to(
            OrderPlaced(
              resid: widget.resid,
            ),
            transition: Transition.downToUp);
      } else {
        showsnack("Error!!", res, Icons.cake);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          color: blackcolor,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => placeorderfunction(total.toString(), widget.resid),
            child: Container(
              width: 200,
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.playlist_add_check,
                    color: whiteColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Place order',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('cart')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('dishes')
                .where('resid', isEqualTo: widget.resid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                total = 0;
                snapshot.data!.docs.forEach((result) {
                  total +=
                      (double.parse(result.data()['dishprice'].toString()) *
                          double.parse(result.data()['quantity'].toString()));
                });
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
                        "Your cart",
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
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Dishes in your cart',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Flexible(
                          child: ListView.builder(
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
                                    child: Row(
                                      children: [
                                        Material(
                                          color: const Color.fromARGB(
                                              255, 248, 248, 248),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () {},
                                            child: Container(
                                              height: 70,
                                              width: 120,
                                              decoration: ShapeDecoration(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    snapshot.data!.docs[index]
                                                        .data()['dishpic']
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.15),
                                                      BlendMode.darken),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1,
                                                      horizontal: 20),
                                              alignment: Alignment.centerLeft,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    .data()['dishname']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Rs. ${snapshot.data!.docs[index].data()['dishprice'].toString()}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: yellowColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Material(
                                          color: yellow,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => updatequantityfunction(
                                              snapshot.data!.docs[index]
                                                  .data()['dishid']
                                                  .toString(),
                                            ),
                                            child: Container(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()['quantity']
                                                    .toString(),
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
                                        const SizedBox(width: 5),
                                        Material(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () => deletefromcartfunction(
                                              snapshot.data!.docs[index]
                                                  .data()['dishid']
                                                  .toString(),
                                            ),
                                            child: Container(
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
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
                                                      vertical: 8,
                                                      horizontal: 10),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  'Total Price',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Rs. ${total.toString()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
