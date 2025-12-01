import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/provider/home_provider.dart';
import 'package:flutter_starter_kit/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

/// HomeBottomNav widget class
class HomeBottomNav extends ConsumerWidget {
  /// HomeBottomNav widget constructor
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Update tab state first
        ref.read(homeControllerProvider.notifier).changeTab(index);

        // Navigate using GoRouter after frame is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/secondBottomNav');
              break;
            case 2:
              context.go('/thirdBottomNav');
              break;
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.home,
        ),

        // BottomNavigationBarItem(
        //   icon: const Icon(Icons.search),
        //   label: AppLocalizations.of(context)!.search,
        // ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble),
          label: AppLocalizations.of(context)!.optionSecond,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat),
          label: AppLocalizations.of(context)!.optionThird,
        ),
      ],
    );
  }
}
