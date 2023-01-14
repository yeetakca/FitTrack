import 'package:uuid/uuid.dart';

class Set {
  String uuid = const Uuid().v1();
  DateTime date;
  int rep;
  double weight;

  Set({
    required this.date,
    required this.rep,
    required this.weight,
  });

  Set.fromJson(Map<String, dynamic> json)
    : uuid = json['uuid'],
    date = DateTime.fromMillisecondsSinceEpoch(json['date']),
    rep = json['rep'],
    weight = json['weight'];

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'date': date.millisecondsSinceEpoch,
      'rep': rep,
      'weight': weight,
    };
  }
}
