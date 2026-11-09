import 'package:flutter/material.dart';

import '../models/teach_task.dart';
import '../services/task_store.dart';
import '../theme/app_colors.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, this.guest = false});

  final bool guest;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _query = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TaskStore.instance,
      builder: (context, _) {
        final store = TaskStore.instance;
        var items = store.tasks;
        if (_category != null) {
          items = items.where((t) => t.category == _category).toList();
        }
        if (_query.trim().isNotEmpty) {
          final q = _query.trim().toLowerCase();
          items = items
              .where((t) => t.title.toLowerCase().contains(q))
              .toList();
        }

        final leftover = items.where((t) => !t.done).length;
        final grouped = <String, List<TeachTask>>{};
        for (final item in items) {
          grouped.putIfAbsent(item.date, () => []).add(item);
        }
        final dates = grouped.keys.toList()..sort();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Danh sách',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  store.loading
                      ? 'Đang tải từ API...'
                      : '$leftover việc chưa xong',
                  style: const TextStyle(color: AppColors.muted),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm công việc',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: _category == null,
                      onSelected: (_) => setState(() => _category = null),
                    ),
                    ChoiceChip(
                      label: const Text('Học tập'),
                      selected: _category == 'study',
                      onSelected: (_) => setState(() => _category = 'study'),
                    ),
                    ChoiceChip(
                      label: const Text('Cuộc sống'),
                      selected: _category == 'life',
                      onSelected: (_) => setState(() => _category = 'life'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: store.loading && store.tasks.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : store.error != null && store.tasks.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                store.error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          )
                        : items.isEmpty
                            ? const Center(
                                child: Text(
                                  'Không có việc phù hợp.',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: TaskStore.instance.refresh,
                                child: ListView(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                                  children: [
                                    for (final date in dates) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.text,
                                          ),
                                        ),
                                      ),
                                      ...grouped[date]!.map(
                                        (item) => Dismissible(
                                          key: ValueKey(item.id),
                                          direction: DismissDirection.endToStart,
                                          background: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 20),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onDismissed: (_) {
                                            TaskStore.instance.remove(item.id);
                                          },
                                          child: _TodoTile(item: item),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TodoTile extends StatelessWidget {
  const _TodoTile({required this.item});

  final TeachTask item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(taskId: item.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => TaskStore.instance.toggleDone(item),
              icon: Icon(
                item.done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: item.done ? AppColors.purple : AppColors.muted,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: item.done ? TextDecoration.lineThrough : null,
                      color: item.done ? AppColors.muted : AppColors.text,
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
                          item.categoryLabel,
                          style: const TextStyle(
                            color: AppColors.purple,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
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
            const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
