
class ChannelInfo extends Object {
  ChannelInfo(this.id, this.section, this.title, this.address);

  ChannelInfo.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        section = json['section'],
        title = json['title'],
        address = json['address'];

  final int id;
  final String title;
  final String address;
  final String section;
}
