import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/auth_methods.dart';
import 'package:just_food/screens/homescreen/adminhome.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class AdminReg extends StatefulWidget {
  const AdminReg({super.key});

  @override
  State<AdminReg> createState() => _AdminRegState();
}

class _AdminRegState extends State<AdminReg> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _locationEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  String dropdownvalue = 'Cuisine Type';
  // List of items in our dropdown menu
  var items = [
    'Cuisine Type',
    'Multi Cuisine',
    'Indian',
    'Italian',
    'France',
    'Chinese',
    'Arabic',
  ];

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _nameEditingController.dispose();
    _passwordEditingController.dispose();
    _locationEditingController.dispose();
  }

  void signupadminfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().signUpAdmin(
        name: _nameEditingController.text,
        email: _emailEditingController.text,
        password: _passwordEditingController.text,
        location: _locationEditingController.text,
        cuisine: dropdownvalue);
    if (res ==
        "[firebase_auth/invalid-email] The email address is badly formatted.") {
      showsnack("Bad Email!", "The email address is badly formatted.",
          Icons.icecream_outlined);
    }
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      Get.offAll(
        const AdminHome(),
        transition: Transition.downToUp,
      );
      showsnack("Welcome", "Food is our common ground, a universal experience.",
          Icons.food_bank);
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
                    "Let's Cook",
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
                TextBox(
                    textEditingController: _nameEditingController,
                    hintText: "Restaurant name",
                    type: TextInputType.text),
                const SizedBox(height: 10),
                TextBox(
                    textEditingController: _emailEditingController,
                    hintText: "Email",
                    type: TextInputType.emailAddress),
                const SizedBox(height: 10),
                TextBox(
                  textEditingController: _passwordEditingController,
                  hintText: "Password",
                  type: TextInputType.emailAddress,
                  isPass: true,
                ),
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: grey),
                  height: 55,
                  width: double.infinity,
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                TextBox(
                  textEditingController: _locationEditingController,
                  hintText: "Location",
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                Material(
                  color: blackcolor,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: signupadminfunction,
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
                              'Create',
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
