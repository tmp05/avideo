class Genre {
  Genre(this.id, this.text);

  Genre.fromJSON(Map<String, dynamic> json)
    : id = json['value'], text  = json['text'];

   final String text;
   final int id;


}