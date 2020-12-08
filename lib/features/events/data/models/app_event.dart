import 'dart:convert';

class AppEvent {
  final String title;
  final String id;
  final String description;
  final DateTime date;
  final String userId;
  final bool public;
  final DateTime endDate;
  AppEvent({
    this.title,
    this.id,
    this.description,
    this.date,
    this.userId,
    this.public,
    this.endDate,
  });

  AppEvent copyWith({
    String title,
    String id,
    String description,
    DateTime date,
    String userId,
    bool public,
    DateTime endDate,
  }) {
    return AppEvent(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      public: public ?? this.public,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date?.millisecondsSinceEpoch,
      'userId': userId,
      'public': public,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }

  factory AppEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AppEvent(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['user_id'],
      public: map['public'],
      endDate: map['end_date'] != null ?  DateTime.fromMillisecondsSinceEpoch(map['end_date']) : null,
    );
  }
  factory AppEvent.fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return AppEvent(
      title: data['title'],
      id: id,
      description: data['description'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['user_id'],
      public: data['public'],
      endDate: data['end_date'] != null ?  DateTime.fromMillisecondsSinceEpoch(data['end_date']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppEvent.fromJson(String source) =>
      AppEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId, public: $public, endDate: $endDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppEvent &&
      o.title == title &&
      o.id == id &&
      o.description == description &&
      o.date == date &&
      o.userId == userId &&
      o.public == public &&
      o.endDate == endDate;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      id.hashCode ^
      description.hashCode ^
      date.hashCode ^
      userId.hashCode ^
      public.hashCode ^
      endDate.hashCode;
  }
}
