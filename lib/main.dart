import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'screens/book_details_screen.dart';

void main() {
  runApp(const BookLibraryApp());
}

class BookLibraryApp extends StatelessWidget {
  const BookLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BookListScreen(),
    );
  }
}

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final TextEditingController searchController = TextEditingController();

  BookGenre? selectedGenre;

  final List<Book> books = [
    Book(
      id: 1,
      title: 'Գիքորը',
      author: 'Հովհաննես Թումանյան',
      genre: BookGenre.history,
    ),
    Book(id: 2, title: 'Սամվել', author: 'Րաֆֆի', genre: BookGenre.novel),
    Book(
      id: 3,
      title: 'Անուշ',
      author: 'Հովհաննես Թումանյան',
      genre: BookGenre.poetry,
    ),
    Book(
      id: 4,
      title: 'Վարդանանք',
      author: 'Դերենիկ Դեմիրճյան',
      genre: BookGenre.history,
    ),
    Book(
      id: 5,
      title: 'Հարրի Փոթերը',
      author: 'Ջ. Ք. Ռոուլինգ',
      genre: BookGenre.fantasy,
    ),
    Book(
      id: 6,
      title: 'Փոքրիկ իշխանը',
      author: 'Անտուան դը Սենտ-Էքզյուպերի',
      genre: BookGenre.novel,
    ),
    Book(
      id: 7,
      title: 'Մթնշաղի անուրջներ',
      author: 'Վահան Տերյան',
      genre: BookGenre.poetry,
    ),
    Book(id: 8, title: 'Խենթը', author: 'Րաֆֆի', genre: BookGenre.history),
    Book(
      id: 9,
      title: 'Դավիթ Կոպերֆիլդ',
      author: 'Չարլզ Դիքենս',
      genre: BookGenre.novel,
    ),
    Book(
      id: 10,
      title: 'Ալպիական մանուշակ',
      author: 'Ակսել Բակունց',
      genre: BookGenre.novel,
    ),
  ];

  List<Book> get filteredBooks {
    final query = searchController.text.trim().toLowerCase();

    return books.where((book) {
      final matchesSearch =
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);

      final matchesGenre = selectedGenre == null || book.genre == selectedGenre;

      return matchesSearch && matchesGenre;
    }).toList();
  }

  int get readCount => books.where((book) => book.isRead).length;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void deleteBook(Book book) {
    final index = books.indexOf(book);

    if (index == -1) return;

    setState(() {
      books.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${book.title} ջնջվեց'),

        action: SnackBarAction(
          label: 'Վերականգնել',
          onPressed: () {
            setState(() {
              final newIndex = index > books.length ? books.length : index;

              books.insert(newIndex, book);
            });
          },
        ),
      ),
    );
  }

  Future<void> openDetails(Book book) async {
    final rating = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return BookDetailsScreen(book: book);
        },
      ),
    );

    if (!mounted || rating == null) return;

    setState(() {
      book.rating = rating;
      book.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Գրքեր • Կարդացված՝ $readCount/${books.length}'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Որոնման դաշտ
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,

              onChanged: (value) {
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Որոնել գիրք կամ հեղինակ...',
                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          // Ժանրերի ֆիլտր
          SizedBox(
            height: 55,

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 10),

              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Բոլորը'),
                    selected: selectedGenre == null,

                    onSelected: (value) {
                      setState(() {
                        selectedGenre = null;
                      });
                    },
                  ),

                  const SizedBox(width: 8),

                  ...BookGenre.values.map((genre) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),

                      child: ChoiceChip(
                        label: Text(genre.title),

                        selected: selectedGenre == genre,

                        onSelected: (value) {
                          setState(() {
                            selectedGenre = value ? genre : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Գրքերի ցուցակ
          Expanded(
            child: visibleBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Գիրք չի գտնվել',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: visibleBooks.length,

                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 2);
                    },

                    itemBuilder: (context, index) {
                      final book = visibleBooks[index];

                      return Dismissible(
                        key: ValueKey(book.id),

                        direction: DismissDirection.endToStart,

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        onDismissed: (direction) {
                          deleteBook(book);
                        },

                        child: BookTile(
                          book: book,

                          onTap: () {
                            openDetails(book);
                          },

                          onReadChanged: (value) {
                            setState(() {
                              book.isRead = value;
                            });
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
