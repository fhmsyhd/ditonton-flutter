import 'package:ditonton/common/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('creates pinned client from bundled certificate', () async {
    final client = await SslPinning.createClient();

    expect(client, isA<TmdbPinnedClient>());

    client.close();
  });

  test('pinned client accepts HTTPS requests to TMDB', () async {
    final innerClient = MockClient.streaming((request, bodyStream) async {
      return http.StreamedResponse(Stream.value([]), 200);
    });
    final client = TmdbPinnedClient(innerClient);

    final response = await client.get(
      Uri.https(SslPinning.allowedHost, '/3/movie/popular'),
    );

    expect(response.statusCode, 200);
    client.close();
  });

  test('pinned client rejects other hosts', () async {
    final client = TmdbPinnedClient(
      MockClient((request) async {
        return http.Response('', 200);
      }),
    );

    expect(
      () => client.get(Uri.https('example.com', '/')),
      throwsA(isA<StateError>()),
    );

    client.close();
  });
}
