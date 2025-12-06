import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: cs.primaryContainer,
              child: Center(
                child: Image.asset(
                  'assets/circle-g.png',
                  width: 128,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              color: cs.secondaryContainer,
              child: Text(
                'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSecondaryContainer),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
