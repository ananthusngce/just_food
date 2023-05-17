import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_food/firebase/auth/food_methods.dart';
import 'package:just_food/utils/colors.dart';
import 'package:just_food/utils/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  final String tableid, tablename;
  const QrCodePage({
    super.key,
    required this.tableid,
    required this.tablename,
  });

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  void deletetablefunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    String res = await Foodmethods().deletetable(tableid: widget.tableid);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      //navigate to the home screen
      Get.back();
      showsnack("Deleted!!", "Table Deleted successfully!!!", Icons.food_bank);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showsnack("Error!!", res, Icons.warning_amber_rounded);
    }
  }

  bool _isLoading = false;
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
                "Name:${widget.tablename}",
                style: const TextStyle(
                  fontSize: 30,
                  color: blackcolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Paste this QR code in table!",
                style: TextStyle(
                  fontSize: 15,
                  color: darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            QrImage(
              data: widget.tableid,
              size: 200,
            ),
            const SizedBox(height: 15),
            Material(
              color: blackcolor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: deletetablefunction,
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
                          'Delete',
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
    );
  }
}
