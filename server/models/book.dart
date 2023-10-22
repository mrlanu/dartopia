class Book {
  Book({
    required this.title,
    required this.authors,
  });

  Book.fromMap(Map<String, dynamic> map)
      : title = map['title'] as String,
        authors = map['authors'] as List<String>;

  Book copyWith({String? title, List<String>? authors}) => Book(
        title: title ?? '',
        authors: authors ?? [],
      );

  final String title;
  final List<String> authors;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': title,
        'authors': authors,
      };
}

List<Map<String, dynamic>> books = [
  {
    'title': 'The Richest Man in Babylon',
    'authors': ['George .s. Classon'],
  },
  {
    'title': "President's Pressman",
    'authors': ['Lee Njiru'],
  },
  {
    'title': 'Lolita',
    'authors': ['Vladimir Nabokov,'],
  },
  {
    'title': 'Always start with why',
    'authors': ['Simon Sinek'],
  },
  {
    'title': 'To Kill a Mockingbird',
    'authors': ['Harper Lee'],
  }
];
