import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SetWidget extends StatefulWidget {
  const SetWidget({Key? key}) : super(key: key);

  @override
  State<SetWidget> createState() => _SetWidgetState();
}

class _SetWidgetState extends State<SetWidget> {
  int _currentRepValue = 0;
  int _currentWeightValue1 = 0;
  int _currentWeightValue2 = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            NumberPicker(
              itemWidth: 70,
              value: _currentRepValue,
              minValue: 0,
              maxValue: 100,
              step: 1,
              haptics: true,
              itemCount: 1,
              onChanged: (value) => setState(() => _currentRepValue = value),
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
                  itemWidth: 30,
                  value: _currentWeightValue1,
                  minValue: 0,
                  maxValue: 500,
                  step: 1,
                  haptics: true,
                  itemCount: 1,
                  onChanged: (value) =>
                      setState(() => _currentWeightValue1 = value),
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
                  itemWidth: 35,
                  value: _currentWeightValue2,
                  minValue: 0,
                  maxValue: 75,
                  step: 25,
                  haptics: true,
                  itemCount: 1,
                  onChanged: (value) =>
                      setState(() => _currentWeightValue2 = value),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
