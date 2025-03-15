class UserDetails {
  final String? name;
  final String pinHash;
  final String pinSalt;
  bool useBiometrics;

  UserDetails({
    this.name,
    required this.pinHash,
    required this.pinSalt,
    this.useBiometrics = false,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'] as String?,
      pinHash: json['pinHash'] as String,
      pinSalt: json['pinSalt'] as String,
      useBiometrics: json['useBiometrics'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pinHash': pinHash,
      'pinSalt': pinSalt,
      'useBiometrics': useBiometrics,
    };
  }
}
