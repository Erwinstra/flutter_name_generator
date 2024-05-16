import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordPairGenerator extends StatefulWidget {
  const WordPairGenerator({super.key});

  @override
  State<WordPairGenerator> createState() => _WordPairGeneratorState();
}

class _WordPairGeneratorState extends State<WordPairGenerator> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = <WordPair>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair Generator'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SavedPage(favoriteWords: _savedWordPairs),
                ),
              );
            },
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return const Divider();
          }

          print('index= $index');

          final id = index ~/ 2;

          print('id $id');

          if (id >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildListTile(_randomWordPairs[id]);
        },
      ),
    );
  }

  Widget _buildListTile(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
      leading: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  final Set<WordPair> favoriteWords;
  const SavedPage({super.key, required this.favoriteWords});

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = favoriteWords.map((pair) {
      return ListTile(
        leading: Text(
          pair.asPascalCase,
          style: const TextStyle(fontSize: 16),
        ),
      );
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair Generator'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: ListView(children: divided),
    );
  }
}
