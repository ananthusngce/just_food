import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/auth_methods.dart';
import 'package:just_food/screens/auth/adminreg.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/utils/widgets.dart';

import '../../utils/colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _nameEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void signupfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().signUpUser(
      username: _nameEditingController.text,
      email: _emailEditingController.text,
      password: _passwordEditingController.text,
    );
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
        const UserHome(),
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
    return Stack(
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
                "Let's Start",
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
                "My weaknesses have always been food!",
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
                hintText: "Name",
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
            Material(
              color: blackcolor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: signupfunction,
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
            Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Get.to(
                    const AdminReg(),
                    transition: Transition.downToUp,
                  );
                },
                child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Register as a Restaurant',
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
