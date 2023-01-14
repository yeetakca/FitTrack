class Set {
  DateTime date;
  int rep;
  double weight;

  Set({
    required this.date,
    required this.rep,
    required this.weight,
  });

  Set.fromJson(Map<String, dynamic> json)
    : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
    rep = json['rep'],
    weight = json['weight'];

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'rep': rep,
      'weight': weight,
    };
  }
}
