import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onTasks;
  final VoidCallback onAdd;
  final VoidCallback onSettings;

  const HomeBottomNav({
    super.key,
    required this.onHome,
    required this.onTasks,
    required this.onAdd,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      height: 65,
      color: colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            context: context,
            icon: Icons.home,
            label: 'Home',
            selected: true,
            onTap: onHome,
          ),

          _navItem(
            context: context,
            icon: Icons.checklist,
            label: 'Tasks',
            selected: false,
            onTap: onTasks,
          ),

          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1727A0),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              onPressed: onAdd,
            ),
          ),

          _navItem(
            context: context,
            icon: Icons.settings_outlined,
            label: 'Settings',
            selected: false,
            onTap: onSettings,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? const Color(0xFF1727A0)
                  : colorScheme.onSurfaceVariant,
            ),

            const SizedBox(height: 2),

            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected
                    ? const Color(0xFF1727A0)
                    : colorScheme.onSurfaceVariant,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}