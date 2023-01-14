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
  late List weightList;
  List digitList = [];

  @override
  void initState() {
    super.initState();
    weightList = widget.doneSet.weight.toString().split('.');
    for (int i = 0; i < weightList.length; i++) {
      digitList.add(int.parse(weightList[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      decoration: BoxDecoration(
          color: Colors.blue.shade900, borderRadius: BorderRadius.circular(55)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
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
                onChanged: (value) =>
                    setState(() => widget.doneSet.rep = value),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 25),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 25),
                    itemWidth: 30,
                    value: digitList[0],
                    minValue: 0,
                    maxValue: 500,
                    step: 1,
                    haptics: true,
                    itemCount: 1,
                    onChanged: (value) => setState(() => digitList[0] = value),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    ',',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NumberPicker(
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 25),
                    selectedTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 25),
                    itemWidth: 35,
                    value: digitList[1],
                    minValue: 0,
                    maxValue: 75,
                    step: 25,
                    haptics: true,
                    itemCount: 1,
                    onChanged: (value) => setState(() => digitList[1] = value),
                  ),
                ],
              ),
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
