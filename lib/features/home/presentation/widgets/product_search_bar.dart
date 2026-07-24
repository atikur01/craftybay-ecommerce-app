import 'package:flutter/material.dart';

class ProductSearchBar extends StatefulWidget {
  const ProductSearchBar({super.key});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        prefixIconColor: Colors.grey,
        fillColor: Colors.grey.withAlpha(50),
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .circular(10),
        ),
      ),
    );
  }
}
