// lib/features/home/presentation/layout/home_layout.dart

import 'package:ai_chat/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:ai_chat/features/home/presentation/widgets/home_drawer.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home Layout (bottom navigation+sidebar+topBar+scrollable body)
class HomeLayout extends ConsumerStatefulWidget {
  /// using this we will pass tab as child
  final Widget child;

  /// Landing page/Home Page Constructor
  const HomeLayout({super.key, required this.child});

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getTitle(BuildContext context, String? currentRoute) {
    final appLocalizations = AppLocalizations.of(context)!;

    switch (currentRoute) {
      case '/home':
        return appLocalizations.home;
      case '/aiChat':
        return appLocalizations.aiAssistant;
      case '/uToUUserListPage':
        return appLocalizations.messages;
      default:
        return appLocalizations.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentIndex = ref.watch(homeControllerProvider).currentTabIndex;
    final currentRoute = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      key: _scaffoldKey, // Assign the key to the scaffold
      appBar: AppBar(
        title: Text(
          _getTitle(context, currentRoute),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState
              ?.openDrawer(), // Use the key to open the drawer
          icon: const Icon(Icons.menu),
        ),
      ),
      drawer: const HomeDrawer(),
      // body: IndexedStack(
      //   index: currentIndex,
      //   children: [HomePage(), AiChatView(), UserListPage()],
      // ),
      body: widget.child,
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
