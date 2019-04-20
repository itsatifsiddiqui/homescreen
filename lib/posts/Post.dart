import 'package:meta/meta.dart';

class Post {
  List<String> images;
  int likes;
  int seen;
  String shareUrl;
  String launcherName;
  String iconPack;
  String widget;
  String wallpaperUrl;
  String otherInfo;
  String description;
  bool isOpened;
  bool isFavourite;
  String tags;
  String _launcherSettingsUrl;

  Post(
      {@required List<String> images,
      @required int likes,
      @required int seen,
      String shareUrl,
      @required String launcherName,
      @required String iconPack,
      @required String widget,
      bool isOpened,
      @required bool isFavourite,
      String wallpaperUrl,
      String otherInfo,
      @required String description,
      @required String tags,
      String launcherSettingsUrl}) {
    this.images = images;
    this.likes = likes;
    this.seen = seen;
    this.shareUrl = shareUrl;
    this.launcherName = launcherName;
    this.iconPack = iconPack;
    this.widget = widget;
    this.isOpened = isOpened;
    this.isFavourite = isFavourite;
    this.wallpaperUrl = wallpaperUrl;
    this.otherInfo = otherInfo;
    this.description = description;
    this.tags = tags;
    this._launcherSettingsUrl = launcherSettingsUrl;
  }

  Post.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    likes = json['likes'];
    seen = json['seen'];
    shareUrl = json['shareUrl'];
    launcherName = json['launcherName'];
    iconPack = json['iconPack'];
    widget = json['widget'];
    isFavourite = json['isFavourite'];
    wallpaperUrl = json['wallpaperUrl'];
    otherInfo = json['otherInfo'];
    description = json['description'];
    tags = json['tags'];
    _launcherSettingsUrl = json['launcherSettingsUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['likes'] = this.likes;
    data['seen'] = this.seen;
    data['shareUrl'] = this.shareUrl;
    data['launcherName'] = this.launcherName;
    data['iconPack'] = this.iconPack;
    data['widget'] = this.widget;
    data['isFavourite'] = this.isFavourite;
    data['wallpaperUrl'] = this.wallpaperUrl;
    data['otherInfo'] = this.otherInfo;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['launcherSettingsUrl'] = this._launcherSettingsUrl;
    return data;
  }
}
