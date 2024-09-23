// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MenuSet {
  final String id;
  final String? role_code;
  final List<String>? mItems;
  MenuSet({
    required this.id,
    this.role_code,
    this.mItems,
  });

  MenuSet copyWith({
    String? id,
    String? role_code,
    List<String>? mItems,
  }) {
    return MenuSet(
      id: id ?? this.id,
      role_code: role_code ?? this.role_code,
      mItems: mItems ?? this.mItems,
    );
  }

  // * Use this method for mongodb
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'role_code': role_code,
      'm_items': mItems ?? [],
    };
  }

  // * Use this method for sqlite
  Map<String, dynamic> toMapSqlite() {
    return <String, dynamic>{
      '_id': id,
      'role_code': role_code,
      'm_items': jsonEncode(mItems),
    };
  }

  factory MenuSet.fromMap(Map<String, dynamic> map) {
    return MenuSet(
      id: map['_id'] is ObjectId ? map['_id'].toHexString() : map['_id'] ?? '',
      role_code: map['role_code'] ?? '',
      mItems: map['m_items'] is String
          ? (jsonDecode(map['m_items']) as List<dynamic>).cast<String>()
          : (map['m_items'] as List<dynamic>).cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuSet.fromJson(String source) => MenuSet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MenuSet(id: $id, role_code: $role_code, m_items: $mItems)';

  @override
  bool operator ==(covariant MenuSet other) {
    if (identical(this, other)) return true;

    return other.id == id && other.role_code == role_code && listEquals(other.mItems, mItems);
  }

  @override
  int get hashCode => id.hashCode ^ role_code.hashCode ^ mItems.hashCode;
}
