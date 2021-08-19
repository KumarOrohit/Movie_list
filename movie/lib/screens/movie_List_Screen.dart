import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_list/helpers/database_helper.dart';
import 'package:movie_list/models/movie_model.dart';
import 'package:movie_list/screens/add_movie_screen.dart';

class movieListScreen extends StatefulWidget {
  @override
  _movieListScreenState createState() => _movieListScreenState();
}

class _movieListScreenState extends State<movieListScreen> {
  Future<List<movie>> _movieList;

  @override
  void initState() {
    super.initState();
    _updateMovieList();
  }

  _updateMovieList() {
    setState(() {
      _movieList = dataBaseHelper.instance.getMovieList();
    });
  }

  Widget _buildMovie(movie Movie) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              Movie.title,
              style: TextStyle(
                  fontSize: 18.0, decoration: TextDecoration.lineThrough),
            ),
            subtitle: Text(
              Movie.director,
              style: TextStyle(
                  fontSize: 15.0, decoration: TextDecoration.lineThrough),
            ),
            trailing: Image.asset(
              'assets/images/me.jpeg',
              width: 100,
              height: 80,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => addMovieScreen(
                          updateMovieList: _updateMovieList(),
                          Movie: Movie,
                        ))),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => addMovieScreen(),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _movieList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80.0),
            itemCount: 1 + snapshot.data().length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Watched Movie',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(height: 10.0),
                      ],
                    ));
              }
              return _buildMovie(snapshot.data()[index - 1]);
            },
          );
        },
      ),
    );
  }
}
