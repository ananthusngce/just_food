import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/adminpages/adddish.dart';
import 'package:just_food/screens/adminpages/dishdetails.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class Dishes extends StatefulWidget {
  const Dishes({super.key});

  @override
  State<Dishes> createState() => _DishesState();
}

class _DishesState extends State<Dishes> {
  final catid = Get.arguments as String;
  void _showdishdetailsBottomSheet(
    BuildContext context,
    String dishid,
    String dishname,
    String dishprice,
    String dishdec,
    String dishpic,
    String catid,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      )),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom * .7),
        child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: .9,
            minChildSize: 0.4,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: DishDetails(
                  dishid: dishid,
                  dishname: dishname,
                  dishprice: dishprice,
                  dishdec: dishdec,
                  dishpic: dishpic,
                  catid: catid,
                ),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('category')
                .doc(catid)
                .collection('dishes')
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
                    children: const [
                      Text(
                        "DISHES",
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
                    physics: const ScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 1),
                        Material(
                          color: blackcolor,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Get.to(
                                const AddDish(),
                                transition: Transition.downToUp,
                                arguments: catid,
                              );
                            },
                            child: Container(
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.all(15),
                                child: const Text(
                                  'add dish',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                            ),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Material(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onLongPress: () =>
                                          _showdishdetailsBottomSheet(
                                        context,
                                        snapshot.data!.docs[index]
                                            .data()['dishid']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['dishname']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['dishprice']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['dishdec']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['dishpic']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['catid']
                                            .toString(),
                                      ),
                                      onTap: () {
                                        Get.defaultDialog(
                                          radius: 10,
                                          title: snapshot.data!.docs[index]
                                              .data()['dishname']
                                              .toString(),
                                          content: Column(children: [
                                            Container(
                                              height: 200,
                                              decoration: ShapeDecoration(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                  Radius.circular(15),
                                                )),
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data!.docs[index]
                                                      .data()['dishpic']
                                                      .toString()),
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.15),
                                                      BlendMode.darken),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 20),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Rs.${snapshot.data!.docs[index].data()['dishprice'].toString()}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: yellowColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    .data()['dishdec']
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: blackgrey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        );
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: ShapeDecoration(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
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
                                                Colors.black.withOpacity(0.15),
                                                BlendMode.darken),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        alignment: Alignment.centerLeft,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: const ShapeDecoration(
                                      color: Color.fromARGB(31, 184, 184, 184),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]
                                              .data()['dishname']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: blackcolor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "Rs.${snapshot.data!.docs[index].data()['dishprice'].toString()}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: yellowColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
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
            }));
  }
}
