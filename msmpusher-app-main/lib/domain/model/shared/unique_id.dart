import 'package:uuid_type/uuid_type.dart';

class UniqueId {
  final Uuid _value;

  const UniqueId._(this._value);

  /// Generates a version-4 unique uid
  // ignore: sort_unnamed_constructors_first
  factory UniqueId() {
    return UniqueId._(Uuid.parse(uuid.v4()));
  }

  /// Converts a unique uid string to unique uid type
  factory UniqueId.parse(String uniqueId) {
    return UniqueId._(Uuid.parse(uniqueId));
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UniqueId && o._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => _value.toString();
}
