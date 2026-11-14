import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_tile.dart';
import 'book_details_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Genre? _selectedGenre;

  final List<Book> _books = [
    Book(id: '1', title: 'Խելագարի հիշատակարանը', author: 'Նար-Դոս', genre: Genre.novel),
    Book(id: '2', title: 'Անուշ', author: 'Հովհաննես Թումանյան', genre: Genre.poetry),
    Book(id: '3', title: 'Սպանություն Միջօրեին', author: 'Ագաթա Քրիստի', genre: Genre.novel),
    Book(id: '4', title: '1984', author: 'Ջորջ Օրուել', genre: Genre.fantasy),
    Book(id: '5', title: 'Քնար Հայաստանի', author: 'Միսաք Մեծարենց', genre: Genre.poetry),
    Book(id: '6', title: 'Սասունցի Դավիթ', author: 'Էպոս', genre: Genre.history),
    Book(id: '7', title: 'Անվերջ պատմություն', author: 'Միխաել Էնդե', genre: Genre.fantasy),
    Book(id: '8', title: 'Հարի Փոթեր', author: 'Ջոան Ռոուլինգ', genre: Genre.fantasy),
    Book(id: '9', title: 'Վարդանանք', author: 'Դերենիկ Դեմիրճյան', genre: Genre.history),
    Book(id: '10', title: 'Միջնադարյան Հայաստան', author: 'Պատմաբան', genre: Genre.history),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGenre = _selectedGenre == null || book.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    final readCount = _books.where((b) => b.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Գրքեր (Կարդացված՝ $readCount/${_books.length})'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Որոնել ըստ անվան կամ հեղինակի...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Բոլորը'),
                  selected: _selectedGenre == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGenre = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...Genre.values.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(genre.label),
                      selected: _selectedGenre == genre,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGenre = selected ? genre : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Ոչ մի գիրք չի գտնվել 📚',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredBooks.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return Dismissible(
                        key: Key(book.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final deletedBook = book;
                          final deletedIndex = _books.indexOf(book);

                          setState(() {
                            _books.remove(book);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('«${deletedBook.title}» ջնջվեց'),
                              action: SnackBarAction(
                                label: 'Հետ բերել',
                                onPressed: () {
                                  setState(() {
                                    _books.insert(deletedIndex, deletedBook);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: BookTile(
                          book: book,
                          onCheckboxChanged: (value) {
                            setState(() {
                              book.isRead = value ?? false;
                            });
                          },
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(book: book),
                              ),
                            );

                            if (result != null && result is int) {
                              setState(() {
                                book.rating = result;
                                book.isRead = true;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}