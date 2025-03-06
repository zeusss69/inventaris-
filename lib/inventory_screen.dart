import 'package:flutter/material.dart';
import 'inventory_item.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showLowStock = false;
  final _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  List<InventoryItem> _items = [];
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _loadItems();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await DatabaseHelper.instance.getAllItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
      }
    }
  }

  void _showAddEditItemDialog(BuildContext context, {InventoryItem? item}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: item?.name ?? '');
    final partNumberController = TextEditingController(
      text: item?.partNumber ?? '',
    );
    final brandController = TextEditingController(text: item?.brand ?? '');
    final quantityController = TextEditingController(
      text: item?.quantity.toString() ?? '0',
    );
    final priceController = TextEditingController(
      text: item?.price.toString() ?? '0.0',
    );
    final descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    final minimumStockController = TextEditingController(
      text: item?.minimumStock.toString() ?? '0',
    );
    final supplierController = TextEditingController(
      text: item?.supplier ?? '',
    );
    final compatibleModelsController = TextEditingController(
      text: item?.compatibleModels ?? '',
    );

    String selectedCategory = item?.category ?? InventoryItem.categories.first;
    String selectedLocation = item?.location ?? InventoryItem.locations.first;
    String selectedUnit = item?.unit ?? InventoryItem.units.first;
    String selectedCondition =
        item?.condition ?? InventoryItem.conditions.first;
    bool isOriginal = item?.isOriginal ?? false;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: Text(item == null ? 'Add New Item' : 'Edit Item'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name *'),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: partNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Part Number *',
                  ),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: 'Brand *'),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items:
                  InventoryItem.categories
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => selectedCategory = value!,
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity *',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price *'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (double.tryParse(value!) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: const InputDecoration(labelText: 'Location'),
                  items:
                  InventoryItem.locations
                      .map(
                        (location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => selectedLocation = value!,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: minimumStockController,
                  decoration: const InputDecoration(
                    labelText: 'Minimum Stock *',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (int.tryParse(value!) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: supplierController,
                  decoration: const InputDecoration(
                    labelText: 'Supplier *',
                  ),
                  validator:
                      (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: compatibleModelsController,
                  decoration: const InputDecoration(
                    labelText: 'Compatible Models',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                  items:
                  InventoryItem.units
                      .map(
                        (unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => selectedUnit = value!,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCondition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items:
                  InventoryItem.conditions
                      .map(
                        (condition) => DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    ),
                  )
                      .toList(),
                  onChanged: (value) => selectedCondition = value!,
                ),
                CheckboxListTile(
                  title: const Text('Original Part'),
                  value: isOriginal,
                  onChanged: (value) => setState(() => isOriginal = value!),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final newItem = InventoryItem(
                  id:
                  item?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  partNumber: partNumberController.text,
                  brand: brandController.text,
                  category: selectedCategory,
                  quantity: int.parse(quantityController.text),
                  price: double.parse(priceController.text),
                  location: selectedLocation,
                  description: descriptionController.text,
                  minimumStock: int.parse(minimumStockController.text),
                  supplier: supplierController.text,
                  compatibleModels: compatibleModelsController.text,
                  isOriginal: isOriginal,
                  lastRestocked: item?.lastRestocked ?? DateTime.now(),
                  unit: selectedUnit,
                  condition: selectedCondition,
                );

                try {
                  if (item == null) {
                    await DatabaseHelper.instance.insert(newItem);
                  } else {
                    await DatabaseHelper.instance.update(newItem);
                  }

                  Navigator.pop(context);
                  _loadItems();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          item == null
                              ? 'Item added successfully'
                              : 'Item updated successfully',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(item == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left Side Menu
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(
                    right: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory,
                            color: Colors.white.withOpacity(0.9),
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Inventory',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Category List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          _buildCategoryItem('All'),
                          ...InventoryItem.categories.map(_buildCategoryItem),
                          const Divider(color: Colors.white24),
                          _buildCategoryItem('Low Stock', isLowStock: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items in Stock: ${_items.length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddEditItemDialog(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Inventory List
                    Expanded(
                      child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return _buildInventoryCard(item);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category, {bool isLowStock = false}) {
    final isSelected =
    isLowStock ? _showLowStock : _selectedCategory == category;
    return ListTile(
      leading: Icon(
        isLowStock ? Icons.warning : Icons.category,
        color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
      ),
      title: Text(
        category,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.white.withOpacity(0.9),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          if (isLowStock) {
            _showLowStock = !_showLowStock;
            _selectedCategory = 'All';
          } else {
            _selectedCategory = category;
            _showLowStock = false;
          }
        });
      },
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    final isLowStock = item.quantity <= item.minimumStock;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.05),
      child: InkWell(
        onTap: () => _showAddEditItemDialog(context, item: item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Part #: ${item.partNumber}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                      isLowStock
                          ? Colors.red.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${item.quantity} ${item.unit}',
                      style: TextStyle(
                        color: isLowStock ? Colors.red[300] : Colors.green[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currencyFormat.format(item.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    item.category,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<InventoryItem> get _filteredItems {
    return _items.where((item) {
      if (_showLowStock) {
        return item.quantity <= item.minimumStock;
      }
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return item.name.toLowerCase().contains(query) ||
            item.partNumber.toLowerCase().contains(query) ||
            item.brand.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }
}

extension InventoryItemExtension on InventoryItem {
  bool get isLowStock => quantity <= minimumStock;
}
