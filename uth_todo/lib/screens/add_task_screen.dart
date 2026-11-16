import 'package:flutter/material.dart';

import '../models/teach_task.dart';
import '../services/task_store.dart';
import '../theme/app_colors.dart';
import '../viewmodels/add_task_viewmodel.dart';

/// Màn hình "Việc mới" theo mô hình MVVM.
///
/// View chỉ render từ [AddTaskViewModel] và chuyển thao tác người dùng
/// xuống ViewModel; việc gọi API nằm trong ViewModel.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _vm = AddTaskViewModel();
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _vm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final created = await _vm.save();
    if (created == null) return;
    await TaskStore.instance.refresh();
    if (!mounted) return;
    Navigator.of(context).pop<TeachTask>(created);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _vm.time,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) _vm.setTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: [
                      _buildField(
                        label: 'Tên công việc',
                        hint: 'Ví dụ: Ôn chương 4 – Giải thuật',
                        controller: _titleCtrl,
                        autofocus: true,
                        onChanged: _vm.setTitle,
                      ),
                      const SizedBox(height: 10),
                      _buildField(
                        label: 'Ghi chú',
                        hint: 'Thêm ghi chú (không bắt buộc)',
                        controller: _noteCtrl,
                        maxLines: 3,
                        onChanged: _vm.setNote,
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('Nhóm'),
                      Row(
                        children: [
                          for (final option in AddTaskViewModel.categories) ...[
                            Expanded(
                              child: _OutlinedOption(
                                label: option.label,
                                selected: _vm.category == option.id,
                                onTap: () => _vm.setCategory(option.id),
                              ),
                            ),
                            if (option != AddTaskViewModel.categories.last)
                              const SizedBox(width: 10),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('Ngày'),
                      Row(
                        children: [
                          for (final option in AddTaskViewModel.dateOptions) ...[
                            Expanded(
                              child: _OutlinedOption(
                                label: option.label,
                                selected: _vm.dateOption == option.id,
                                onTap: () => _vm.setDateOption(option.id),
                                compact: true,
                              ),
                            ),
                            if (option != AddTaskViewModel.dateOptions.last)
                              const SizedBox(width: 8),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildScheduleCard(),
                      const SizedBox(height: 20),
                      _sectionLabel('Mức ưu tiên'),
                      _buildPrioritySelector(),
                      if (_vm.error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _vm.error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildSaveBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          TextButton(
            onPressed: _vm.saving ? null : () => Navigator.of(context).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppColors.purple, fontSize: 15),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Việc mới',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _vm.canSave ? _save : null,
            child: Text(
              'Lưu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _vm.canSave ? AppColors.purple : AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    bool autofocus = false,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          TextField(
            controller: controller,
            autofocus: autofocus,
            maxLines: maxLines,
            textInputAction: maxLines > 1
                ? TextInputAction.newline
                : TextInputAction.next,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 15, color: AppColors.text),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFB4B4C2),
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _vm.saving ? null : _pickTime,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: AppColors.purple,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Giờ',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    _vm.timeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: AppColors.purple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nhắc tôi',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _vm.remind ? 'Trước 15 phút' : 'Không nhắc',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _vm.remind,
                  onChanged: _vm.saving ? null : _vm.setRemind,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDECF3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final option in AddTaskViewModel.priorities)
            Expanded(
              child: GestureDetector(
                onTap: _vm.saving ? null : () => _vm.setPriority(option.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _vm.priority == option.id
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: _vm.priority == option.id
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _vm.priority == option.id
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _vm.priority == option.id
                          ? AppColors.text
                          : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSaveBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      color: AppColors.background,
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: _vm.canSave ? _save : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFE7E5F0),
            disabledForegroundColor: AppColors.muted,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            _vm.saving ? 'Đang lưu...' : 'Lưu công việc',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _OutlinedOption extends StatelessWidget {
  const _OutlinedOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: compact ? 40 : 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.purpleSoft : Colors.white,
          borderRadius: BorderRadius.circular(compact ? 10 : 12),
          border: Border.all(
            color: selected ? AppColors.purple : const Color(0xFFE4E3EC),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.purple : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
