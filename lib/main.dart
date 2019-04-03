import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
const API_KEY = 'df3a31e67f3d7aea6ecda22862af386e';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Movies aggregate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<Movie>> _getMovies() async{

    var data = await http.get('https://api.themoviedb.org/3/discover/movie?api_key='+API_KEY);

    var jsonData = json.decode(data.body);
    List<Movie>movies = [];
    int moviesCount=jsonData['results'].length;
    for(int i=0; i<moviesCount; i++){
      var mov = jsonData['results'][i];
      Movie movie = Movie(i,mov['title'],mov['overview'],mov['poster_path']);
      movies.add(movie);
    }
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getMovies(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data != null){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://image.tmdb.org/t/p/w200'+snapshot.data[index].poster_path
                      ),
                    ),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text('Click on title for more details'),
                    onTap: (){
                      Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  );
                },
              );
            }else{
              return Container(
                child: Center(
                  child: Text('Loading....'), // show message before get the data
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Movie movie;
  DetailPage(this.movie);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
                movie.title,
                style: new TextStyle(fontSize:26.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w300,
                fontFamily: "Roboto")
            ),

            new Image.asset(
              'https://image.tmdb.org/t/p/w200'+movie.poster_path,
              width: 200.0,
              height: 200.0,
            ),

            new Text(
                movie.overview,
                style: new TextStyle(fontSize:17.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w200,
                fontFamily: "Roboto")
            )
          ]

      ),
    );
  }
}


class Movie{
  final int index;
  final String title;
  final String overview;
  final String poster_path;
  Movie(this.index,this.title,this.overview,this.poster_path);
}









