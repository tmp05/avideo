
class SerialCard extends Object {
  SerialCard(this.id, this.section, this.photo, this.title, this.address, this.kinopoisk,this.fave, this.subscribe, this.year);

  SerialCard.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        section = json['section'],
        photo = json['photo'],
        title = json['title_rus'],
        address = json['address'],
        kinopoisk = json['kinopoisk'].toString(),
        fave = json['fave'],
        subscribe = json['subscribe'],
        year = json['year'];

  final int id;
  final dynamic photo;
  final dynamic fave;
  final dynamic subscribe;
  final String title;
  final String address;
  final String section;
  final String kinopoisk;
  final int year;


  @override
  bool operator==(dynamic other) => identical(this, other) || id == other.id;

  @override
  int get hashCode => id;
}
