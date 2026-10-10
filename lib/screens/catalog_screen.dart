import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const List<Book> books = [
    Book(
      id: 1,
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      price: 85000,
    ),
    Book(
      id: 2,
      title: 'Bumi',
      author: 'Tere Liye',
      price: 95000,
    ),
    Book(
      id: 3,
      title: 'Atomic Habits',
      author: 'James Clear',
      price: 120000,
    ),
    Book(
      id: 4,
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      price: 100000,
    ),
  ];

  String rupiah(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = context.watch<CartProvider>().totalItems;
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (totalItems > 0)
                Positioned(
                  right: 4,
                  top: 3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Katalog Buku',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...books.map(
            (book) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (book.imageUrl != null)
                      Image.network(
                        book.imageUrl!,
                        width: 65,
                        height: 85,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(
                          Icons.menu_book,
                          size: 60,
                        ),
                      )
                    else
                      const Icon(
                        Icons.menu_book,
                        size: 60,
                        color: Colors.indigo,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text('Penulis: ${book.author}'),
                          const SizedBox(height: 6),
                          Text(
                            rupiah(book.price),
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                context
                                    .read<CartProvider>()
                                    .addItem(book);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${book.title} ditambahkan',
                                    ),
                                    duration: const Duration(
                                      seconds: 1,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add_shopping_cart,
                              ),
                              label: const Text(
                                'Tambah ke Keranjang',
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
          ),
        ],
      ),
    );
  }
}