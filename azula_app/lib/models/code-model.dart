
import 'package:cloud_firestore/cloud_firestore.dart';

class CodeModel {
  String id;
  String code;
  String owner;
  String userId;
  String secret;
  String issuer;
  Timestamp timestamp;
  bool valid;

  CodeModel({this.id, this.code, this.owner, this.userId, this.issuer, this.secret, this.timestamp, this.valid});

  static Map<String, dynamic> toMap(CodeModel data) {
    return {
      "id": null,
      'code': data.code,
      'owner': data.owner,
      'secret': data.secret,
      'userId': data.userId,
      'issuer': data.issuer,
      'timestamp': data.timestamp,
      'valid': data.valid
    };
  }


  static CodeModel fromDocumentSnapshot(DocumentSnapshot data) {
    return CodeModel(
        id: data.documentID,
        code: data.data['code'],
        owner: data.data['owner'],
        userId: data.data['userId'],
        secret: data.data['secret'],
        issuer: data.data['issuer'],
        timestamp: data.data['timestamp'],
        valid: data.data['bool']
    );
  }


}