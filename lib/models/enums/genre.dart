class Genre {
  Genre(this.id, this.title);

  Genre.fromJSON(Map<String, dynamic> json)
    : id = json['value'], title  = json['text'], isSelected= false;

   final String title;
   final int id;
   bool isSelected;

}