import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../router/route_names.dart';
import '../utils/guest_guard.dart';
import '../../l10n/app_localizations.dart';

/// Bottom navigation indices (excluding center FAB).
class MainTabIndex {
  MainTabIndex._();

  static const int home = 0;
  static const int salons = 1;
  static const int appointments = 2;
  static const int profile = 3;
}

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  final Widget child;
  final int currentIndex;

  static int indexFromLocation(String location) {
    if (location.startsWith(RouteNames.salons)) return MainTabIndex.salons;
    if (location.startsWith(RouteNames.appointments)) {
      return MainTabIndex.appointments;
    }
    if (location.startsWith(RouteNames.profile)) return MainTabIndex.profile;
    return MainTabIndex.home;
  }

  void _onBookNow(BuildContext context) {
    GuestGuard.runIfAllowed(context, () => context.push(RouteNames.booking));
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case MainTabIndex.home:
        context.go(RouteNames.home);
      case MainTabIndex.salons:
        context.go(RouteNames.salons);
      case MainTabIndex.appointments:
        context.go(RouteNames.appointments);
      case MainTabIndex.profile:
        context.go(RouteNames.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = ShadTheme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onBookNow(context),
        backgroundColor: primary,
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.calendarPlus, color: Colors.white, size: 22),
            Text(
              l10n.bookNowShort,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border(top: BorderSide(color: theme.colorScheme.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                  icon: LucideIcons.house,
                  label: l10n.home,
                  selected: currentIndex == MainTabIndex.home,
                  onTap: () => _onTap(context, MainTabIndex.home),
                ),
                _NavItem(
                  icon: LucideIcons.store,
                  label: l10n.salons,
                  selected: currentIndex == MainTabIndex.salons,
                  onTap: () => _onTap(context, MainTabIndex.salons),
                ),
                const SizedBox(width: 72),
                _NavItem(
                  icon: LucideIcons.calendar,
                  label: l10n.myAppointments,
                  selected: currentIndex == MainTabIndex.appointments,
                  onTap: () => _onTap(context, MainTabIndex.appointments),
                ),
                _NavItem(
                  icon: LucideIcons.user,
                  label: l10n.account,
                  selected: currentIndex == MainTabIndex.profile,
                  onTap: () => _onTap(context, MainTabIndex.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color =
        selected ? theme.colorScheme.primary : theme.colorScheme.mutedForeground;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected)
              Container(
                width: 28,
                height: 3,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 7),
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.muted.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
