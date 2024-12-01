import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tekkers/services/api_service.dart';
import 'package:http/http.dart' as http;

// Generate mock for http.Client
@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Tests', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService =
          ApiService(baseUrl: 'https://example.com', client: mockClient);
    });

    test('fetchData returns expected data for a successful response', () async {
      // Arrange: Mock the HTTP response
      const endpoint = 'api-endpoint';
      final mockResponse = '{"key": "value"}';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      // Act: Call the API
      final result = await apiService.fetchData(endpoint);

      // Assert: Verify the result
      expect(result, isNotNull);
      expect(result['key'], 'value');
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData throws an exception for a failed response', () async {
      // Arrange: Mock the HTTP response
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer((_) async => http.Response('Error', 404));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await apiService.fetchData(endpoint), throwsException);

      // Verify: Ensure the API call was made
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData handles an empty response gracefully', () async {
      // Arrange: Mock an empty HTTP response
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer(
              (_) async => http.Response('{}', 200)); // Return valid empty JSON

      // Act: Call the API
      final result = await apiService.fetchData(endpoint);

      // Assert: Verify the result is empty
      expect(result, isA<Map>());
      expect(result, isEmpty); // Expect an empty map
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData handles invalid JSON gracefully', () async {
      // Arrange: Mock an invalid JSON response
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer((_) async => http.Response('Invalid JSON', 200));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await apiService.fetchData(endpoint),
          throwsA(isA<FormatException>()));

      // Verify: Ensure the API call was made
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData handles server errors gracefully', () async {
      // Arrange: Mock a server error response
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await apiService.fetchData(endpoint), throwsException);

      // Verify: Ensure the API call was made
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData handles network errors gracefully', () async {
      // Arrange: Simulate a network error
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenThrow(http.ClientException('Failed to connect'));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await apiService.fetchData(endpoint),
          throwsA(isA<http.ClientException>()));

      // Verify: Ensure the API call was attempted
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });

    test('fetchData handles null or unexpected response data', () async {
      // Arrange: Mock a response with `null` body
      const endpoint = 'api-endpoint';
      when(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .thenAnswer((_) async => http.Response('', 200));

      // Act & Assert: Verify the exception is thrown
      expect(() async => await apiService.fetchData(endpoint),
          throwsA(isA<FormatException>()));

      // Verify: Ensure the API call was attempted
      verify(mockClient.get(Uri.parse('https://example.com/$endpoint')))
          .called(1);
    });
  });
}
