enum Genre {
  novel('Վեպ'),
  history('Պատմություն'),
  fantasy('Ֆանտաստիկա'),
  poetry('Բանաստեղծություն');

  final String label;
  const Genre(this.label);
}

class Book {
  final String id;
  final String title;
  final String author;
  final Genre genre;
  bool isRead;
  int? rating; // 1-5 աստղ, սկզբում կարող է null լինել

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.isRead = false,
    this.rating,
  });
}