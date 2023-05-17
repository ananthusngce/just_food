import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/order_and_cart_methods.dart';
import 'package:just_food/screens/adminpages/dishes.dart';
import 'package:just_food/screens/userpages/cart.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class ResHome extends StatefulWidget {
  final String resid, tableid, tablename, tablepic;
  const ResHome({
    super.key,
    required this.resid,
    required this.tableid,
    required this.tablename,
    required this.tablepic,
  });

  @override
  State<ResHome> createState() => _ResHomeState();
}

class _ResHomeState extends State<ResHome> {
  void addtocartfunction(
      String dishid, String dishname, String dishprice, String dishpic) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String res = await OrderAndCart().addtocart(
        dishid: dishid,
        dishname: dishname,
        dishprice: dishprice,
        resid: widget.resid,
        dishpic: dishpic);
    if (res == "success") {
      Get.snackbar("Added", "Dish added to cart!!",
          colorText: blackcolor,
          backgroundColor: whiteColor,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          borderRadius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          mainButton: TextButton(
              onPressed: () => {
                    Get.to(
                        Cart(
                          resid: widget.resid,
                          tableid: widget.tableid,
                          tablename: widget.tablename,
                        ),
                        transition: Transition.downToUp),
                  },
              child: const Icon(
                Icons.shopping_cart_sharp,
                color: blackcolor,
              )));
    } else {
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  Future<bool> _onPop() async {
    return (await Get.defaultDialog(
          radius: 10,
          title: "Going back ?",
          content: Column(children: [
            const Text(
              "You will have to scan QR code again!",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: blackcolor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).pop(true);
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
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: grey,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).pop(false);
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
                      'No',
                      style: TextStyle(
                        color: blackcolor,
                        fontWeight: FontWeight.w900,
                      ),
                    )),
              ),
            ),
          ]),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('restaurants')
              .doc(widget.resid)
              .collection('category')
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
                    const Expanded(
                      child: Text(
                        "JUST FOOD",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(
                              Cart(
                                resid: widget.resid,
                                tableid: widget.tableid,
                                tablename: widget.tablename,
                              ),
                              transition: Transition.downToUp);
                        },
                        child: const Icon(Icons.shopping_cart_sharp))
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
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'to our restaurant,you are in',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(15), // Image border
                            child: SizedBox.fromSize(
                              // Image radius
                              child:
                                  Image(image: NetworkImage(widget.tablepic)),
                            ),
                          ),
                          Container(
                            height: 50,
                            alignment: Alignment.bottomLeft,
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topCenter,
                                stops: [
                                  0.4,
                                  0.8,
                                  1,
                                ],
                                colors: [
                                  Colors.black,
                                  Colors.black12,
                                  Colors.transparent
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Table: ',
                                      style: TextStyle(
                                        color: greydark,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget.tablename,
                                      style: const TextStyle(
                                        color: whiteColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          )
                        ],
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
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Explore our menu here!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Container(
                            child: Column(
                              children: [
                                Material(
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {},
                                    child: Container(
                                      height: 60,
                                      decoration: ShapeDecoration(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data!.docs[index]
                                                .data()['catpic']
                                                .toString(),
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.15),
                                              BlendMode.darken),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 20),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            .data()['catname']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 30,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('restaurants')
                                        .doc(widget.resid)
                                        .collection('category')
                                        .doc(
                                          snapshot.data!.docs[index]
                                              .data()['catid']
                                              .toString(),
                                        )
                                        .collection('dishes')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (ctx, index) => Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Color.fromARGB(
                                                      255, 243, 243, 243),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                    Radius.circular(15),
                                                  )),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Material(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              248,
                                                              248,
                                                              248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        onTap: () {
                                                          Get.defaultDialog(
                                                            radius: 10,
                                                            title: snapshot
                                                                .data!
                                                                .docs[index]
                                                                .data()[
                                                                    'dishname']
                                                                .toString(),
                                                            content: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 200,
                                                                    decoration:
                                                                        ShapeDecoration(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            15),
                                                                      )),
                                                                      image:
                                                                          DecorationImage(
                                                                        image: NetworkImage(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()['dishpic']
                                                                            .toString()),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        colorFilter: ColorFilter.mode(
                                                                            Colors.black.withOpacity(0.15),
                                                                            BlendMode.darken),
                                                                      ),
                                                                    ),
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            20,
                                                                        horizontal:
                                                                            20),
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      'Rs.${snapshot.data!.docs[index].data()['dishprice'].toString()}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color:
                                                                            yellowColor,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              'dishdec']
                                                                          .toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color:
                                                                            blackgrey,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Material(
                                                                    color:
                                                                        blackcolor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    child:
                                                                        InkWell(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      onTap: () =>
                                                                          addtocartfunction(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()['dishid']
                                                                            .toString(),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()['dishname']
                                                                            .toString(),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()['dishprice']
                                                                            .toString(),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()['dishpic']
                                                                            .toString(),
                                                                      ),
                                                                      child: Container(
                                                                          alignment: Alignment.center,
                                                                          padding: const EdgeInsets.all(15),
                                                                          decoration: const ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(50),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child: const Text(
                                                                            'add to cart',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w900,
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 80,
                                                          width: 150,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                              Radius.circular(
                                                                  15),
                                                            )),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                        'dishpic']
                                                                    .toString(),
                                                              ),
                                                              fit: BoxFit.cover,
                                                              colorFilter: ColorFilter.mode(
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.15),
                                                                  BlendMode
                                                                      .darken),
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      20),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data!
                                                                .docs[index]
                                                                .data()[
                                                                    'dishname']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            "Rs. ${snapshot.data!.docs[index].data()['dishprice'].toString()}",
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    yellowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Material(
                                                      color: darkgrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        onTap: () =>
                                                            addtocartfunction(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()['dishid']
                                                              .toString(),
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()[
                                                                  'dishname']
                                                              .toString(),
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()[
                                                                  'dishprice']
                                                              .toString(),
                                                          snapshot
                                                              .data!.docs[index]
                                                              .data()['dishpic']
                                                              .toString(),
                                                        ),
                                                        child: Container(
                                                          child: Text(
                                                            "+",
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                color:
                                                                    whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          decoration:
                                                              const ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                              Radius.circular(
                                                                  15),
                                                            )),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      15),
                                                          alignment:
                                                              Alignment.center,
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
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
