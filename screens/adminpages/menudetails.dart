import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:just_food/firebase/auth/food_methods.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/imagepicker.dart';
import 'package:just_food/utils/widgets.dart';

class MenuDetails extends StatefulWidget {
  final String catid, catname, catpic;
  const MenuDetails({
    super.key,
    required this.catid,
    required this.catname,
    required this.catpic,
  });

  @override
  State<MenuDetails> createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  final TextEditingController _catnameController = TextEditingController();
  bool _isLoading = false;
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
    _catnameController.dispose();
  }

  void updatecatfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Foodmethods().updatecat(
        catname: _catnameController.text,
        catpic: _image,
        catid: widget.catid,
        catpicstring: widget.catpic);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      Get.back();
      showsnack(
          "Updated!!", "Category Updated successfully!!!", Icons.food_bank);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  @override
  void initState() {
    super.initState();
    _catnameController.text = widget.catname;
  }

  void deletecatfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true

    String res = await Foodmethods().deletecat(catid: widget.catid);
    if (res == "success") {
      //navigate to the home screen
      Get.back();
      showsnack(
          "Deleted!!", "Category Deleted successfully!!!", Icons.food_bank);
    } else {
      // show the error
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -10,
          child: Container(
            width: 60,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                widget.catname,
                style: TextStyle(
                  fontSize: 30,
                  color: blackcolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Material(
              color: const Color.fromARGB(255, 248, 248, 248),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: selectImage,
                child: _image != null
                    ? Container(
                        height: 100,
                        decoration: ShapeDecoration(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                          image: DecorationImage(
                            image: MemoryImage(_image!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.15),
                                BlendMode.darken),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        alignment: Alignment.centerLeft,
                      )
                    : Container(
                        height: 100,
                        decoration: ShapeDecoration(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                          image: DecorationImage(
                            image: NetworkImage(widget.catpic),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.15),
                                BlendMode.darken),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Pick Image',
                          style: TextStyle(
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            TextBox(
                textEditingController: _catnameController,
                hintText: "Category name",
                type: TextInputType.text),
            const SizedBox(height: 10),
            Material(
              color: blackcolor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: updatecatfunction,
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
                  child: !_isLoading
                      ? const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : const SizedBox(
                          height: 16.0,
                          width: 16.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 4,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: deletecatfunction,
                child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: blackcolor,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ],
    );
  }
}
