import 'inventory_item.dart';
import 'database_helper.dart';

class SampleData {
  static Future<void> addSampleItems() async {
    final items = [
      InventoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Brake Pads',
        partNumber: 'BP-001',
        brand: 'AutoPro',
        category: 'Brakes',
        quantity: 15,
        price: 49.99,
        location: 'Front Shelf',
        description: 'High-quality brake pads for various car models',
        minimumStock: 5,
        supplier: 'AutoParts Co.',
        compatibleModels: 'Toyota Camry, Honda Civic, Ford Focus',
        isOriginal: true,
        lastRestocked: DateTime.now(),
        unit: 'Pairs',
        condition: 'New',
      ),
      InventoryItem(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        name: 'Engine Oil',
        partNumber: 'EO-002',
        brand: 'LubriMax',
        category: 'Fluids',
        quantity: 8,
        price: 29.99,
        location: 'Oil Storage',
        description: 'Synthetic engine oil 5W-30',
        minimumStock: 10,
        supplier: 'OilDistributors Inc.',
        compatibleModels: 'All Models',
        isOriginal: true,
        lastRestocked: DateTime.now(),
        unit: 'Liters',
        condition: 'New',
      ),
      InventoryItem(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        name: 'Air Filter',
        partNumber: 'AF-003',
        brand: 'CleanAir',
        category: 'Filters',
        quantity: 3,
        price: 19.99,
        location: 'Front Shelf',
        description: 'Replacement air filter for passenger cars',
        minimumStock: 5,
        supplier: 'FilterPro',
        compatibleModels: 'Most Sedans',
        isOriginal: false,
        lastRestocked: DateTime.now(),
        unit: 'Pieces',
        condition: 'New',
      ),
    ];

    for (var item in items) {
      await DatabaseHelper.instance.insert(item);
    }
  }

  // Function to add a single item
  static Future<void> addItem({
    required String name,
    required String partNumber,
    required String brand,
    required String category,
    required int quantity,
    required double price,
    required String location,
    required String description,
    required int minimumStock,
    required String supplier,
    required String compatibleModels,
    required bool isOriginal,
    required String unit,
    required String condition,
  }) async {
    final item = InventoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      partNumber: partNumber,
      brand: brand,
      category: category,
      quantity: quantity,
      price: price,
      location: location,
      description: description,
      minimumStock: minimumStock,
      supplier: supplier,
      compatibleModels: compatibleModels,
      isOriginal: isOriginal,
      lastRestocked: DateTime.now(),
      unit: unit,
      condition: condition,
    );

    await DatabaseHelper.instance.insert(item);
  }
}