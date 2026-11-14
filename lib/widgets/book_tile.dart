import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onCheckboxChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: book.isRead,
        onChanged: onCheckboxChanged,
      ),
      title: Text(
        book.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: book.isRead ? TextDecoration.lineThrough : null,
          color: book.isRead ? Colors.grey : null,
        ),
      ),
      subtitle: Text('${book.author} • ${book.genre.label}'),
      trailing: book.rating != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${book.rating}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          : null,
    );
  }
}