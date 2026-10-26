import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/grocery_item.dart';
import 'package:first_app/providers/grocery_provider.dart';
import 'package:first_app/screens/cart_screen.dart';
import 'package:first_app/screens/bookings_screen.dart';
import 'package:first_app/screens/my_grocery_list_screen.dart';
import 'package:first_app/screens/profile_screen.dart';

class GroceryHomeScreen extends StatefulWidget {
  const GroceryHomeScreen({super.key});

  @override
  State<GroceryHomeScreen> createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your grocery account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildShopTab(GroceryProvider provider) {
    final filteredItems = provider.filteredItems;

    return Column(
      children: [
        // Search & Filter Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => provider.setSearchQuery(val),
            decoration: InputDecoration(
              hintText: 'Search vegetables, fruits, dairy, meats...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF1E824C)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.setSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Categories Horizontal Pills
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: const Text('All'),
                  selected: provider.selectedCategory == null,
                  selectedColor: const Color(0xFF1E824C),
                  labelStyle: TextStyle(
                    color: provider.selectedCategory == null
                        ? Colors.white
                        : null,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) => provider.setCategoryFilter(null),
                ),
              ),
              ...Categories.values.map((cat) {
                final isSelected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      cat.name[0].toUpperCase() + cat.name.substring(1),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1E824C),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                    onSelected: (_) => provider.setCategoryFilter(cat),
                  ),
                );
              }),
            ],
          ),
        ),

        // Promotional Offer Banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E824C), Color(0xFF2ECC71)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.electric_bolt_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Express 30-Min Delivery!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Free delivery on all grocery bookings over \$30',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Catalog Grid
        Expanded(
          child: filteredItems.isEmpty
              ? const Center(
                  child: Text(
                    'No grocery items match your search.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final qtyInCart = provider.getItemQuantityInCart(item.id);

                    return _buildProductCard(context, provider, item, qtyInCart);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    GroceryProvider provider,
    GroceryItem item,
    int qtyInCart,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grocery Product Image with Category overlay
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: item.category.color.withValues(alpha: 0.12),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: const Color(0xFF1E824C),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    item.icon ?? Icons.eco,
                                    size: 42,
                                    color: item.category.color,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                item.icon ?? Icons.eco,
                                size: 42,
                                color: item.category.color,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category.title,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: item.category.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title & Unit
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              item.unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),

            // Price and Add / Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E824C),
                  ),
                ),
                if (qtyInCart == 0)
                  InkWell(
                    onTap: () => provider.addToCart(item),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E824C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E824C).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => provider.decrementFromCart(item),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: Color(0xFF1E824C),
                            ),
                          ),
                        ),
                        Text(
                          '$qtyInCart',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        InkWell(
                          onTap: () => provider.addToCart(item),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Color(0xFF1E824C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = GroceryProvider.instance;

    final titles = [
      'FreshMart Grocery',
      'Grocery Booking Cart',
      'My Bookings',
      'My Grocery List',
      'My Account',
    ];

    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final cartCount = provider.cartCount;

        final screens = [
          _buildShopTab(provider),
          CartScreen(
            onBrowseCatalog: () => setState(() => _currentIndex = 0),
            onViewBookings: () => setState(() => _currentIndex = 2),
          ),
          const BookingsScreen(),
          const MyGroceryListScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Row(
              children: [
                const Icon(
                  Icons.shopping_cart_checkout,
                  color: Color(0xFF2ECC71),
                ),
                const SizedBox(width: 8),
                Text(
                  titles[_currentIndex],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              // Cart badge icon in top bar
              IconButton(
                tooltip: 'Shopping Cart',
                onPressed: () {
                  setState(() => _currentIndex = 1);
                },
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              // Direct Log Out action button
              IconButton(
                tooltip: 'Log Out',
                onPressed: _showLogoutDialog,
                icon: const Icon(Icons.logout, color: Colors.redAccent),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) {
              setState(() => _currentIndex = idx);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront, color: Color(0xFF1E824C)),
                label: 'Shop',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF1E824C),
                  ),
                ),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: provider.orders.isNotEmpty,
                  label: Text('${provider.orders.length}'),
                  child: const Icon(Icons.local_shipping_outlined),
                ),
                selectedIcon: const Icon(
                  Icons.local_shipping,
                  color: Color(0xFF1E824C),
                ),
                label: 'Bookings',
              ),
              const NavigationDestination(
                icon: Icon(Icons.checklist_rtl_outlined),
                selectedIcon: Icon(
                  Icons.checklist_rtl,
                  color: Color(0xFF1E824C),
                ),
                label: 'My List',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: Color(0xFF1E824C)),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
