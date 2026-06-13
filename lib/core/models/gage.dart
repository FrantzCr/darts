import 'dart:convert';

class Gage {
  final String id;
  final String text;
  final bool isAdult;
  final String emoji;

  const Gage({
    required this.id,
    required this.text,
    required this.isAdult,
    this.emoji = '🎯',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isAdult': isAdult,
    'emoji': emoji,
  };

  factory Gage.fromJson(Map<String, dynamic> json) => Gage(
    id: json['id'] as String,
    text: json['text'] as String,
    isAdult: json['isAdult'] as bool? ?? false,
    emoji: json['emoji'] as String? ?? '🎯',
  );

  static List<Gage> listFromJsonList(List<String> jsonList) =>
      jsonList.map((s) => Gage.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();

  static List<String> listToJsonList(List<Gage> gages) =>
      gages.map((g) => jsonEncode(g.toJson())).toList();

  Gage copyWith({String? text, bool? isAdult, String? emoji}) => Gage(
    id: id,
    text: text ?? this.text,
    isAdult: isAdult ?? this.isAdult,
    emoji: emoji ?? this.emoji,
  );
}
