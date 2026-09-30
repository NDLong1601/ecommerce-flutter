import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';

@JsonSerializable()
class UserInfoModel {
  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'avatar_url')
  final String avatarUrl;

  @JsonKey(name: 'date_of_birth')
  final DateTime dateOfBirth;

  final String email;

  final String password;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.dateOfBirth,
    required this.email,
    required this.password,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  /// Create a default UserInfoModel with email and password
  factory UserInfoModel.createDefault({
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  }) {
    return UserInfoModel(
      firstName: firstName,
      lastName: lastName,
      avatarUrl: 'https://i.sstatic.net/l60Hf.png',
      dateOfBirth: DateTime.now(),
      email: email,
      password: password,
    );
  }
}
