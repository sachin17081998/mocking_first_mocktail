import 'package:flutter_test/flutter_test.dart';
import 'package:mocking_first_mocktail/api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MyApi api;
  late MockClient mockClient;
  setUpAll(() => registerFallbackValue(FakeUri()));
  setUp(() {
    mockClient = MockClient();
    api = MyApi(client: mockClient);
  });

  tearDown(() {
    reset(mockClient); // Optional: Reset mocks if needed
  });
  group('testing fetchPost method of MyAPI class', () {
    test('returns a List<Photo> if the http call completes successfully',
        () async {
      // Arrange
      final mockResponseData = jsonEncode([
        {
          "albumId": 1,
          "id": 1,
          "title": "test title",
          "url": "test url",
          "thumbnailUrl": "test thumbnailUrl"
        }
      ]);
      //stubbing
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(mockResponseData, 200));

      // Act
      final result = await api.fetchPosts();

      // Assert
      expect(result, isA<List<Photo>>());
      expect(result.length, 1);
      expect(result[0].title, 'test title');
    });
  });

  group('Testing Exceptions ', () {
    test('throws an exception if the http call completes with an error', () {
      // Arrange
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(api.fetchPosts(), throwsException);
    });

    test('Testing Parsing Errors', () async {
      // Arrange
      final mockResponseData = jsonEncode([
        {
          "id": 1,
          "title": "test title",
          "url": "test url",
          "thumbnailUrl": "test thumbnailUrl"
        }
      ]);
      //stubbing
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(mockResponseData, 200));

      // Act & Assert
      expect(
          api.fetchPosts(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to parse photo data'),
          )));
    });
  });
}
