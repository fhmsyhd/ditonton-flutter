import 'package:ditonton/common/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';
  static const _crashlyticsTestEnabled = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS_TEST',
  );

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _crashlyticsTestEnabled
          ? FloatingActionButton.extended(
              key: const Key('crashlytics_test_button'),
              onPressed: FirebaseCrashlytics.instance.crash,
              icon: const Icon(Icons.bug_report),
              label: const Text('Test Crashlytics'),
            )
          : null,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: prussianBlue,
                  child: Center(
                    child: Image.asset('assets/circle-g.png', width: 128),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: mikadoYellow,
                  child: Text(
                    'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
