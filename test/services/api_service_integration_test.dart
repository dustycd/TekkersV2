import 'package:flutter_test/flutter_test.dart';
import 'package:tekkers/services/api_service.dart';

void main() {
  group('ApiService Integration Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService(baseUrl: 'http://localhost:3000');
    });

    test('fetchData returns data for valid response', () async {
      // Arrange
      final endpoint = 'valid-endpoint';

      // Act
      final result = await apiService.fetchData(endpoint);

      // Assert
      expect(result, isNotNull);
      expect(result['key'], equals('value')); // Assuming expected response
    });

    test('fetchData throws an exception for a 404 response', () async {
      // Arrange
      final endpoint = 'non-existent-endpoint';

      // Act & Assert
      expect(
        () async => await apiService.fetchData(endpoint),
        throwsException,
      );
    });

    test('fetchData handles server errors (500) gracefully', () async {
      // Arrange
      final endpoint = 'server-error-endpoint';

      // Act & Assert
      expect(
        () async => await apiService.fetchData(endpoint),
        throwsException,
      );
    });

    test('fetchData handles invalid JSON gracefully', () async {
      // Arrange
      final endpoint = 'invalid-json-endpoint';

      // Act & Assert
      expect(
        () async => await apiService.fetchData(endpoint),
        throwsA(isA<FormatException>()),
      );
    });

    test('fetchData handles empty JSON gracefully', () async {
      // Arrange
      final endpoint = 'empty-json-endpoint';

      // Act
      final result = await apiService.fetchData(endpoint);

      // Assert
      expect(result, isEmpty);
    });

    test('fetchData handles network errors gracefully', () async {
      // Arrange
      final endpoint = 'network-error-endpoint';

      // Simulate network issue by providing an unreachable server
      apiService = ApiService(baseUrl: 'http://unreachable-server');

      // Act & Assert
      expect(
        () async => await apiService.fetchData(endpoint),
        throwsA(isA<Exception>()),
      );
    });
  });
}
