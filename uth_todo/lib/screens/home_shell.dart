import 'package:flutter/material.dart';

import '../services/task_api.dart';
import '../services/task_store.dart';
import '../theme/app_colors.dart';
import '../widgets/add_todo_sheet.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'task_list_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.guest = false});

  final bool guest;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    TaskStore.instance.refresh();
  }

  Future<void> _addTodo() async {
    final result = await showAddTodoSheet(context);
    if (result == null || !mounted) return;
    try {
      await TaskApi.instance.createTask(
        title: result.title,
        category: result.category,
        time: result.time,
      );
      await TaskStore.instance.refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi POST /mock/teach/tasks'),
          backgroundColor: AppColors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không lưu được: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(guest: widget.guest),
      TaskListScreen(guest: widget.guest),
      NotificationsScreen(guest: widget.guest),
      ProfileScreen(guest: widget.guest, embedded: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: AppColors.purple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Trang chủ',
                selected: _index == 0,
                onTap: () => setState(() => _index = 0),
              ),
              _NavItem(
                icon: Icons.list_alt_rounded,
                label: 'Danh sách',
                selected: _index == 1,
                onTap: () => setState(() => _index = 1),
              ),
              const SizedBox(width: 40),
              _NavItem(
                icon: Icons.notifications_none_rounded,
                label: 'Thông báo',
                selected: _index == 2,
                onTap: () => setState(() => _index = 2),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Cài đặt',
                selected: _index == 3,
                onTap: () => setState(() => _index = 3),
              ),
            ],
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
    final color = selected ? AppColors.purple : AppColors.muted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}
