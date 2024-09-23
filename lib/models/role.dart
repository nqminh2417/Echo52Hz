// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/datetime_utils.dart';

class Role {
  final String? id;
  final String roleCode;
  final String roleName;
  final String? description;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final List<String>? permissions;
  Role({
    this.id,
    required this.roleCode,
    required this.roleName,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.permissions,
  });

  Role copyWith({
    String? id,
    String? roleCode,
    String? roleName,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    List<String>? permissions,
  }) {
    return Role(
      id: id ?? this.id,
      roleCode: roleCode ?? this.roleCode,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      permissions: permissions ?? this.permissions,
    );
  }

  // * Use this method for mongodb
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'role_code': roleCode,
      'role_name': roleName,
      'description': description,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'permissions': permissions ?? [],
    };
  }

  // * Use this method for sqlite
  Map<String, dynamic> toMapSqlite() {
    return <String, dynamic>{
      '_id': id,
      'role_code': roleCode,
      'role_name': roleName,
      'description': description,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt != null ? DateTimeUtils.dateTimeToString(createdAt!) : null,
      'updated_at': updatedAt != null ? DateTimeUtils.dateTimeToString(updatedAt!) : null,
      'permissions': jsonEncode(permissions),
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['_id'] is ObjectId ? map['_id'].toHexString() : map['_id'] ?? '',
      roleCode: map['role_code'] ?? '',
      roleName: map['role_name'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['created_by'] ?? '',
      createdAt: map['created_at'] is String ? DateTimeUtils.parseDate(map['created_at']) : map['created_at'],
      updatedBy: map['updated_by'] ?? '',
      updatedAt: map['updated_at'] is String ? DateTimeUtils.parseDate(map['updated_at']) : map['updated_at'],
      permissions: map['permissions'] is String
          ? (jsonDecode(map['permissions']) as List<dynamic>).cast<String>()
          : (map['permissions'] as List<dynamic>).cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) => Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Role(id: $id, roleCode: $roleCode, roleName: $roleName, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt, permissions: $permissions)';
  }

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.roleCode == roleCode &&
        other.roleName == roleName &&
        other.description == description &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedBy == updatedBy &&
        other.updatedAt == updatedAt &&
        listEquals(other.permissions, permissions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        roleCode.hashCode ^
        roleName.hashCode ^
        description.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedBy.hashCode ^
        updatedAt.hashCode ^
        permissions.hashCode;
  }
}
