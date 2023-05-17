import 'dart:convert';
import 'dart:ui';
import 'package:flutter_textfield_autocomplete/flutter_textfield_autocomplete.dart';
import 'package:just_food/theme/color.dart';
import 'package:just_food/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:just_food/utils/colors.dart';

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<String> _recommendations = [];
  final TextEditingController _dishEditingController = TextEditingController();
  bool _isLoading = false;
  final List<String> _menu = [
    'item',
    'Aloo Chaat',
    'Aloo Gobi',
    'Aloo Methi',
    'Baingan Hari Mirch',
    'Bengal Fish Biryani',
    'Bengal Fish Karahi',
    'Bengal Fry Fish',
    'Bengal King Prawn',
    'Bengal Salad',
    'Bhindi Bhajee',
    'Bhuna',
    'Bhuna - Chicken',
    'Bhuna - Chicken Tikka',
    'Bhuna - King Prawn',
    'Bhuna - Lamb',
    'Bhuna - Prawn',
    'Bombay Aloo',
    'Bottle Coke',
    'Bottle Diet Coke',
    'Brinjal Bhajee',
    'Butter Chicken',
    'COBRA ( LARGE )',
    'COBRA (330ML)',
    'COBRA (660ML)',
    'Cauliflower Bhajee',
    'Chana Masala',
    'Chapati',
    'Chicken Achar',
    'Chicken Balti',
    'Chicken Biryani',
    'Chicken Chaat',
    'Chicken Chaat Main',
    'Chicken Chilli Garlic',
    'Chicken Hari Mirch',
    'Chicken Haryali',
    'Chicken Karahi',
    'Chicken Mysore',
    'Chicken Pakora',
    'Chicken Rezala',
    'Chicken Roshni',
    'Chicken Shashlick',
    'Chicken Shashlick Curry',
    'Chicken Sylhet',
    'Chicken Tikka',
    'Chicken Tikka (Main)',
    'Chicken Tikka Balti',
    'Chicken Tikka Biryani',
    'Chicken Tikka Chilli Masala',
    'Chicken Tikka Garlic',
    'Chicken Tikka Jalfrezi',
    'Chicken Tikka Jeera',
    'Chicken Tikka Karahi',
    'Chicken Tikka Masala',
    'Chicken Tikka Pasanda',
    'Chicken Tikka Sizzler',
    'Coke 1.5 ltr',
    'Curry',
    'Curry - Chicken',
    'Curry - Chicken Tikka',
    'Curry - King Prawn',
    'Curry - Lamb',
    'Curry - Prawn',
    'Curry Sauce',
    'Dall Samba',
    'Dhansak',
    'Dhansak - Chicken',
    'Dhansak - Chicken Tikka',
    'Dhansak - King Prawn',
    'Dhansak - Lamb',
    'Dhansak - Prawn',
    'Dhansak Sauce',
    'Diet Coke 1.5 ltr',
    'Dupiaza',
    'Dupiaza - Chicken',
    'Dupiaza - Chicken Tikka',
    'Dupiaza - King Prawn',
    'Dupiaza - Lamb',
    'Dupiaza - Prawn',
    'Egg Paratha',
    'Egg Rice',
    'French Fries',
    'Garlic Naan',
    'Garlic Rice',
    'Green Salad',
    'Hazary Lamb',
    'Hazary Lamb Chilli Garlic',
    'House Red wine 75cl',
    'House white wine 75cl',
    'Keema Naan',
    'Keema Rice',
    'King Prawn Balti',
    'King Prawn Biryani',
    'King Prawn Butterfly',
    'King Prawn Hari Mirch',
    'King Prawn Karahi',
    'King Prawn Puree',
    'King Prawn Shaslick',
    'Korma',
    'Korma - Chicken',
    'Korma - Chicken Tikka',
    'Korma - King Prawn',
    'Korma - Lamb',
    'Korma - Prawn',
    'Korma Sauce',
    'Kulcha Naan',
    'Kurma',
    'Lal Mirch Chicken',
    'Lal Mirch Lamb',
    'Lamb Achar',
    'Lamb Balti',
    "Lamb Biryani",
    "Lamb Chilli Garlic",
    "Lamb Hari Mirch",
    "Lamb Haryali",
    "Lamb Karahi",
    "Lamb Mysore",
    "Lamb Persian",
    "Lamb Rezala",
    "Lamb Roshni",
    "Lamb Shashlick",
    "Lamb Shashlick Curry",
    "Lamb Sylhet",
    "Lamb Tikka",
    "Lamb Tikka (Main)",
    "Lamb Tikka Balti",
    "Lamb Tikka Biryani",
    "Lamb Tikka Chilli Masala",
    "Lamb Tikka Garlic",
    "Lamb Tikka Jalfrezi",
    "Lamb Tikka Jeera",
    "Lamb Tikka Karahi",
    "Lamb Tikka Masala",
    "Lamb Tikka Pasanda",
    "Lamb Tikka Sizzler",
    "Lemon Rice",
    "Lemonade 1.5 ltr",
    "Lime Pickle",
    "Madras",
    "Madras - Chicken",
    "Madras - Chicken Tikka",
    "Madras - King Prawn",
    "Madras - Lamb",
    "Madras - Prawn",
    "Madras Sauce",
    "Mango Chutney",
    "Masala Sauce",
    "Meat Samosa",
    "Methi",
    "Methi - Chicken",
    "Methi - Chicken Tikka",
    "Methi - King Prawn",
    "Methi - Lamb",
    "Methi - Prawn",
    "Mint Sauce",
    "Mixed Starter",
    "Mixed Vegetable Curry",
    "Mushroom",
    "Mushroom - Chicken",
    "Mushroom - Chicken Tikka",
    "Mushroom - King Prawn",
    "Mushroom - Lamb",
    "Mushroom - Prawn",
    "Mushroom Bhajee",
    "Mushroom Rice",
    "Muttar Paneer",
    "Onion Bhajee",
    "Onion Bhaji",
    "Onion Chutney",
    "Onion Naan",
    "Onion Rice",
    "Paneer Shaslick",
    "Paneer Tikka Balti",
    "Paneer Tikka Karahi",
    "Paneer Tikka Masala",
    "Paneer Tikka Sizzler",
    "Paratha",
    "Pathia",
    "Pathia - Chicken",
    "Pathia - Chicken Tikka",
    "Pathia - King Prawn",
    "Pathia - Lamb",
    "Pathia - Prawn",
    "Perrier Water (750ml)",
    "Persian Chicken Biryani",
    "Persian Lamb Biryani",
    "Peshwari Naan",
    "Pilau Rice",
    "Plain Naan",
    "Plain Papadum",
    "Plain Rice",
    "Prawn Balti",
    'Prawn Biryani',
    'Prawn Karahi',
    'Prawn Puree',
    'Prier Water (750ml)',
    'Puree',
    'Raitha',
    'Red Sauce',
    'Rogon',
    'Rogon - Chicken',
    'Rogon - Chicken Tikka',
    'Rogon - King Prawn',
    'Rogon - Lamb',
    'Rogon - Prawn',
    'Royal Paneer',
    'Saag',
    'Saag - Chicken',
    'Saag - Chicken Tikka',
    'Saag - King Prawn',
    'Saag - Lamb',
    'Saag - Prawn',
    'Saag Aloo',
    'Saag Bhajee',
    'Saag Dall',
    'Saag Paneer',
    'Saag Rice',
    'Sheek Kebab',
    'Sheek Kebab (Main)',
    'Sheek Kehab',
    'Special Fried Rice',
    'Spicy Papadum',
    'Still Water (750ml)',
    'Stuffed Paratha',
    'Tandoori Chicken',
    'Tandoori Chicken (1/4)',
    'Tandoori Chicken (Main)',
    'Tandoori Chicken Masala',
    'Tandoori Fish',
    'Tandoori Fish (Main)',
    'Tandoori King Prawn Garlic',
    'Tandoori King Prawn Masala',
    'Tandoori Mixed Grill',
    'Tandoori Roti',
    'Tarka Dall',
    'Vegetable Balti',
    'Vegetable Biryani',
    'Vegetable Karahi',
    'Vegetable Mysore',
    'Vegetable Rice',
    'Vegetable Roll',
    'Vegetable Samosa',
    'Vindaloo',
    'Vindaloo - Chicken',
    'Vindaloo - Chicken Tikka',
    'Vindaloo - King Prawn',
    'Vindaloo - Lamb',
    'Vindaloo - Prawn',
    'Vindaloo Sauce',
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
        Uri.parse('https://itsadamantiumon.pythonanywhere.com/recommendation'),
        body: {'dish_name': _dishEditingController.text});
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
              "Consulting",
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
                  'This is a model that will help us to decide which dishes are bought together,So we can include in our Menu.',
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
                      hintText: "Dish Name",
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
