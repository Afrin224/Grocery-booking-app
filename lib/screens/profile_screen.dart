import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/providers/grocery_provider.dart';
import 'package:first_app/screens/chat_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out from FreshMart?'),
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

  void _showSavedAddresses(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Addresses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF2ECC71)),
              title: const Text('Home (Default)'),
              subtitle: const Text('Flat 402, Green Meadows, 5th Main Rd'),
              trailing: const Icon(Icons.check_circle, color: Color(0xFF2ECC71)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.blue),
              title: const Text('Work'),
              subtitle: const Text('Tower B, Tech Park, 3rd Floor'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Methods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: const Text('Cash on Delivery'),
              subtitle: const Text('Pay when your groceries arrive'),
              trailing: const Icon(Icons.check_circle, color: Color(0xFF2ECC71)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.purple),
              title: const Text('UPI / Google Pay / PhonePe'),
              subtitle: const Text('Instant contactless payment'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.amber),
              title: const Text('Credit & Debit Cards'),
              subtitle: const Text('Visa, MasterCard, Rupay'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notification Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: true,
              activeThumbColor: const Color(0xFF2ECC71),
              title: const Text('Order Status & Delivery Updates'),
              subtitle: const Text('Live tracking updates for your grocery deliveries'),
              onChanged: (_) {},
            ),
            SwitchListTile(
              value: true,
              activeThumbColor: const Color(0xFF2ECC71),
              title: const Text('Discounts & Flash Deals'),
              subtitle: const Text('Weekly specials and seasonal grocery offers'),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final provider = GroceryProvider.instance;

    final userEmail = user?.email ?? 'guest@freshmart.com';
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (userEmail.contains('@') ? userEmail.split('@').first : 'Guest');
    final photoUrl = user?.photoURL;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // User Avatar
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1E824C),
                  backgroundImage:
                      photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? Text(
                          userName.isNotEmpty
                              ? userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.verified_user,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          ListenableBuilder(
            listenable: provider,
            builder: (context, _) {
              return Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              '${provider.orders.length}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E824C),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Total Bookings',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Text(
                              '${provider.cartCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E824C),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Cart Items',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Menu Options
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined, color: Colors.green),
                  title: const Text('Saved Addresses'),
                  subtitle: const Text('2 saved addresses'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSavedAddresses(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.credit_card, color: Colors.green),
                  title: const Text('Payment Methods'),
                  subtitle: const Text('Cards, UPI, Cash on Delivery'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPaymentMethods(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: Colors.green),
                  title: const Text('Delivery Notifications'),
                  subtitle: const Text('Order updates & promo alerts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showNotificationSettings(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.headset_mic_outlined, color: Colors.green),
                  title: const Text('Customer Support Chat'),
                  subtitle: const Text('24x7 FreshMart Help Center'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const ChatScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => _confirmSignOut(context),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
