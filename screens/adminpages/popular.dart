import 'dart:convert';
import 'dart:ui';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:just_food/utils/colors.dart';

class PopularScreen extends StatefulWidget {
  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  List<String> _recommendations = [];
  final TextEditingController _dishEditingController = TextEditingController();
  bool _isLoading = false;
  final List<String> _menu = [
    'Kochi',
    'Thiruvananthapuram',
  ];
  GlobalKey<TextFieldAutoCompleteState<String>> _textFieldAutoCompleteKey =
      new GlobalKey();
  @override
  void dispose() {
    super.dispose();
    _dishEditingController.dispose();
  }

  String removeUnwantedChars(String input) {
    // Remove numeric values
    input = input.replaceAll(RegExp(r'\d+|[.\[\]-]+'), '');

    // Remove square brackets and dots
    input = input.replaceAll(RegExp(r'[\[\].]'), '');

    return input;
  }

  /* void _fetchRecommendations() async {
    final response = await http.post(
        Uri.parse('https://itsadamantiumon.pythonanywhere.com/recommendation'),
        body: {'dish_name': 'Sheek Kehab'});

    final csvData = await const CsvToListConverter().convert(response.body);
    String originalString = csvData.toString();
    String modifiedString = removeUnwantedChars(originalString);
    List<String> lines = modifiedString.split('\n');
    lines.removeAt(0);
    String newString = lines.join('\n');
    print(newString);

    setState(() {
      _recommendations = newString.split(",");
    });
  }*/

  void predictcofunction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
        Uri.parse('https://Ananthu151.pythonanywhere.com/recommendation'),
        body: {'place': _dishEditingController.text});
    if (response.body.isNotEmpty) {
      final csvData = await const CsvToListConverter().convert(response.body);
      String originalString = csvData.toString();
      String modifiedString = removeUnwantedChars(originalString);
      List<String> lines = modifiedString.split('\n');
      lines.removeAt(0);
      String newString = lines.join('\n');
      print(newString);

      setState(() {
        _recommendations = newString.split(",");
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showsnack(
          "Error!!", "Something went Wrong!!", Icons.warning_amber_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Popular Dish",
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
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'This is a model that will help us to view what are the most popular dishes in the place',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextFieldAutoComplete(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18),
                      hintText: "Place",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: grey,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    clearOnSubmit: false,
                    controller: _dishEditingController,
                    itemSubmitted: (String item) {
                      _dishEditingController.text = item;
                    },
                    key: _textFieldAutoCompleteKey,
                    suggestions: _menu,
                    itemBuilder: (context, String item) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              item,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      );
                    },
                    itemSorter: (String a, String b) {
                      return a.compareTo(b);
                    },
                    itemFilter: (String item, query) {
                      return item.toLowerCase().startsWith(query.toLowerCase());
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Material(
                color: blackcolor,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: predictcofunction,
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
                            'Find',
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
              const SizedBox(
                height: 10,
              ),
              Flexible(
                  child: _recommendations.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recommendations.length,
                          itemBuilder: (ctx, index) => Container(
                            child: Column(
                              children: [
                                Material(
                                  color: Color.fromARGB(255, 241, 241, 241),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      decoration: ShapeDecoration(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _recommendations[index].trim(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: blackcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Text("No Data to Show!"),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
