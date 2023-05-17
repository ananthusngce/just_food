import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/auth_methods.dart';
import 'package:just_food/screens/auth/forgetpass.dart';
import 'package:just_food/screens/homescreen/adminhome.dart';
import 'package:just_food/screens/homescreen/userhome.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void loginfunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethods().loginUser(
        email: _emailEditingController.text,
        password: _passwordEditingController.text);
    if (res == 'success') {
      setState(() {
        _isLoading = false;
      });
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "User") {
            Get.offAll(
              const UserHome(),
              transition: Transition.downToUp,
            );
          } else {
            Get.offAll(
              const AdminHome(),
              transition: Transition.downToUp,
            );
          }
        } else {
          print('Document does not exist on the database');
        }
      });

      showsnack("Welcome Back",
          "Let food be thy medicine and medicine be thy food", Icons.food_bank);
    } else {
      setState(() {
        _isLoading = false;
      });
      if (res ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        showsnack(
            "Wrong password!",
            "The password is invalid or the user does not have a password.",
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
              image: AssetImage('assets/backgrounds/sadya (2) (1).png'),
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
            /*Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: whiteColor,
              ),
            ),*/
            const SizedBox(height: 65),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Let's Eat",
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
                "Sugar, spice, and everything Here!",
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
                onTap: loginfunction,
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
                          'login',
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
            Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Get.to(
                    const ForgetPass(),
                    transition: Transition.downToUp,
                  );
                },
                child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Forgot password?',
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
