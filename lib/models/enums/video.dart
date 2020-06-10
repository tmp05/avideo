

class Video extends Object {
  Video(this.id, this.title, this.address, this.key, this.countView, this.hd, this.preview,this.subtitle,this.duration, this.section, this.view, this.episod, this.i, this.shTitle);
  Video.fromJSON(Map<String, dynamic> json)
      : id = json['v_id'],
        title = json['v_title'].replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"'),
        shTitle = json['v_title'].substring(json['v_title'].indexOf('-')).replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"'),
        address = json['address'],
        key = json['v_key'],
        countView = json['count_view'],
        preview = json['preview'],
        hd = json['hd'],
        subtitle = json['subtitle'],
        duration = json['duration'],
        section = json['section'],
        view = json['view'],
        episod = json['episod'],
        i = json['i'];

  final int id;
  final String title;
  final String shTitle;
  final String address;
  final String key;
  final int countView;
  final int preview;
  final String hd;
  final int subtitle;
  final int duration;
  final String section;
  final int view;
  final String episod;
  final int i;


  @override
  bool operator==(dynamic other) => identical(this, other) || id == other.id;

  @override
  int get hashCode => id;
}
