import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      title: "Useless List",
      theme: new ThemeData(primaryColor: Colors.deepOrangeAccent, backgroundColor: Colors.black12,),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget
{
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords>
{
  final _suggestions = <WordPair>[];//word list 
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();//Words you favorited

  void _pushSaved()
  {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context)
        {
          final tiles = _saved.map(
              (pair){
                return new ListTile(
                  title: new Text(
                   pair.asPascalCase,
                   style: _biggerFont,
                  ),
                  trailing: new Icon(Icons.favorite, color: Colors.purpleAccent,),//Creates new Icon following the entry
                onTap: ()//
                {
                  setState(() {
                        print(_saved);
                        print("break");
                        print(pair);
                        _suggestions.add(pair);
                        _saved.remove(pair);

                      });

                },
                );
              },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,).toList();
          return new Scaffold(
            appBar: new AppBar(//Page for selected words
              title: new Text("Clicked Things"),
              actions: <Widget>[
                new IconButton(icon: new Icon(Icons.list),onPressed: _pushSaved),
                ]
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }


  Widget _buildRow(WordPair pair)//build row objects
  {
    final alreadySaved = _saved.contains(pair);//bool if saved
    return new ListTile(
      title: new Text(
        pair.asPascalCase,//Sets pascal case
        style: _biggerFont,//Embiggens font
      ),
      trailing: new Icon(//Creates new Icon following the entry
        alreadySaved ? Icons.favorite : Icons.favorite_border,//tertiary statement {if this} ? {Do this}:{Else this]}
        color: alreadySaved ? Colors.purpleAccent : null,
      ),
      onTap: ()
    {
      setState(
      ()
      {
        if (alreadySaved)//If highlighted
          {
            _saved.remove(pair);

            
          }
        else//If not highlighted
          {
            _saved.add(pair);
            _suggestions.remove(pair);
          }
      },
      );
    }
    );
  }

  Widget _buildSuggestions()//builds selections from random words
  {
    return new ListView.builder
      (
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i)
      {
        if(i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context)//builds home page
  {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("164 Minutes of my life"),
        actions: <Widget>[//Click event
          new IconButton(icon: new Icon(Icons.list),onPressed: _pushSaved),//Creates button
        ]
      ),
      body: _buildSuggestions(),//list populated from random words list with icons added
    );
  }

}