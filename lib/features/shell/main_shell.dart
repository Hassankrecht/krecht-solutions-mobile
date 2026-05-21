import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../home/home_page.dart';
import '../projects/projects_page.dart';
import '../services/services_page.dart';
import '../packages/packages_page.dart';
import '../settings/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
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
        backgroundColor: AppColors.darkNavy,
        titleSpacing: 16,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
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
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search_rounded, color: AppColors.contrast),
              onPressed: _openSearch,
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

  void _openSearch() {
    setState(() => _isSearchOpen = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

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

class _BrandTitle extends StatelessWidget {
  const _BrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.4),
            ),
          ),
          child: const Icon(
            Icons.auto_awesome_mosaic_rounded,
            color: AppColors.accentBlue,
            size: 19,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: AppTextStyles.logoText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
              children: const [
                TextSpan(text: 'Krecht'),
                TextSpan(
                  text: ' Solutions',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
      height: 42,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: AppColors.contrast,
        style: const TextStyle(color: AppColors.contrast, fontSize: 14),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search projects, services, packages',
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
            tooltip: 'Close search',
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.contrast,
              size: 20,
            ),
            onPressed: onClose,
          ),
          filled: true,
          fillColor: AppColors.contrast.withValues(alpha: 0.12),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 2),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.accentBlue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
