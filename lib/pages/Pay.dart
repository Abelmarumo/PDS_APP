import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
class Box extends StatefulWidget {
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child:CheckboxGroup(
              labels: <String>[
                "Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday",
              ],
              onSelected: (List<String> checked) => print(checked.toString())
          )
      ),
    );
  }
}
