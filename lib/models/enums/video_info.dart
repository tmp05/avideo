
class VideoInfo extends Object {
  VideoInfo(this.id, this.title, this.shTitle, this.channel, this.url1,this.url2, this.key, this.fkey,this.fext, this.server,this.serverCache,this.dash,this.preview,this.audio,this.duration,this.sizeCount);

  VideoInfo.fromJSON(Map<String, dynamic> json)
      : id = json['v_id'],
        channel = json['channel_id'],
        title = json['v_title'].replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"'),
        shTitle = json['v_title'].substring(json['v_title'].indexOf('-')+1).replaceAll(RegExp(r'\<.*?>'), '').replaceAll('&quot;','\"'),
        url1 = json['url1'],
        url2 = json['url2'],
        key = json['v_key'],
        fkey = json['v_fkey'],
        fext = json['v_fext'],
        server = json['server'],
        serverCache = json['server_cache'],
        dash = json['dash'],
        preview = json['preview'],
        audio = json['audio'],
        duration = json['duration'],
        sizeCount = json['size_count'];

  final int id;
  final int channel;
  final String title;
  final String shTitle;
  final String url1;
  final String url2;
  final String key;
  final String fkey;
  final String fext;
  final String server;
  final int serverCache;
  final int dash;
  final int preview;
  final int audio;
  final int duration;
  final int sizeCount;

  @override
  bool operator==(dynamic other) => identical(this, other) || id == other.id;

  @override
  int get hashCode => id;
}
