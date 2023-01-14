import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SetWidget extends StatefulWidget {
  int rep;
  double weight;

  SetWidget({Key? key, required this.rep, required this.weight})
      : super(key: key);

  @override
  State<SetWidget> createState() => _SetWidgetState();
}

class _SetWidgetState extends State<SetWidget> {
  // int _currentRepValue = widget.rep;
  // int _currentWeightValue1 = widget.weight;
  // int _currentWeightValue2 = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(55)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              NumberPicker(
                selectedTextStyle:
                    TextStyle(color: Colors.blue.shade700, fontSize: 25),
                itemWidth: 70,
                value: widget.rep,
                minValue: 0,
                maxValue: 100,
                step: 1,
                haptics: true,
                itemCount: 1,
                onChanged: (value) => setState(() => widget.rep = value),
              ),
            ],
          ),
          Column(
            children: const [
              Icon(
                Icons.close,
                color: Colors.black,
                size: 30.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  NumberPicker(
                    selectedTextStyle:
                        TextStyle(color: Colors.blue.shade700, fontSize: 25),
                    itemWidth: 30,
                    value: widget.weight.floor(), // ------------
                    minValue: 0,
                    maxValue: 500,
                    step: 1,
                    haptics: true,
                    itemCount: 1,
                    onChanged: (value) => setState(() => widget.weight = value as double), // -----------
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    ',',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ],
              ),
              Column(
                children: [
                  NumberPicker(
                    selectedTextStyle:
                        TextStyle(color: Colors.blue.shade700, fontSize: 25),
                    itemWidth: 35,
                    value: widget.weight.floor(), // -----------
                    minValue: 0,
                    maxValue: 75,
                    step: 25,
                    haptics: true,
                    itemCount: 1,
                    onChanged: (value) => setState(() => widget.weight = value as double), // ---------------
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
