import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MapTile extends Equatable {
  final ObjectId id;
  final int corX;
  final int corY;
  final String? ownerId;
  final String? name;
  final int tileNumber;
  final bool empty;

  MapTile(
      {required this.id,
      required this.corX,
      required this.corY,
      this.ownerId,
      this.name,
      required this.tileNumber,
      this.empty = true});

  MapTile.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as ObjectId,
        name = map['name'] as String?,
        corX = map['corX'] as int,
        corY = map['corY'] as int,
        ownerId = map['ownerId'] as String?,
        tileNumber = map['tileNumber'] as int,
        empty = map['empty'] as bool;

  Map<String, dynamic> toMap() => <String, dynamic>{
        '_id': id,
        'name': name,
        'corX': corX,
        'corY': corY,
        'ownerId': ownerId,
        'tileNumber': tileNumber,
        'empty': empty,
      };

  MapTile.fromJson(Map<String, dynamic> map)
      : id = ObjectId.parse(map['_id'] as String),
        name = map['name'] as String?,
        corX = map['corX'] as int,
        corY = map['corY'] as int,
        ownerId = map['ownerId'] as String?,
        tileNumber = map['tileNumber'] as int,
        empty = map['empty'] as bool;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'name': name,
        'corX': corX,
        'corY': corY,
        'ownerId': ownerId,
        'tileNumber': tileNumber,
        'empty': empty,
      };

  MapTile copyWith({
    ObjectId? id,
    int? corX,
    int? corY,
    String? ownerId,
    String? name,
    int? tileNumber,
    bool? empty,
  }) {
    return MapTile(
        id: id ?? this.id,
        corX: corX ?? this.corX,
        corY: corY ?? this.corY,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        tileNumber: tileNumber ?? this.tileNumber,
        empty: empty ?? this.empty,);
  }

  @override
  List<Object?> get props => [id];
}
