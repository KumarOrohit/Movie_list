import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:movie_list/helpers/database_helper.dart';
import 'package:movie_list/models/movie_model.dart';

class addMovieScreen extends StatefulWidget {
  final Function updateMovieList;
  final movie Movie;
  addMovieScreen({this.updateMovieList, this.Movie});

  @override
  _addMovieScreenState createState() => _addMovieScreenState();
}

class _addMovieScreenState extends State<addMovieScreen> {
  File imageFile;

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture as File;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture as File;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('make a choice'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    child: Text('camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _director = '';

  @override
  void initState() {
    super.initState();
    if (widget.Movie != null) {
      _title = widget.Movie.title;
      _director = widget.Movie.director;
    }
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text('no image selected');
    } else {
      return Image.file(imageFile, width: 400, height: 400);
    }
  }

  _delete() {
    dataBaseHelper.instance.deleteMovie(widget.Movie.id);
    widget.updateMovieList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title,$_director');

      movie Movie = movie(title: _title, director: _director);
      if (widget.Movie == null) {
        dataBaseHelper.instance.insertMovie(Movie);
      } else {
        Movie.id = widget.Movie.id;
        dataBaseHelper.instance.updateMovie(Movie);
      }
      widget.updateMovieList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            widget.Movie == null ? 'Add Movie' : 'Update Movie',
            style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      labelText: "Movie's Title",
                      labelStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (input) => input.trim().isEmpty
                        ? 'please enter a movie title'
                        : null,
                    onSaved: (input) => _title = input,
                    initialValue: _title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      labelText: "Director's name",
                      labelStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (input) => input.trim().isEmpty
                        ? 'please enter a movie title'
                        : null,
                    onSaved: (input) => _director = input,
                    initialValue: _director,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _decideImageView(),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              _showChoiceDialog(context);
            },
            child: Text('select poster'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ElevatedButton(
              child: Text(
                widget.Movie == null ? 'Add' : 'Update Movie',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              onPressed: _submit,
            ),
          ),
          widget.Movie != null
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: _delete,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
