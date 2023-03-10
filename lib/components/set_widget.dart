import 'package:fit_track/classes/set.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SetWidget extends StatefulWidget {
  Set doneSet;
  List<Set> doneSets;
  Function updateFunction;

  SetWidget({
    Key? key,
    required this.doneSet,
    required this.doneSets,
    required this.updateFunction,
  }) : super(key: key);

  @override
  State<SetWidget> createState() => _SetWidgetState();
}

class _SetWidgetState extends State<SetWidget> {
  @override
  Widget build(BuildContext context) {
    int val1 = int.parse(widget.doneSet.weight.toString().split('.')[0]);
    int val2 = int.parse(widget.doneSet.weight.toString().split('.')[1]);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      decoration: BoxDecoration(
          color: Colors.blue.shade900, borderRadius: BorderRadius.circular(55)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NumberPicker(
            textStyle: const TextStyle(color: Colors.white, fontSize: 25),
            selectedTextStyle:
                const TextStyle(color: Colors.white, fontSize: 25),
            itemWidth: 70,
            value: widget.doneSet.rep,
            minValue: 0,
            maxValue: 100,
            step: 1,
            haptics: true,
            itemCount: 1,
            onChanged: (value) => setState(() {
              widget.doneSet.rep = value;
              widget.updateFunction();
            }),
          ),
          const Icon(
            Icons.close,
            color: Colors.white,
            size: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberPicker(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 25),
                  selectedTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 25),
                  itemWidth: 30,
                  value: val1,
                  minValue: 0,
                  maxValue: 500,
                  step: 1,
                  haptics: true,
                  itemCount: 1,
                  onChanged: (value) {
                    setState(() {
                      val1 = value;
                      widget.doneSet.weight = double.parse('$val1.$val2');
                      widget.updateFunction();
                    });
                  }),
              const Text(
                ',',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              NumberPicker(
                  textStyle: const TextStyle(color: Colors.white, fontSize: 25),
                  selectedTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 25),
                  itemWidth: 35,
                  value: val2 == 5 ? 50 : val2,
                  minValue: 0,
                  maxValue: 75,
                  step: 25,
                  zeroPad: true,
                  haptics: true,
                  itemCount: 1,
                  onChanged: (value) {
                    setState(() {
                      val2 = value;
                      widget.doneSet.weight = double.parse('$val1.$val2');
                      widget.updateFunction();
                    });
                  }),
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.doneSets.removeWhere(
                  (element) => element.uuid == widget.doneSet.uuid);
              widget.updateFunction();
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
