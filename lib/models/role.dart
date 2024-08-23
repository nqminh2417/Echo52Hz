// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/datetime_utils.dart';

class Role {
  final String? id;
  final String roleCd;
  final String roleName;
  final String? description;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final List<String>? permissions;
  Role({
    this.id,
    required this.roleCd,
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
    String? roleCd,
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
      roleCd: roleCd ?? this.roleCd,
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
      'role_cd': roleCd,
      'role_nm': roleName,
      'descr': description,
      'crt_by': createdBy,
      'crt_dt': createdAt,
      'upd_by': updatedBy,
      'upd_dt': updatedAt,
      'permissions': permissions,
    };
  }

  // * Use this method for sqlite
  Map<String, dynamic> toMapSqlite() {
    return <String, dynamic>{
      '_id': id,
      'role_cd': roleCd,
      'role_nm': roleName,
      'descr': description,
      'crt_by': createdBy,
      'crt_dt': createdAt != null ? DateTimeUtils.dateTimeToString(createdAt!) : null,
      'upd_by': updatedBy,
      'upd_dt': updatedAt != null ? DateTimeUtils.dateTimeToString(updatedAt!) : null,
      'permissions': permissions,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['_id'] is ObjectId ? map['_id'].toHexString() : map['_id'] ?? '',
      roleCd: map['role_cd'] ?? '',
      roleName: map['role_nm'] ?? '',
      description: map['descr'] ?? '',
      createdBy: map['crt_by'] ?? '',
      createdAt: map['crt_dt'] is String ? _parseDate(map['crt_dt']) : map['crt_dt'],
      updatedBy: map['upd_by'] ?? '',
      updatedAt: map['upd_dt'] is String ? _parseDate(map['upd_dt']) : map['upd_dt'],
      permissions: (map['permissions'] as List<dynamic>?)?.cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(String source) => Role.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Role(id: $id, roleCd: $roleCd, roleName: $roleName, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt, permissions: $permissions)';
  }

  @override
  bool operator ==(covariant Role other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.roleCd == roleCd &&
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
        roleCd.hashCode ^
        roleName.hashCode ^
        description.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedBy.hashCode ^
        updatedAt.hashCode ^
        permissions.hashCode;
  }

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      return DateTimeUtils.stringToDateTime(dateString);
    } catch (e) {
      // Handle the error, e.g., log the error or throw a custom exception
      print('Error parsing date: $e');
      return null;
    }
  }
}
