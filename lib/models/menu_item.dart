// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../utils/datetime_utils.dart';

class MenuItem {
  final String id;
  final String? menuName;
  final String? route;
  final String? icon;
  final bool? isParent;
  final String? parentId;
  final bool? isActive;
  final int? orderId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isExpanded;
  MenuItem({
    required this.id,
    this.menuName,
    this.route,
    this.icon,
    this.isParent,
    this.parentId,
    this.isActive,
    this.orderId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isExpanded = true,
  });

  MenuItem copyWith({
    String? id,
    String? menuName,
    String? route,
    String? icon,
    bool? isParent,
    String? parentId,
    bool? isActive,
    int? orderId,
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
      isParent: isParent ?? this.isParent,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      orderId: orderId ?? this.orderId,
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
      'menuName': menuName,
      'route': route,
      'icon': icon,
      'is_parent': isParent,
      'parent_id': parentId,
      'is_active': isActive,
      'order_id': orderId,
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
      'is_parent': isParent! ? 1 : 0,
      'parent_id': parentId,
      'is_active': isActive! ? 1 : 0,
      'order_id': orderId,
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
      isParent: map['is_parent'] is bool ? map['is_parent'] : ((map['is_parent'] as int) == 1 ? true : false),
      parentId: map['parent_id'] ?? '',
      isActive: map['is_active'] is bool ? map['is_active'] : ((map['is_active'] as int) == 1 ? true : false),
      orderId: map['order_id'] as int?,
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
    return 'MenuItem(_id: $id, menuName: $menuName, route: $route, icon: $icon, isParent: $isParent, parentId: $parentId, isActive: $isActive, orderId: $orderId, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MenuItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.menuName == menuName &&
        other.route == route &&
        other.icon == icon &&
        other.isParent == isParent &&
        other.parentId == parentId &&
        other.isActive == isActive &&
        other.orderId == orderId &&
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
        isParent.hashCode ^
        parentId.hashCode ^
        isActive.hashCode ^
        orderId.hashCode ^
        createdBy.hashCode ^
        updatedBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
