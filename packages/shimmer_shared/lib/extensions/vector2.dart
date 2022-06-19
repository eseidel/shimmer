import 'package:vector_math/vector_math_64.dart';

extension Vector2Extensions on Vector2 {
  bool isZero() => x == 0 && y == 0;
}
