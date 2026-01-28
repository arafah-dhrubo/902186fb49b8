sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onLeft(value);

  @override
  bool operator ==(Object other) => other is Left<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onRight(value);

  @override
  bool operator ==(Object other) => other is Right<L, R> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
