import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_food/firebase/auth/food_methods.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/imagepicker.dart';
import 'package:just_food/utils/widgets.dart';

class AddDish extends StatefulWidget {
  const AddDish({super.key});

  @override
  State<AddDish> createState() => _AddDishState();
}

class _AddDishState extends State<AddDish> {
  final catid = Get.arguments as String;
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

  void adddishfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Foodmethods().adddish(
        dishname: _dishnameController.text,
        dishpic: _image,
        dishprice: _dishpriceController.text,
        dishdec: _dishdecController.text,
        catid: catid);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      Get.back();
      showsnack("Added!!", "Dish Added successfully!!!", Icons.food_bank);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/sadya2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                const SizedBox(height: 65),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Add Dish!",
                    style: TextStyle(
                      fontSize: 30,
                      color: blackcolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "it becomes a lot more than just about the food.!",
                    style: TextStyle(
                      fontSize: 15,
                      color: darkgrey,
                      fontWeight: FontWeight.w500,
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
                                image: const NetworkImage(
                                    'https://www.asianpaints.com/content/dam/asian_paints/colours/swatches/K127.png.transform/cc-width-720-height-540/image.png'),
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
                    hintText: "dish name",
                    type: TextInputType.text),
                const SizedBox(height: 10),
                TextBox(
                    textEditingController: _dishpriceController,
                    hintText: "dish price",
                    type: TextInputType.number),
                const SizedBox(height: 10),
                TextBox(
                    textEditingController: _dishdecController,
                    hintText: "dish description",
                    type: TextInputType.text),
                const SizedBox(height: 10),
                Material(
                  color: blackcolor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: adddishfunction,
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
                              'add',
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
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
