import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NivoraStore extends ChangeNotifier {
  List<String> tips = [];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('nivora_data');
    if (data != null) {
      final json = jsonDecode(data);
      if (json['tips'] != null) {
        tips = List<String>.from(json['tips']);
      }
    }
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final json = {'tips': tips};
    await prefs.setString('nivora_data', jsonEncode(json));
  }
}
