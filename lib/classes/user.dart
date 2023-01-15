import 'dart:convert';

class User {
  String name;
  List weightHistory = [];
  int height;
  int age;
  String gender;

  User({
    required this.name,
    required this.height,
    required this.age,
    required this.gender,
  });

  void updateWeight(double weight) {
    weightHistory.add([DateTime.now().millisecondsSinceEpoch, weight]);
  }

  User.fromJson(Map<String, dynamic> json)
    : name = json['name'],
    weightHistory = jsonDecode(json['weightHistory']),
    height = json['height'],
    age = json['age'],
    gender = json['gender'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weightHistory': weightHistory.toString(),
      'height': height,
      'age': age,
      'gender': gender,
    };
  }
}