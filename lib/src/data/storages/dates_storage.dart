import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/src/domain/entities/date.dart';

@singleton
class DatesStorage {
  DatesStorage(this.preferences);

  final SharedPreferences preferences;

  final formatter = DateFormat('yyyy-MM-dd');

  Date? getDate(DateTime dateTime) {
    final date = preferences.getString(formatter.format(dateTime));
    return date != null ? Date.fromMap(jsonDecode(date)) : null;
  }

  Future<void> changeDate(Date date) async {
    await preferences.setString(
        formatter.format(date.dateTime!), jsonEncode(date.toMap()));
  }
}
