import 'package:flutter_test/flutter_test.dart';
import 'package:my_ewesome_app/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('email returns error for invalid input', () {
      expect(Validators.email('invalid'), isNotNull);
      expect(Validators.email('test@example.com'), isNull);
    });

    test('password requires at least 6 characters', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });
}
