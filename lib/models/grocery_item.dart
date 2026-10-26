import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:first_app/models/category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.price = 2.99,
    this.unit = '1 kg',
    this.description = 'Fresh and organic',
    this.icon,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
  final double price;
  final String unit;
  final String description;
  final IconData? icon;
  final String? imageUrl;

  GroceryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    Category? category,
    double? price,
    String? unit,
    String? description,
    IconData? icon,
    String? imageUrl,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String toJson() {
    return json.encode({
      'name': name,
      'quantity': quantity,
      'category': category.title,
      'price': price,
      'unit': unit,
      'image_url': imageUrl ?? '',
    });
  }
}