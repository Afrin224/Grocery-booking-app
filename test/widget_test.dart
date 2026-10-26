import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/screens/splash_screen.dart';
import 'package:first_app/providers/grocery_provider.dart';
import 'package:first_app/data/dummy_items.dart';
import 'package:first_app/models/category.dart';

void main() {
  testWidgets('SplashScreen displays branding and progress indicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('FreshMart Groceries'), findsOneWidget);
  });

  test('GroceryProvider cart and booking management test', () {
    final provider = GroceryProvider.instance;
    provider.clearCart();

    final item1 = groceryItems[0];
    final item2 = groceryItems[1];

    // Add items
    provider.addToCart(item1);
    provider.addToCart(item1);
    provider.addToCart(item2);

    expect(provider.cartCount, 3);
    expect(provider.getItemQuantityInCart(item1.id), 2);
    expect(provider.getItemQuantityInCart(item2.id), 1);

    // Decrement item
    provider.decrementFromCart(item1);
    expect(provider.getItemQuantityInCart(item1.id), 1);
    expect(provider.cartCount, 2);

    // Category filter
    provider.setCategoryFilter(Categories.vegetables);
    expect(provider.selectedCategory, Categories.vegetables);
    for (final item in provider.filteredItems) {
      expect(item.category.title.toLowerCase(), 'vegetables');
    }
    provider.setCategoryFilter(null);

    // Place order
    final initialOrderCount = provider.orders.length;
    final order = provider.placeBooking(
      address: 'Test Address 123',
      slot: 'Today: 6-8 PM',
      paymentMethod: 'Cash on Delivery',
    );

    expect(order.deliveryAddress, 'Test Address 123');
    expect(provider.orders.length, initialOrderCount + 1);
    expect(provider.cartCount, 0); // Cart is cleared after booking
  });
}
