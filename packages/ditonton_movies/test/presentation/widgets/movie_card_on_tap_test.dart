import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../dummy_data/dummy_objects.dart';
      },
    ));

    await tester.pump();
    final cardInk = tester.widget<InkWell>(find.byType(InkWell));
    cardInk.onTap!.call();
    await tester.pump();

    expect(navigatedId, testMovie.id);
  });
}
