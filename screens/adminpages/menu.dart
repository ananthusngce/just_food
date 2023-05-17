import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_food/screens/adminpages/addcat.dart';
import 'package:just_food/screens/adminpages/dishes.dart';
import 'package:just_food/screens/adminpages/menudetails.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/imagepicker.dart';
import 'package:just_food/utils/widgets.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _isLoading = false;

  final TextEditingController _categoryname = TextEditingController();
  Uint8List? _image;
  selectImage() async {
    try {
      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        _image = im;
      });
    } catch (error) {
      showsnack(
          "Error!!", 'Not able to an pick image.', Icons.warning_amber_rounded);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _categoryname.dispose();
  }

  void _showmenudetailsBottomSheet(
      BuildContext context, String catid, String catname, String catpic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      )),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom * 0.56),
        child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child:
                    MenuDetails(catid: catid, catname: catname, catpic: catpic),
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
                        "CATEGORIES",
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
                                const AddCat(),
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
                                      onTap: () {
                                        Get.to(
                                          const Dishes(),
                                          arguments: snapshot.data!.docs[index]
                                              .data()['catid']
                                              .toString(),
                                          transition: Transition.downToUp,
                                        );
                                      },
                                      onLongPress: () =>
                                          _showmenudetailsBottomSheet(
                                              context,
                                              snapshot.data!.docs[index]
                                                  .data()['catid']
                                                  .toString(),
                                              snapshot.data!.docs[index]
                                                  .data()['catname']
                                                  .toString(),
                                              snapshot.data!.docs[index]
                                                  .data()['catpic']
                                                  .toString()),
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
                                            vertical: 20, horizontal: 20),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          snapshot.data!.docs[index]
                                              .data()['catname']
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
