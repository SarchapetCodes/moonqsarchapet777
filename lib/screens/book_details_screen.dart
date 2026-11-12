import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.book.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Գրքի տվյալներ')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.menu_book, size: 90, color: Colors.deepPurple),

            const SizedBox(height: 25),

            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(widget.book.author, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Text('Ժանր՝ ${widget.book.genre.title}'),

            const SizedBox(height: 40),

            const Text(
              'Գնահատեք գիրքը',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;

                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = value;
                    });
                  },

                  icon: Icon(
                    value <= selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 38,
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            Text('$selectedRating / 5', style: const TextStyle(fontSize: 18)),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedRating == 0
                    ? null
                    : () {
                        Navigator.pop(context, selectedRating);
                      },

                child: const Text('Պահպանել'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
