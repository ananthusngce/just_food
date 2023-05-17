import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/auth_methods.dart';
import 'package:just_food/screens/auth/landing.dart';
import 'package:just_food/screens/userpages/allorderuser.dart';
import 'package:just_food/screens/userpages/resturanthomepage.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/data.dart';
import 'package:just_food/utils/widgets.dart';
import 'package:just_food/widgets/category_item.dart';
import 'package:just_food/widgets/custom_textbox.dart';
import 'package:just_food/widgets/feature_item.dart';
import 'package:just_food/widgets/notification_box.dart';
import 'package:just_food/widgets/popular_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

void signoutfunction() {
  Get.offAll(
    const LandingPage(),
    transition: Transition.upToDown,
  );
  Authmethods().signOut();
}

class _UserHomeState extends State<UserHome> {
  void qrfunction() async {
    if (await Permission.camera.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      String? scanresult = await scanner.scan();
      print(scanresult);
      var resData = {};
      var restSnap = await FirebaseFirestore.instance
          .collection('tables')
          .doc(scanresult)
          .get();
      if (scanresult != null) {
        resData = restSnap.data()!;
        String Resid = resData['restaurantid'];
        String tablename = resData['tablename'];
        String tablepic = resData['tablepic'];
        Get.to(ResHome(
            resid: Resid,
            tableid: scanresult,
            tablename: tablename,
            tablepic: tablepic));
      } else {
        showsnack("No QR Scanned!", "Scan a Valide QR Code!.",
            Icons.icecream_outlined);
      }

      print("Location Permission is granted");
    } else {
      print("Location Permission is denied.");
    }
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow < 12) {
      return 'Good Morning';
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Icon(
                  Icons.clear_all_rounded,
                  size: 28,
                ),
              ),
              const Expanded(
                child: Text(
                  "JUST FOOD",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          color: blackcolor,
          borderRadius: BorderRadius.circular(50),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: qrfunction,
            child: Container(
              width: 130,
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.qr_code_scanner,
                    color: whiteColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Scan QR',
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    greetingMessage(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://img.freepik.com/free-photo/top-view-table-full-delicious-food-composition_23-2149141353.jpg",
                          ))),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(fontSize: 14, color: darker),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('rating')
                            .orderBy('overall_rating', descending: true)
                            .limit(4)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                            child: Container(
                                              height: 80,
                                              width: 150,
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
                                                    color: primary,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Orders",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const AllOrdersUser(),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                          child: Text(
                            "See all",
                            style: TextStyle(fontSize: 14, color: darker),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .limit(4)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) => GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowColor.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Order Number:${snapshot.data!.docs[index].data()['ordernumber'].toString()}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                    'Table Name:${snapshot.data!.docs[index].data()['tablename'].toString()}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey)),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                        'Date:${snapshot.data!.docs[index].data()['date'].toString()}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: primary)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                  'Rs.${snapshot.data!.docs[index].data()['totalprice'].toString()}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: primary)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        }),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Material(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: signoutfunction,
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
                        'Sign out',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w900,
                        ),
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
        ));
  }
}
