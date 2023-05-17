import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/adminpages/allorders.dart';
import 'package:just_food/screens/adminpages/consulting.dart';
import 'package:just_food/screens/adminpages/displaysystem.dart';
import 'package:just_food/screens/adminpages/menu.dart';
import 'package:just_food/screens/adminpages/popular.dart';
import 'package:just_food/screens/adminpages/rating.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/colors.dart';
import '../adminpages/tables.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
            Container(
              width: 35,
              height: 35,
              child: const CircleAvatar(
                backgroundColor: whiteColor,
                backgroundImage: NetworkImage(
                    "https://www.shutterstock.com/image-vector/user-icon-vector-260nw-393536320.jpg"),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(const AllOrders(),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              color: whiteColor,
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.play_lesson_outlined,
                                      color: yellowColor,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: yellowColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'All Orders',
                                  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(const Menu(), transition: Transition.downToUp);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [orange, Colors.red],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.1, 0.9],
                              ),
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.menu_book_outlined,
                                      color: whiteColor,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: whiteColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'Menu Manage',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Material(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.to(const DisplaySystem(),
                          transition: Transition.downToUp);
                    },
                    child: Container(
                        height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xFF87CEEB), Color(0xFF1E90FF)],
                            end: Alignment.topLeft,
                            begin: Alignment.bottomRight,
                            stops: [0.1, 0.9],
                          ),
                          shadows: [
                            BoxShadow(
                              color: grey,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.display_settings,
                                  color: whiteColor,
                                  size: 35,
                                ),
                                const Icon(
                                  Icons.more_vert_rounded,
                                  color: whiteColor,
                                  size: 25,
                                )
                              ],
                            ),
                            const Text(
                              'Kitchen Display System',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(RecommendationScreen(),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [Color(0xFF98FF98), Color(0xFF50C878)],
                                begin: Alignment.bottomRight,
                                end: Alignment.topCenter,
                                stops: [0.1, 0.9],
                              ),
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.receipt_long_sharp,
                                      color: whiteColor,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: whiteColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'Dish Recom.',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(const Tables(),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              color: whiteColor,
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.table_restaurant,
                                      color: Colors.deepPurple,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.deepPurple,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'Table Manage',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Material(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Get.to(const RatingPage(),
                          transition: Transition.downToUp);
                    },
                    child: Container(
                        height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 167, 181),
                              Color(0xFF800080)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.9],
                          ),
                          shadows: [
                            BoxShadow(
                              color: grey,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.star_sharp,
                                  color: whiteColor,
                                  size: 35,
                                ),
                                const Icon(
                                  Icons.more_vert_rounded,
                                  color: whiteColor,
                                  size: 25,
                                )
                              ],
                            ),
                            const Text(
                              'Most Rated Dishes list',
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.to(PopularScreen(),
                              transition: Transition.downToUp);
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 234, 255, 44),
                                  Color.fromARGB(255, 255, 206, 71)
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topCenter,
                                stops: [0.1, 0.9],
                              ),
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.list_alt_rounded,
                                      color: whiteColor,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: whiteColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'Popular Dishs',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Material(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: signoutfunction,
                        child: Container(
                            width: MediaQuery.of(context).size.width * .45,
                            height: 150,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              color: whiteColor,
                              shadows: [
                                BoxShadow(
                                  color: grey,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      color: Colors.deepPurple,
                                      size: 35,
                                    ),
                                    const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.deepPurple,
                                      size: 25,
                                    )
                                  ],
                                ),
                                const Text(
                                  'Sign\nOut',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
