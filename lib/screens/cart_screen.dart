import 'package:flutter/material.dart';
import 'package:first_app/providers/grocery_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    this.onBrowseCatalog,
    this.onViewBookings,
  });

  final VoidCallback? onBrowseCatalog;
  final VoidCallback? onViewBookings;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _addressController =
      TextEditingController(text: 'Flat 402, Green Meadows, 5th Main Rd');
  String _selectedSlot = 'Today (6:00 PM - 8:00 PM)';
  String _selectedPayment = 'Cash on Delivery';

  final List<String> _slots = [
    'Express Delivery (within 30 mins)',
    'Today (6:00 PM - 8:00 PM)',
    'Tomorrow (8:00 AM - 10:00 AM)',
    'Tomorrow (4:00 PM - 6:00 PM)',
  ];

  final List<String> _paymentMethods = [
    'Cash on Delivery',
    'UPI / Google Pay / PhonePe',
    'Credit / Debit Card',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _confirmBooking(BuildContext context, GroceryProvider provider) {
    if (provider.cartItems.isEmpty) return;

    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a delivery address.')),
      );
      return;
    }

    final order = provider.placeBooking(
      address: _addressController.text.trim(),
      slot: _selectedSlot,
      paymentMethod: _selectedPayment,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 60,
        ),
        title: const Text('Booking Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Scheduled: ${order.deliverySlot}'),
            const SizedBox(height: 4),
            Text('Address: ${order.deliveryAddress}'),
            const SizedBox(height: 4),
            Text(
              'Total: \$${order.totalAmount.toStringAsFixed(2)} (${order.paymentMethod})',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your groceries are being packed and will be delivered on time!',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onBrowseCatalog?.call();
            },
            child: const Text('Continue Shopping'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E824C),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onViewBookings?.call();
            },
            child: const Text('View My Bookings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = GroceryProvider.instance;

    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) {
        final cartItems = provider.cartItems;

        if (cartItems.isEmpty) {
          return Center(
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
                      Icons.shopping_basket_outlined,
                      size: 80,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Cart is Empty',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore our farm-fresh catalog and book your fresh groceries today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  if (widget.onBrowseCatalog != null)
                    ElevatedButton.icon(
                      onPressed: widget.onBrowseCatalog,
                      icon: const Icon(Icons.storefront_rounded),
                      label: const Text('Browse Groceries'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E824C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Cart Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.cartCount} items selected',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: provider.clearCart,
                      icon: const Icon(Icons.delete_sweep, size: 20),
                      label: const Text('Clear Cart'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Cart Items List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final orderItem = cartItems[index];
                    final item = orderItem.item;

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Product Image / avatar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 52,
                                height: 52,
                                color: item.category.color.withValues(alpha: 0.15),
                                child: item.imageUrl != null &&
                                        item.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        item.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Icon(
                                          item.icon ?? Icons.eco,
                                          color: item.category.color,
                                          size: 28,
                                        ),
                                      )
                                    : Icon(
                                        item.icon ?? Icons.eco,
                                        color: item.category.color,
                                        size: 28,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Item details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.unit} • \$${item.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Subtotal: \$${orderItem.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity Stepper
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 22,
                                  ),
                                  color: Colors.grey,
                                  onPressed: () =>
                                      provider.decrementFromCart(item),
                                ),
                                Text(
                                  '${orderItem.count}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    size: 22,
                                    color: Color(0xFF1E824C),
                                  ),
                                  onPressed: () => provider.addToCart(item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Delivery Slot Section
                const Text(
                  'Select Delivery Slot',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSlot,
                        isExpanded: true,
                        icon: const Icon(Icons.schedule, color: Colors.green),
                        items: _slots.map((slot) {
                          return DropdownMenuItem(
                            value: slot,
                            child: Text(slot),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedSlot = val);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Delivery Address Section
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on, color: Colors.green),
                    hintText: 'Enter street address, building, apartment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Method
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPayment,
                        isExpanded: true,
                        icon: const Icon(Icons.payment, color: Colors.green),
                        items: _paymentMethods.map((pm) {
                          return DropdownMenuItem(
                            value: pm,
                            child: Text(pm),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedPayment = val);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bill Summary Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items Subtotal:'),
                            Text('\$${provider.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee:'),
                            Text(
                              provider.deliveryFee == 0
                                  ? 'FREE'
                                  : '\$${provider.deliveryFee.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: provider.deliveryFee == 0
                                    ? Colors.green
                                    : null,
                                fontWeight: provider.deliveryFee == 0
                                    ? FontWeight.bold
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Grand Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${provider.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Booking Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmBooking(context, provider),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text(
                      'Book Groceries Now',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E824C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
