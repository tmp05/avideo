class Country {
  Country(this.id, this.text);

  Country.fromJSON(Map<String, dynamic> json)
      : id = json['value'],
        text = json['text'];

  final String text;
  final int id;
}

class CountryList {
  CountryList.fromJSON(List<dynamic> json)
      : countries = json.map((dynamic i)=>Country.fromJSON(i)).toList();

  List<Country> countries = <Country>[];

  Country findById(int id) => countries.firstWhere((Country c) => c.id == id);
  Country findByTitle(String text) => countries.firstWhere((Country c) => c.text == text);
}