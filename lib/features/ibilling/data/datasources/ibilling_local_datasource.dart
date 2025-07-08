import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ibilling/features/ibilling/data/model/contract_model.dart';

class IBillingLocalDataSource {
  static const String _selectedIndexKey = 'selectedIndex';
  static const String _selectedLangIndex = "selected_lang";
  static const String _savedContractsKey = 'saved_contracts';

  static Future<void> saveSelectedIndex(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedIndexKey, value);
  }

  static Future<int> loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedIndexKey) ?? 0;
  }

  static Future<void> saveSelectedLangIndex(int index)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedLangIndex, index);
  }

  static Future<int> loadSelectedLang()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selected_lang') ?? 2;
  }

  static Future<void> saveContract(ContractModel contract) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_savedContractsKey) ?? [];

    savedList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'] == contract.id;
    });
    savedList.add(jsonEncode(contract.toJson()));
    await prefs.setStringList(_savedContractsKey, savedList);
  }

  static Future<List<ContractModel>> getSavedContracts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_savedContractsKey) ?? [];
    return savedList.map((item) => ContractModel.fromJson(jsonDecode(item) as Map<String, dynamic>)).toList();
  }

  static Future<void> removeSavedContract(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_savedContractsKey) ?? [];
    savedList.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_savedContractsKey, savedList);
  }
}

