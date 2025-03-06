import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'inventory_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static SharedPreferences? _prefs;
  static const String _key = 'inventory_items';

  DatabaseHelper._init();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String> insert(InventoryItem item) async {
    final items = await getAllItems();
    items.add(item);
    await _saveItems(items);
    return item.id;
  }

  Future<InventoryItem?> getItem(String id) async {
    final items = await getAllItems();
    return items.firstWhere((item) => item.id == id);
  }

  Future<List<InventoryItem>> getAllItems() async {
    final prefs = await this.prefs;
    final String? itemsJson = prefs.getString(_key);
    if (itemsJson == null) return [];

    final List<dynamic> itemsList = json.decode(itemsJson);
    return itemsList.map((json) => InventoryItem.fromMap(json, json['id'])).toList();
  }

  Future<List<InventoryItem>> getItemsByCategory(String category) async {
    final items = await getAllItems();
    return items.where((item) => item.category == category).toList();
  }

  Future<List<InventoryItem>> getLowStockItems() async {
    final items = await getAllItems();
    return items.where((item) => item.quantity <= item.minimumStock).toList();
  }

  Future<int> update(InventoryItem item) async {
    final items = await getAllItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItems(items);
      return 1;
    }
    return 0;
  }

  Future<int> delete(String id) async {
    final items = await getAllItems();
    items.removeWhere((item) => item.id == id);
    await _saveItems(items);
    return 1;
  }

  Future<List<InventoryItem>> searchItems(String query) async {
    final items = await getAllItems();
    final lowercaseQuery = query.toLowerCase();
    return items.where((item) =>
    item.name.toLowerCase().contains(lowercaseQuery) ||
        item.partNumber.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  Future<void> _saveItems(List<InventoryItem> items) async {
    final prefs = await this.prefs;
    final itemsJson = items.map((item) => item.toMap()).toList();
    await prefs.setString(_key, json.encode(itemsJson));
  }
}