import 'package:flutter/material.dart';
import 'package:first_app/data/categories.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/grocery_item.dart';

final groceryItems = [
  // Vegetables
  GroceryItem(
    id: 'veg_1',
    name: 'Fresh Organic Tomatoes',
    quantity: 1,
    category: categories[Categories.vegetables]!,
    price: 1.99,
    unit: '1 kg',
    description: 'Farm-fresh, ripe red organic tomatoes packed with vitamins.',
    icon: Icons.eco_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'veg_2',
    name: 'Crisp Green Broccoli',
    quantity: 1,
    category: categories[Categories.vegetables]!,
    price: 2.49,
    unit: '500 g',
    description: 'Fresh nutrient-dense broccoli florets ready for healthy salads.',
    icon: Icons.forest_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'veg_3',
    name: 'Baby Spinach Leaves',
    quantity: 1,
    category: categories[Categories.vegetables]!,
    price: 1.79,
    unit: '250 g',
    description: 'Washed and prepped tender baby spinach leaves.',
    icon: Icons.spa_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'veg_4',
    name: 'Crunchy Carrots',
    quantity: 1,
    category: categories[Categories.vegetables]!,
    price: 1.49,
    unit: '1 kg',
    description: 'Sweet orange crunchy garden carrots.',
    icon: Icons.grass_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=500&auto=format&fit=crop&q=80',
  ),

  // Fruit
  GroceryItem(
    id: 'frt_1',
    name: 'Cavendish Bananas',
    quantity: 5,
    category: categories[Categories.fruit]!,
    price: 1.29,
    unit: '1 bunch (6 pcs)',
    description: 'Naturally sweet and potassium-rich ripe bananas.',
    icon: Icons.nature_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'frt_2',
    name: 'Royal Gala Apples',
    quantity: 1,
    category: categories[Categories.fruit]!,
    price: 3.49,
    unit: '1 kg',
    description: 'Crisp, sweet, and juicy red apples sourced from local orchards.',
    icon: Icons.apple_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'frt_3',
    name: 'Juicy Valencia Oranges',
    quantity: 1,
    category: categories[Categories.fruit]!,
    price: 2.99,
    unit: '1 kg',
    description: 'High in Vitamin C, perfect for freshly squeezed morning juice.',
    icon: Icons.brightness_5_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=500&auto=format&fit=crop&q=80',
  ),

  // Dairy
  GroceryItem(
    id: 'dry_1',
    name: 'Whole Pasteurized Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
    price: 2.19,
    unit: '1 Liter',
    description: 'Rich, creamy whole milk from pasture-raised dairy cows.',
    icon: Icons.water_drop_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'dry_2',
    name: 'Greek Yogurt (Plain)',
    quantity: 1,
    category: categories[Categories.dairy]!,
    price: 2.89,
    unit: '450 g',
    description: 'Thick, creamy protein-rich plain Greek yogurt.',
    icon: Icons.icecream_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'dry_3',
    name: 'Cheddar Cheese Block',
    quantity: 1,
    category: categories[Categories.dairy]!,
    price: 4.29,
    unit: '300 g',
    description: 'Aged sharp cheddar cheese crafted for sandwiches & melting.',
    icon: Icons.egg_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?w=500&auto=format&fit=crop&q=80',
  ),

  // Meat
  GroceryItem(
    id: 'mt_1',
    name: 'Prime Beef Steak',
    quantity: 1,
    category: categories[Categories.meat]!,
    price: 8.99,
    unit: '500 g',
    description: 'Tender grain-fed premium beef cut, ideal for searing.',
    icon: Icons.dinner_dining_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'mt_2',
    name: 'Fresh Chicken Breast',
    quantity: 1,
    category: categories[Categories.meat]!,
    price: 5.49,
    unit: '750 g',
    description: 'Boneless, skinless lean chicken breast fillets.',
    icon: Icons.restaurant_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=500&auto=format&fit=crop&q=80',
  ),

  // Carbs / Bakery
  GroceryItem(
    id: 'crb_1',
    name: 'Whole Grain Sourdough',
    quantity: 1,
    category: categories[Categories.carbs]!,
    price: 3.29,
    unit: '1 Loaf',
    description: 'Artisan baked whole wheat sourdough loaf with crisp crust.',
    icon: Icons.breakfast_dining_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=500&auto=format&fit=crop&q=80',
  ),
  GroceryItem(
    id: 'crb_2',
    name: 'Italian Penne Rigate Pasta',
    quantity: 1,
    category: categories[Categories.carbs]!,
    price: 1.69,
    unit: '500 g',
    description: '100% durum wheat semolina traditional Italian pasta.',
    icon: Icons.lunch_dining_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1621996346565-e3d5d6281691?w=500&auto=format&fit=crop&q=80',
  ),

  // Sweets & Snacks
  GroceryItem(
    id: 'swt_1',
    name: '70% Dark Chocolate Bar',
    quantity: 1,
    category: categories[Categories.sweets]!,
    price: 2.79,
    unit: '100 g',
    description: 'Fair-trade single-origin intense dark chocolate.',
    icon: Icons.cake_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=500&auto=format&fit=crop&q=80',
  ),

  // Spices & Condiments
  GroceryItem(
    id: 'spc_1',
    name: 'Extra Virgin Olive Oil',
    quantity: 1,
    category: categories[Categories.spices]!,
    price: 7.49,
    unit: '750 ml',
    description: 'Cold-pressed extra virgin Mediterranean olive oil.',
    icon: Icons.local_drink_rounded,
    imageUrl:
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=500&auto=format&fit=crop&q=80',
  ),
];