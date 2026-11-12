import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final ValueChanged<bool> onReadChanged;

  const BookTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.onReadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(child: Text('${book.id}')),

        title: Text(
          book.title,
          style: TextStyle(
            decoration: book.isRead
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(book.author),
            Text(book.genre.title),

            if (book.rating != null)
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < book.rating! ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('${book.rating}/5'),
                ],
              ),
          ],
        ),

        trailing: Checkbox(
          value: book.isRead,
          onChanged: (value) {
            if (value != null) {
              onReadChanged(value);
            }
          },
        ),
      ),
    );
  }
}
