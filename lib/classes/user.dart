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

  double calculateBMR() {
    if (weightHistory.isEmpty) return 0;
    if (gender == "Male") {
      return 66.47 + (13.75 * weightHistory.last[1]) + (5.003 * height) - (6.755 * age);
    }else if (gender == "Female") {
      return 655.51 + (9.563 * weightHistory.last[1]) + (1.850 * height) - (4.676 * age);
    }else {
      return 0;
    }
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