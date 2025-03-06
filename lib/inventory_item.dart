class InventoryItem {
  final String id;
  final String name;
  final String partNumber;
  final String brand;
  final String category;
  final int quantity;
  final double price;
  final String location;
  final String description;
  final int minimumStock;
  final String supplier;
  final String compatibleModels;
  final bool isOriginal;
  final DateTime lastRestocked;
  final String unit;
  final String condition;
  final String imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.partNumber,
    required this.brand,
    required this.category,
    required this.quantity,
    required this.price,
    required this.location,
    required this.description,
    required this.minimumStock,
    required this.supplier,
    required this.compatibleModels,
    required this.isOriginal,
    required this.lastRestocked,
    required this.unit,
    required this.condition,
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'partNumber': partNumber,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'price': price,
      'location': location,
      'description': description,
      'minimumStock': minimumStock,
      'supplier': supplier,
      'compatibleModels': compatibleModels,
      'isOriginal': isOriginal ? 1 : 0,
      'lastRestocked': lastRestocked.toIso8601String(),
      'unit': unit,
      'condition': condition,
      'imageUrl': imageUrl,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map, String documentId) {
    return InventoryItem(
      id: documentId,
      name: map['name'] ?? '',
      partNumber: map['partNumber'] ?? '',
      brand: map['brand'] ?? '',
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      minimumStock: map['minimumStock'] ?? 0,
      supplier: map['supplier'] ?? '',
      compatibleModels: map['compatibleModels'] ?? '',
      isOriginal: map['isOriginal'] == 1,
      lastRestocked: DateTime.parse(
        map['lastRestocked'] ?? DateTime.now().toIso8601String(),
      ),
      unit: map['unit'] ?? 'pieces',
      condition: map['condition'] ?? 'new',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? partNumber,
    String? brand,
    String? category,
    int? quantity,
    double? price,
    String? location,
    String? description,
    int? minimumStock,
    String? supplier,
    String? compatibleModels,
    bool? isOriginal,
    DateTime? lastRestocked,
    String? unit,
    String? condition,
    String? imageUrl,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      partNumber: partNumber ?? this.partNumber,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      location: location ?? this.location,
      description: description ?? this.description,
      minimumStock: minimumStock ?? this.minimumStock,
      supplier: supplier ?? this.supplier,
      compatibleModels: compatibleModels ?? this.compatibleModels,
      isOriginal: isOriginal ?? this.isOriginal,
      lastRestocked: lastRestocked ?? this.lastRestocked,
      unit: unit ?? this.unit,
      condition: condition ?? this.condition,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  bool get isLowStock => quantity <= minimumStock;

  static List<String> get categories => [
    'Engine Parts',
    'Transmission',
    'Brakes',
    'Suspension',
    'Electrical',
    'Body Parts',
    'Filters',
    'Fluids',
    'Tires',
    'Tools',
    'Other',
  ];

  static List<String> get conditions => [
    'New',
    'Refurbished',
    'Used - Good',
    'Used - Fair',
    'For Repair',
  ];

  static List<String> get units => [
    'Pieces',
    'Pairs',
    'Sets',
    'Liters',
    'Gallons',
    'Meters',
    'Kilograms',
    'Box',
  ];

  static List<String> get locations => [
    'Main Storage',
    'Front Shelf',
    'Back Shelf',
    'Tool Room',
    'Secure Cabinet',
    'Oil Storage',
    'Tire Storage',
    'Workshop',
  ];
}