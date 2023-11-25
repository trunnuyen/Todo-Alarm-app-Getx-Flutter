import 'dart:math';
import 'package:equatable/equatable.dart';

class Alarm extends Equatable {
  late final int id;
  final DateTime time;
  final List<int> weekdays;
  final String title;
  final bool isActive;

  Alarm(
      {int? id,
      required this.time,
      required this.weekdays,
      required this.title,
      required this.isActive}) {
    this.id = id ?? Random.secure().nextInt(10000 - 1000) + 1000;
  }

  Alarm copyWith({
    int? id,
    DateTime? time,
    List<int>? weekdays,
    String? title,
    bool? isActive,
  }) =>
      Alarm(
        id: id ?? this.id,
        time: time ?? this.time,
        weekdays: weekdays != null ? List.from(weekdays) : this.weekdays,
        title: title ?? this.title,
        isActive: isActive ?? this.isActive,
      );

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json['id'],
        time: DateTime.parse(json['time']),
        weekdays: <int>[...json['weekdays']],
        title: json['title'],
        isActive: json['isActive'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time.toIso8601String(),
        'weekdays': weekdays,
        'title': title,
        'isActive': isActive,
      };

  @override
  List<Object?> get props => [id, time, weekdays, title, isActive];
}
