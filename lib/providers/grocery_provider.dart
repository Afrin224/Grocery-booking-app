import 'package:flutter/material.dart';
import 'package:first_app/data/dummy_items.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/grocery_item.dart';
import 'package:first_app/models/booking_order.dart';

class GroceryProvider extends ChangeNotifier {
  static final GroceryProvider instance = GroceryProvider._();
  GroceryProvider._() {
    _catalog = List.from(groceryItems);
  }

  late List<GroceryItem> _catalog;
  final Map<String, int> _cart = {}; // itemId -> quantity
  final List<GroceryItem> _customShoppingList = [];
  final List<BookingOrder> _orders = [
    // Pre-populate with an example booking for realistic feel
    BookingOrder(
      id: 'ORD-9821',
      items: [
        OrderItem(item: groceryItems[0], count: 2),
        OrderItem(item: groceryItems[7], count: 1),
      ],
      totalAmount: (groceryItems[0].price * 2) + groceryItems[7].price + 1.99,
      deliveryAddress: '221B Baker Street, Apt 4B',
      deliverySlot: 'Today: 6:00 PM - 8:00 PM',
      paymentMethod: 'Cash on Delivery',
      orderDate: DateTime.now().subtract(const Duration(hours: 3)),
      status: OrderStatus.outForDelivery,
    ),
  ];

  Categories? _selectedCategory;
  String _searchQuery = '';

  // Getters
  List<GroceryItem> get allItems => _catalog;
  Map<String, int> get cart => Map.unmodifiable(_cart);
  List<GroceryItem> get shoppingList => List.unmodifiable(_customShoppingList);
  List<BookingOrder> get orders => List.unmodifiable(_orders);
  Categories? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<GroceryItem> get filteredItems {
    return _catalog.where((item) {
      final matchesCategory = _selectedCategory == null ||
          item.category.title.toLowerCase() ==
              _selectedCategory!.name.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get cartCount {
    int count = 0;
    for (final qty in _cart.values) {
      count += qty;
    }
    return count;
  }

  int getItemQuantityInCart(String itemId) {
    return _cart[itemId] ?? 0;
  }

  List<OrderItem> get cartItems {
    final List<OrderItem> list = [];
    for (final entry in _cart.entries) {
      final item = _catalog.firstWhere(
        (it) => it.id == entry.key,
        orElse: () => _customShoppingList.firstWhere(
          (it) => it.id == entry.key,
          orElse: () => GroceryItem(
            id: entry.key,
            name: 'Item',
            quantity: entry.value,
            category: const Category('Other', Colors.grey),
          ),
        ),
      );
      list.add(OrderItem(item: item, count: entry.value));
    }
    return list;
  }

  double get subtotal {
    double total = 0.0;
    for (final orderItem in cartItems) {
      total += orderItem.totalPrice;
    }
    return total;
  }

  double get deliveryFee {
    if (subtotal == 0 || subtotal >= 30.0) {
      return 0.0;
    }
    return 1.99;
  }

  double get grandTotal => subtotal + deliveryFee;

  // Actions
  void setCategoryFilter(Categories? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToCart(GroceryItem item) {
    _cart[item.id] = (_cart[item.id] ?? 0) + 1;
    notifyListeners();
  }

  void decrementFromCart(GroceryItem item) {
    if (!_cart.containsKey(item.id)) return;
    if (_cart[item.id]! <= 1) {
      _cart.remove(item.id);
    } else {
      _cart[item.id] = _cart[item.id]! - 1;
    }
    notifyListeners();
  }

  void removeFromCart(GroceryItem item) {
    _cart.remove(item.id);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void addCustomItem(GroceryItem item) {
    _customShoppingList.add(item);
    notifyListeners();
  }

  void removeCustomItem(GroceryItem item) {
    _customShoppingList.removeWhere((it) => it.id == item.id);
    notifyListeners();
  }

  BookingOrder placeBooking({
    required String address,
    required String slot,
    required String paymentMethod,
  }) {
    final newOrder = BookingOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(cartItems),
      totalAmount: grandTotal,
      deliveryAddress: address,
      deliverySlot: slot,
      paymentMethod: paymentMethod,
      orderDate: DateTime.now(),
      status: OrderStatus.confirmed,
    );

    _orders.insert(0, newOrder);
    _cart.clear();
    notifyListeners();
    return newOrder;
  }
}
