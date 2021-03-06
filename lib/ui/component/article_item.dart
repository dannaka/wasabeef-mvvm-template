import 'package:app/data/model/article.dart';
import 'package:app/ui/component/image.dart';
import 'package:app/ui/hook/use_l10n.dart';
import 'package:app/ui/hook/use_router.dart';
import 'package:app/ui/route/app_route.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArticleItem extends HookWidget {
  const ArticleItem({
    required this.article,
  });

  final Article article;

  static BorderRadius borderRadiusAll = BorderRadius.circular(8);
  static BorderRadius borderRadiusTop = const BorderRadius.only(
    topRight: Radius.circular(8),
    topLeft: Radius.circular(8),
    bottomLeft: Radius.circular(0),
    bottomRight: Radius.circular(0),
  );

  @override
  Widget build(BuildContext context) {
    final theme = useProvider(appThemeProvider);
    final router = useRouter();
    final l10n = useL10n();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusAll),
      elevation: 4,
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Hero(
              tag: article,
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: borderRadiusTop,
                  child: networkImage(article.urlToImage, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                article.title ?? l10n.noTitle,
                style: theme.textTheme.h20,
              ),
            ),
          ],
        ),
        onTap: () => router.push(DetailRoute(article: article)),
      ),
    );
  }
}
