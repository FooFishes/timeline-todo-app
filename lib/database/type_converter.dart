import 'dart:convert';
import 'package:drift/drift.dart';

class ListStringConverter extends TypeConverter<List<String>, String> {
  const ListStringConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    // 解码 JSON 字符串回 List<String>
    final List<dynamic> decoded = json.decode(fromDb) as List<dynamic>;
    return decoded.map((dynamic item) => item.toString()).toList();
  }

  @override
  String toSql(List<String> value) {
    if (value.isEmpty) {
      return '';
    }
    // 将 List<String> 编码为 JSON 字符串
    return json.encode(value);
  }
}