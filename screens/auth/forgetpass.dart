import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/auth_methods.dart';
import 'package:just_food/screens/auth/landing.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
  }

  void forgetpasswordfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    String res =
        await Authmethods().forgetPassword(email: _emailEditingController.text);
    if (res == 'success') {
      setState(() {
        _isLoading = false;
      });
      Get.offAll(
        const LandingPage(),
        transition: Transition.downToUp,
      );
      showsnack("Email Send!", "Password reset link send succusfully!",
          Icons.food_bank);
    } else {
      setState(() {
        _isLoading = false;
      });
      if (res ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        showsnack(
            "No User!",
            "here is no user record corresponding to this identifier. The user may have been deleted.",
            Icons.cake);
      } else if (res ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        showsnack("Bad Email!", "The email address is badly formatted.",
            Icons.icecream_outlined);
      } else {
        showsnack("Error!!", res, Icons.warning_amber_rounded);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/pngs/24a51f2ab9d77aa652965d4698d019f8.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Lost Password?",
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
                      "Not a big deal just enter your email!",
                      style: TextStyle(
                        fontSize: 15,
                        color: darkgrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                      textEditingController: _emailEditingController,
                      hintText: "Email",
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  const SizedBox(height: 15),
                  Material(
                    color: blackcolor,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: forgetpasswordfunction,
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
                                'Reset',
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
                  const SizedBox(height: 5),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
