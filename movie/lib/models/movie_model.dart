class movie {
  int id;
  String title;
  String director;

  movie({this.title, this.director});
  movie.withId({this.id, this.title, this.director});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['director'] = director;
    return map;
  }

  factory movie.fromMap(Map<String, dynamic> map) {
    return movie.withId(
      id: map['id'],
      title: map['title'],
      director: map['director'],
    );
  }
}
