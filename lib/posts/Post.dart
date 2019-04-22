class Post {
  int id;
  String iconPack;
  String otherInfo;
  List<String> images;
  String widget;
  String wallpaperUrl;
  String launcherName;
  String description;
  bool isOpened;
  bool isFavourite;
  int seen;
  int likes;
  List<String> tags;

  Post(
      {this.id,
      this.iconPack,
      this.otherInfo,
      this.images,
      this.widget,
      this.wallpaperUrl,
      this.launcherName,
      this.description,
      this.isFavourite,
      this.seen,
      this.likes,
      this.tags});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    iconPack = json['iconPack'];
    otherInfo = json['otherInfo'];
    images = json['images'].cast<String>();
    widget = json['widget'];
    wallpaperUrl = json['wallpaperUrl'];
    launcherName = json['launcherName'];
    description = json['description'];
    isFavourite = json['isFavourite'];
    seen = json['seen'] as int;
    likes = json['likes'] as int;
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iconPack'] = this.iconPack;
    data['otherInfo'] = this.otherInfo;
    data['images'] = this.images;
    data['widget'] = this.widget;
    data['wallpaperUrl'] = this.wallpaperUrl;
    data['launcherName'] = this.launcherName;
    data['description'] = this.description;
    data['isFavourite'] = this.isFavourite;
    data['seen'] = this.seen;
    data['likes'] = this.likes;
    data['tags'] = this.tags;
    return data;
  }
}
