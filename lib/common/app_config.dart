class AppConfig {
  static const tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  static void validate() {
    if (tmdbApiKey.isEmpty) {
      throw StateError(
        'TMDB_API_KEY belum diatur. Jalankan aplikasi dengan '
        '--dart-define=TMDB_API_KEY=YOUR_API_KEY.',
      );
    }
  }
}
