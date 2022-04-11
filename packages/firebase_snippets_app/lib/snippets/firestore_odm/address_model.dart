import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

// [START sub_collections_define]
@JsonSerializable()
class Address {
  final String streetName;

  Address({required this.streetName});

  factory Address.fromJson(Map<String, Object?> json) =>
      _$AddressFromJson(json);

  Map<String, Object?> toJson() => _$AddressToJson(this);
}
// [END sub_collections_define]
