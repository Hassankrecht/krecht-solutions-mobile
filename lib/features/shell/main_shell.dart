import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../home/home_page.dart';
import '../projects/projects_page.dart';
import '../services/services_page.dart';
import '../packages/packages_page.dart';
import '../settings/settings_page.dart';

// Main app shell with top bar, search field, bottom navigation, and tab pages.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const double _topBarHeight = 56;
  static const Color _topBarBackground = Color(0xFF071727);

  int _selectedIndex = 0;
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  static const List<Widget> _pages = [
    HomePage(),
    ProjectsPage(),
    ServicesPage(),
    PackagesPage(),
    SettingsPage(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder_rounded,
      label: 'Projects',
    ),
    _NavItem(
      icon: Icons.miscellaneous_services_outlined,
      activeIcon: Icons.miscellaneous_services_rounded,
      label: 'Services',
    ),
    _NavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
      label: 'Packages',
    ),
    _NavItem(
      icon: Icons.more_horiz_outlined,
      activeIcon: Icons.more_horiz_rounded,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _topBarBackground,
        foregroundColor: AppColors.contrast,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.28),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: _topBarHeight,
        titleSpacing: 18,
        shape: Border(
          bottom: BorderSide(
            color: AppColors.contrast.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isSearchOpen
              ? _InlineSearchField(
                  key: const ValueKey('search-field'),
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onClose: _closeSearch,
                )
              : const _BrandTitle(key: ValueKey('brand-title')),
        ),
        actions: [
          if (!_isSearchOpen)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: _TopBarIconButton(
                tooltip: AppLocalizations.of(context)?.search ?? 'Search',
                icon: Icons.search_rounded,
                onPressed: _openSearch,
              ),
            ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        items: _navItems,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  // Opens the inline search field and moves focus into it.
  void _openSearch() {
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  // Clears and closes the inline search field.
  void _closeSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() => _isSearchOpen = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

// Logo-only brand block shown in the shell app bar.
class _BrandTitle extends StatelessWidget {
  const _BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = width < 360
        ? 132.0
        : width < 600
        ? 148.0
        : 174.0;
    final logoHeight = width < 360 ? 35.0 : 40.0;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        width: logoWidth,
        height: 44,
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: logoWidth,
            height: logoHeight,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              width: logoHeight,
              height: logoHeight,
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.accentBlue.withValues(alpha: 0.42),
                ),
              ),
              child: Icon(
                Icons.auto_awesome_mosaic_rounded,
                color: AppColors.accentBlue,
                size: logoHeight * 0.52,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Compact icon button used in the dark top bar.
class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.contrast.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          hoverColor: AppColors.contrast.withValues(alpha: 0.10),
          splashColor: AppColors.accentBlue.withValues(alpha: 0.18),
          highlightColor: AppColors.contrast.withValues(alpha: 0.06),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(icon, color: AppColors.contrast, size: 20),
          ),
        ),
      ),
    );
  }
}

// Search input shown inside the top app bar.
class _InlineSearchField extends StatelessWidget {
  const _InlineSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClose,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: AppColors.contrast,
        style: const TextStyle(color: AppColors.contrast, fontSize: 14),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(
                context,
              )?.get('searchProjectsServicesPackages') ??
              'Search projects, services, packages',
          hintStyle: TextStyle(
            color: AppColors.contrast.withValues(alpha: 0.68),
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.contrast,
            size: 20,
          ),
          suffixIcon: IconButton(
            tooltip: AppLocalizations.of(context)?.close ?? 'Close search',
            constraints: const BoxConstraints(minWidth: 40, minHeight: 38),
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.contrast,
              size: 20,
            ),
            onPressed: onClose,
          ),
          filled: true,
          fillColor: AppColors.contrast.withValues(alpha: 0.09),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentBlue),
          ),
        ),
      ),
    );
  }
}

// Data holder for one bottom navigation tab.
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

// Bottom navigation container that renders each configured tab.
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(
              items.length,
              (index) => Expanded(
                child: _NavBarItem(
                  item: items[index],
                  isSelected: index == selectedIndex,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// One bottom navigation item with selected/unselected styling.
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accentBlue : AppColors.bodyTextMuted;
    final label = _localizedLabel(context, item.label);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isSelected ? item.activeIcon : item.icon,
              key: ValueKey(isSelected),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 6,
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1 : 0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.accentBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _localizedLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context);
    switch (label) {
      case 'Home':
        return l10n?.home ?? label;
      case 'Projects':
        return l10n?.projects ?? label;
      case 'Services':
        return l10n?.services ?? label;
      case 'Packages':
        return l10n?.packages ?? label;
      case 'More':
        return l10n?.get('more') ?? label;
      default:
        return label;
    }
  }
}
