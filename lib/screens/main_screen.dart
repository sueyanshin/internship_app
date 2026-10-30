import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/screens/applications_screen.dart';
import 'package:job_app/screens/home_screen.dart';
import 'package:job_app/screens/notifications_screen.dart';
import 'package:job_app/screens/profile_screen.dart';
import 'package:job_app/screens/providers/bottom_nav_provider.dart';
import 'package:job_app/screens/search_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  new({super.key});
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    ApplicationsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomNavProvider>(
        builder: (context, navProvider, child) =>
            _screens[navProvider.currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, value, child) {
        return Container(
          height: 88,
          padding: .symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .only(
              topLeft: .circular(12),
              topRight: .circular(12),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              CustomNavItem(
                selectedIcon: Icons.home_rounded,
                unselectedIcon: Icons.home_outlined,
                label: 'Home',
                index: 0,
              ),
              CustomNavItem(
                selectedIcon: Icons.search_rounded,
                unselectedIcon: Icons.search_outlined,
                label: 'Search',
                index: 1,
              ),
              CustomNavItem(
                selectedIcon: Icons.description_rounded,
                unselectedIcon: Icons.description_outlined,
                label: 'Applications',
                index: 2,
              ),
              CustomNavItem(
                selectedIcon: Icons.notifications_rounded,
                unselectedIcon: Icons.notifications_none,
                label: 'Notifications',
                index: 3,
              ),
              CustomNavItem(
                selectedIcon: Icons.person_rounded,
                unselectedIcon: Icons.person_outline_rounded,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomNavItem extends StatelessWidget {
  const new({
    super.key,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.index,
  });

  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navProvider = context.read<BottomNavProvider>();
    final bool isSelected = index == navProvider.currentIndex;
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.textSecondary;

    return Column(
      mainAxisAlignment: .center,
      children: [
        IconButton(
          onPressed: () {
            navProvider.changeIndex(index);
          },
          isSelected: isSelected,
          enableFeedback: false,
          icon: Icon(
            isSelected ? selectedIcon : unselectedIcon,
            size: 30,
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelMedium!.copyWith(
            color: isSelected ? activeColor : inactiveColor,
            fontWeight: isSelected ? .bold : .w500,
          ),
        ),
      ],
    );
  }
}
