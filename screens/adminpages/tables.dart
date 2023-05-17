import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/screens/adminpages/addtable.dart';
import 'package:just_food/screens/adminpages/qrcode.dart';
import 'package:just_food/utils/colors.dart';

class Tables extends StatefulWidget {
  const Tables({super.key});

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _showQrBottomSheet(
      BuildContext context, String tableid, String tablename) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      )),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
        child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: .9,
            minChildSize: 0.4,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: QrCodePage(
                  tableid: tableid,
                  tablename: tablename,
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
                .collection('tables')
                .where('restaurantid', isEqualTo: _auth.currentUser!.uid)
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
                        "TABLES",
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
                                const AddTable(),
                                transition: Transition.downToUp,
                              );
                            },
                            child: Container(
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.all(15),
                                child: const Text(
                                  'add new',
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => Container(
                              child: Column(
                                children: [
                                  Material(
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () => _showQrBottomSheet(
                                        context,
                                        snapshot.data!.docs[index]
                                            .data()['tableid']
                                            .toString(),
                                        snapshot.data!.docs[index]
                                            .data()['tablename']
                                            .toString(),
                                      ),
                                      child: Container(
                                        height: 100,
                                        decoration: ShapeDecoration(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data!.docs[index]
                                                  .data()['tablepic']
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
                                        child: Text(
                                          snapshot.data!.docs[index]
                                              .data()['tablename']
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 45,
                                              color: whiteColor,
                                              fontWeight: FontWeight.w800),
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
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
