import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinning {
  static const pemCertificateAsset =
      'assets/certificates/amazon_rsa_2048_m04.pem';
  static const derCertificateAsset =
      'assets/certificates/amazon_rsa_2048_m04.der';
  static const allowedHost = 'api.themoviedb.org';

  const SslPinning._();

  static Future<http.Client> createClient({AssetBundle? assetBundle}) async {
    final certificateAsset = Platform.isIOS
        ? derCertificateAsset
        : pemCertificateAsset;
    final certificate = await (assetBundle ?? rootBundle).load(
      certificateAsset,
    );
    final certificateBytes = certificate.buffer.asUint8List(
      certificate.offsetInBytes,
      certificate.lengthInBytes,
    );

    final securityContext = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certificateBytes);
    final ioClient = HttpClient(context: securityContext)
      ..badCertificateCallback = (certificate, host, port) => false;

    return TmdbPinnedClient(IOClient(ioClient));
  }
}

class TmdbPinnedClient extends http.BaseClient {
  final http.Client _innerClient;

  TmdbPinnedClient(this._innerClient);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (request.url.scheme != 'https' ||
        request.url.host != SslPinning.allowedHost) {
      throw StateError('Pinned client only accepts HTTPS requests to TMDB');
    }
    return _innerClient.send(request);
  }

  @override
  void close() => _innerClient.close();
}
