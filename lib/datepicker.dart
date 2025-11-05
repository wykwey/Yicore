import 'package:flutter/material.dart';
import 'components.dart';

// ================== 日期选择器 ==================
class CustomDatePicker {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<DateTime>? onDateSelected,
  }) async {
    if (!context.mounted) return null;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (_) => _SimpleDatePickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(1900, 1, 1),
        lastDate: lastDate ?? DateTime(2100, 12, 31),
      ),
    );

    if (picked != null) onDateSelected?.call(picked);
    return picked;
  }
}

// ================== 日期选择按钮 ==================
class CustomDatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final String? hintText;
  final String? labelText;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePickerButton({
    this.selectedDate,
    this.hintText,
    this.labelText,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    Key? key,
  }) : super(key: key);

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black.withValues(alpha: 0.85))),
          SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => CustomDatePicker.show(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: firstDate,
            lastDate: lastDate,
            onDateSelected: onDateSelected,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null ? _formatDate(selectedDate!) : (hintText ?? '请选择日期'),
                    style: TextStyle(fontSize: 16, color: selectedDate != null ? Colors.black : Colors.grey[400]),
                  ),
                ),
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================== 自定义样式日期选择对话框 ==================
class _SimpleDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _SimpleDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_SimpleDatePickerDialog> createState() => _SimpleDatePickerDialogState();
}

class _SimpleDatePickerDialogState extends State<_SimpleDatePickerDialog> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final date = widget.initialDate;
    _displayedMonth = DateTime(date.year, date.month);
    _selectedDate = date;
  }

  void _changeMonth(int delta) {
    final newMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    final min = DateTime(widget.firstDate.year, widget.firstDate.month);
    final max = DateTime(widget.lastDate.year, widget.lastDate.month);
    if (newMonth.compareTo(min) < 0 || newMonth.compareTo(max) > 0) return;
    setState(() => _displayedMonth = newMonth);
  }

  bool _inRange(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final min = DateTime(widget.firstDate.year, widget.firstDate.month, widget.firstDate.day);
    final max = DateTime(widget.lastDate.year, widget.lastDate.month, widget.lastDate.day);
    return d.compareTo(min) >= 0 && d.compareTo(max) <= 0;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final monthTitle = '${_displayedMonth.year}年${_displayedMonth.month.toString().padLeft(2, '0')}月';
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final offset = (firstDay.weekday - 1) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);
    const dayHeaders = ['一', '二', '三', '四', '五', '六', '日'];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isSmall ? MediaQuery.of(context).size.width - 32 : 400),
        child: Padding(
          padding: EdgeInsets.all(isSmall ? 8 : 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
                    onPressed: () => _changeMonth(-1),
                    icon: Icon(Icons.chevron_left, size: isSmall ? 20 : 24),
                  ),
                  Expanded(
                    child: Center(child: Text(monthTitle, style: TextStyle(fontSize: isSmall ? 14 : 16))),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
                    onPressed: () => _changeMonth(1),
                    icon: Icon(Icons.chevron_right, size: isSmall ? 20 : 24),
                  ),
                ],
              ),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                mainAxisSpacing: isSmall ? 2 : 4,
                crossAxisSpacing: isSmall ? 2 : 4,
                children: [
                  ...dayHeaders.map((d) => Center(
                    child: Text(d, style: TextStyle(fontWeight: FontWeight.w600, fontSize: isSmall ? 12 : 14)),
                  )),
                  ...List.generate(offset + daysInMonth, (index) {
                    if (index < offset) return const SizedBox();
                    final day = index - offset + 1;
                    final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
                    final isSelected = _isSameDay(_selectedDate, date);
                    final selectable = _inRange(date);
                    return GestureDetector(
                      onTap: selectable ? () => setState(() => _selectedDate = date) : null,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: !selectable 
                                ? Colors.grey[400] 
                                : (isSelected ? Colors.white : Colors.black87),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: isSmall ? 16 : 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: isSmall ? 8 : 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: '取消',
                    isOutlined: true,
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    text: '确定',
                    onPressed: () => Navigator.pop(context, _selectedDate),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
