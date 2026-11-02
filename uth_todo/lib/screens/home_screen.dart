import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import '../services/auth_service.dart';
import '../services/todo_service.dart';
import '../theme/app_colors.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.guest = false});

  final bool guest;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final fullName = guest ? 'Khách' : (user?.displayName ?? 'Người dùng');
    final firstName = fullName.split(' ').first;
    final initials = _initials(fullName);

    if (guest) {
      return _buildBody(
        context,
        fullName: fullName,
        firstName: firstName,
        initials: initials,
        photoUrl: null,
        todos: const [],
        guestBanner: true,
      );
    }

    return StreamBuilder<List<TodoItem>>(
      stream: TodoService.instance.watchTodos(),
      builder: (context, snapshot) {
        final todos = snapshot.data ?? const <TodoItem>[];
        return _buildBody(
          context,
          fullName: fullName,
          firstName: firstName,
          initials: initials,
          photoUrl: user?.photoURL,
          todos: todos,
          loading: snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData,
          error: snapshot.hasError ? snapshot.error.toString() : null,
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required String fullName,
    required String firstName,
    required String initials,
    required String? photoUrl,
    required List<TodoItem> todos,
    bool guestBanner = false,
    bool loading = false,
    String? error,
  }) {
    final doneCount = todos.where((t) => t.done).length;
    final total = todos.length;
    final studyLeft =
        todos.where((t) => t.category == 'Học tập' && !t.done).length;
    final lifeLeft =
        todos.where((t) => t.category == 'Cuộc sống' && !t.done).length;
    final progress = total == 0 ? 0.0 : doneCount / total;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(guest: guest),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.purple,
                  backgroundImage:
                      !guest && photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: guest || photoUrl == null
                      ? Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todayLabel(),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Chào $firstName!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.cloud_done_outlined, color: AppColors.purple),
            ],
          ),
          if (guestBanner) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Chế độ khách: đăng nhập Google để lưu việc lên Firestore và dùng Storage / Messaging.',
                style: TextStyle(color: Color(0xFFF39C12), fontSize: 13),
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(
              'Firestore: $error',
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiến độ hôm nay',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loading ? '…' : '$doneCount/$total việc',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: loading ? null : progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                      Center(
                        child: Text(
                          loading
                              ? ''
                              : '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _CategoryCard(
                  title: 'Học tập',
                  subtitle: '$studyLeft việc còn lại',
                  color: AppColors.cardStudy,
                  icon: Icons.menu_book_rounded,
                  iconColor: AppColors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CategoryCard(
                  title: 'Cuộc sống',
                  subtitle: '$lifeLeft việc còn lại',
                  color: AppColors.cardLife,
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Việc hôm nay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (todos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Chưa có việc. Nhấn + để thêm lên Firestore.',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          else
            ...todos.map(
              (t) => _TaskCard(
                title: t.title,
                category: t.category,
                time: t.time,
                done: t.done,
                onToggle: guest
                    ? null
                    : () => TodoService.instance.toggleDone(t),
              ),
            ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  static String _todayLabel() {
    const weekdays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${now.day} tháng ${now.month}';
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.title,
    required this.category,
    required this.time,
    required this.done,
    this.onToggle,
  });

  final String title;
  final String category;
  final String time;
  final bool done;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? AppColors.purple : AppColors.muted,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: done ? TextDecoration.lineThrough : null,
                    color: done ? AppColors.muted : AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purpleSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: AppColors.purple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
