import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_food/firebase/auth/food_methods.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/imagepicker.dart';
import 'package:just_food/utils/widgets.dart';

class DishDetails extends StatefulWidget {
  final String dishid, dishname, dishprice, dishdec, dishpic, catid;
  const DishDetails({
    super.key,
    required this.dishid,
    required this.dishname,
    required this.dishprice,
    required this.dishdec,
    required this.dishpic,
    required this.catid,
  });

  @override
  State<DishDetails> createState() => _DishDetailsState();
}

final catid = Get.arguments as String;

class _DishDetailsState extends State<DishDetails> {
  final TextEditingController _dishnameController = TextEditingController();
  final TextEditingController _dishpriceController = TextEditingController();
  final TextEditingController _dishdecController = TextEditingController();
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
    _dishnameController.dispose();
    _dishpriceController.dispose();
    _dishdecController.dispose();
  }

  void deletedishfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Foodmethods()
        .deletedish(dishid: widget.dishid, catid: widget.catid);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      showsnack("Deleted!!", "Dish Deleted successfully!!!", Icons.food_bank);
      Navigator.pop(context);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  void updatedishfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Foodmethods().updatedish(
        dishname: _dishnameController.text,
        dishid: widget.dishid,
        dishpic: _image,
        dishpicstring: widget.dishpic,
        catid: widget.catid,
        dishprice: _dishpriceController.text,
        dishdec: _dishdecController.text);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      Get.back();
      showsnack("Updated!!", "Dish Updated successfully!!!", Icons.food_bank);
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
    // TODO: implement initState
    super.initState();
    // Step 2 <- SEE HERE
    _dishnameController.text = widget.dishname;
    _dishpriceController.text = widget.dishprice;
    _dishdecController.text = widget.dishdec;
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
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                widget.dishname,
                style: TextStyle(
                  fontSize: 30,
                  color: blackcolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                            image: NetworkImage(widget.dishpic),
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
                textEditingController: _dishnameController,
                hintText: "name",
                type: TextInputType.text),
            const SizedBox(height: 10),
            TextBox(
                textEditingController: _dishpriceController,
                hintText: "dish price",
                type: TextInputType.text),
            const SizedBox(height: 10),
            TextBox(
                textEditingController: _dishdecController,
                hintText: "dish dec",
                type: TextInputType.text),
            const SizedBox(height: 10),
            Material(
              color: blackcolor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: updatedishfunction,
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
                onTap: deletedishfunction,
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
          ]),
        ),
      ],
    );
  }
}
