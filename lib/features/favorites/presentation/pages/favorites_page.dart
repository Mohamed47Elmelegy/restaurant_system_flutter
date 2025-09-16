import 'package:flutter/material.dart';

import '../../../../core/constants/empty_page.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_helper.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getSurfaceColor(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المفضلة',
          style: AppTextStyles.senBold18(
            context,
          ).copyWith(color: ThemeHelper.getPrimaryTextColor(context)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: EmptyPagePresets.noFavorites(context),
    );
  }
}
