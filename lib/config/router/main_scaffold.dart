import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';

import '../../core/widgets/bottom_navigation_bar_widgets.dart';


class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<String> _routes = [
    Routes.home,
    Routes.map,
    Routes.chose,
    Routes.message,
    Routes.profile,
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    final matchedIndex = _routes.indexWhere((r) => location.startsWith(r));
    if (matchedIndex != -1 && matchedIndex != _currentIndex) {
      _currentIndex = matchedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: WBottomNavigationBar(selectedIndex: _currentIndex, onTap: _onTap),
    );
  }
}
