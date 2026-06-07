import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';

class YesNativeApp extends ConsumerWidget {
  const YesNativeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Yes Native',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        final isLightMode = Theme.of(context).brightness == Brightness.light;
        return Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.surface),
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: isLightMode ? 0.15 : 0.05, // 15% in light mode, 5% in dark mode
                  child: Image.asset(
                    'assets/images/nevarkfoods.png', // Using the full logo which is known to be correct and transparent
                    width: 250,
                  ),
                ),
              ),
            ),
            if (child != null) child,
          ],
        );
      },
    );
  }
}
