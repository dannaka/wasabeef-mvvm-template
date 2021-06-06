import 'package:app/app.dart';
import 'package:app/data/model/result.dart';
import 'package:app/ui/component/loading.dart';
import 'package:app/ui/home/home_page.dart';
import 'package:app/ui/home/home_view_model.dart';
import 'package:app/ui/route/app_route.gr.dart';
import 'package:app/ui/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../data/dummy/dummy_news.dart';

class MockHomeViewModel extends Mock implements HomeViewModel {}

class MockUserViewModel extends Mock implements UserViewModel {}

void main() {
  final mockHomeViewModel = MockHomeViewModel();
  when(mockHomeViewModel.fetchNews).thenAnswer((_) => Future.value());
  when(() => mockHomeViewModel.news)
      .thenReturn(Result.success(data: dummyNews));

  final mockUserViewModel = MockUserViewModel();
  when(mockUserViewModel.signIn).thenAnswer((_) => Future.value());
  when(mockUserViewModel.signOut).thenAnswer((_) => Future.value());

  testWidgets('App widget test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeViewModelProvider.overrideWithValue(mockHomeViewModel),
          userViewModelProvider.overrideWithValue(mockUserViewModel),
        ],
        child: App(),
      ),
    );
  });

  testWidgets('HomePage widget test', (tester) async {
    await mockNetworkImages(() async {
      final appRouter = AppRouter();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeViewModelProvider.overrideWithValue(mockHomeViewModel),
            userViewModelProvider.overrideWithValue(mockUserViewModel),
          ],
          child: MaterialApp.router(
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            routeInformationParser: appRouter.defaultRouteParser(),
            routerDelegate: appRouter.delegate(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(appRouter.current.name == HomeRoute.name, true);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  testWidgets('Loading widget test', (tester) async {
    const loading = Loading();
    await tester.pumpWidget(const ProviderScope(child: loading));
    expect(find.byWidget(loading), findsOneWidget);
  });
}
