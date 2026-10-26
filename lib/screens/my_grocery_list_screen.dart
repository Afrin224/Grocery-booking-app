import 'package:flutter/material.dart';
import 'package:first_app/models/grocery_item.dart';
import 'package:first_app/providers/grocery_provider.dart';
import 'package:first_app/widgets/new_item.dart';

class MyGroceryListScreen extends StatelessWidget {
  const MyGroceryListScreen({super.key});

  void _addItem(BuildContext context, GroceryProvider provider) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );

    if (newItem == null) return;
    provider.addCustomItem(newItem);
  }

  @override
  Widget build(BuildContext context) {
    final provider = GroceryProvider.instance;

    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final items = provider.shoppingList;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addItem(context, provider),
            backgroundColor: const Color(0xFF1E824C),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Item'),
          ),
          body: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.checklist_rtl_rounded,
                            size: 80,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your Grocery List is Empty',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create your personal grocery checklist or custom shopping items.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _addItem(context, provider),
                          icon: const Icon(Icons.add),
                          label: const Text('Add First Item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E824C),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        provider.removeCustomItem(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} removed.')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 40,
                              height: 40,
                              color: item.category.color.withValues(alpha: 0.2),
                              child: item.imageUrl != null &&
                                      item.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      item.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Icon(
                                        item.icon ?? Icons.eco,
                                        color: item.category.color,
                                        size: 22,
                                      ),
                                    )
                                  : Icon(
                                      item.icon ?? Icons.eco,
                                      color: item.category.color,
                                      size: 22,
                                    ),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${item.category.title} • Qty: ${item.quantity}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Color(0xFF1E824C),
                            ),
                            tooltip: 'Add to Cart for booking',
                            onPressed: () {
                              provider.addToCart(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item.name} added to cart!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
