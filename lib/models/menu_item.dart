// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../utils/datetime_utils.dart';

class MenuItem {
  final String id;
  final String? menuName;
  final String? route;
  final String? icon;
  final String? parentId;
  final bool? isActive;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  MenuItem({
    required this.id,
    this.menuName,
    this.route,
    this.icon,
    this.parentId,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  MenuItem copyWith({
    String? id,
    String? menuName,
    String? route,
    String? icon,
    String? parentId,
    bool? isActive,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      menuName: menuName ?? this.menuName,
      route: route ?? this.route,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // * Use this method for mongodb
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'menu_name': menuName,
      'route': route,
      'icon': icon,
      'parent_id': parentId,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // * Use this method for sqlite
  Map<String, dynamic> toMapSqlite() {
    return <String, dynamic>{
      '_id': id,
      'menu_name': menuName,
      'route': route,
      'icon': icon,
      'parent_id': parentId,
      'is_active': isActive! ? 1 : 0,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt != null ? DateTimeUtils.dateTimeToString(createdAt!) : null,
      'updated_at': updatedAt != null ? DateTimeUtils.dateTimeToString(updatedAt!) : null,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['_id'] is ObjectId ? map['_id'].toHexString() : map['_id'] ?? '',
      menuName: map['menu_name'] ?? '',
      route: map['route'] ?? '',
      icon: map['icon'] ?? '',
      parentId: map['parent_id'] ?? '',
      isActive: map['is_active'],
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'] ?? '',
      createdAt: map['created_at'] is String ? DateTimeUtils.parseDate(map['created_at']) : map['created_at'],
      updatedAt: map['updated_at'] is String ? DateTimeUtils.parseDate(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItem.fromJson(String source) => MenuItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MenuItem(id: $id, menuName: $menuName, route: $route, icon: $icon, parentId: $parentId, isActive: $isActive, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MenuItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.menuName == menuName &&
        other.route == route &&
        other.icon == icon &&
        other.parentId == parentId &&
        other.isActive == isActive &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        menuName.hashCode ^
        route.hashCode ^
        icon.hashCode ^
        parentId.hashCode ^
        isActive.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
