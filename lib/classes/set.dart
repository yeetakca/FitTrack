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
}
