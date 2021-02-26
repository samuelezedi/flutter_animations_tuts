
class QrDataModel {
  String user;
  String secret;
  String issuer;

  QrDataModel({this.user, this.issuer, this.secret});

  static QrDataModel fromMap(Map<String, dynamic> data) {
    return QrDataModel(
        user: data['user']??"",
        secret: data['secret'],
        issuer: data['issuer']
    );
  }

}