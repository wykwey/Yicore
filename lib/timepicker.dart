import 'package:flutter/material.dart';
import 'components.dart';

// ================== 时间范围选择（底部弹窗） ==================
class TimeRange {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  const TimeRange({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  String format() =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}-${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
}

class CustomTimeRangePicker {
  static Future<TimeRange?> show({
    required BuildContext context,
    TimeRange? initial,
  }) async {
    if (!context.mounted) return null;

    final result = await showModalBottomSheet<TimeRange>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheetContext) {
        return _TimeRangeSheet(initial: initial);
      },
    );
    return result;
  }
}

class _TimeRangeSheet extends StatefulWidget {
  final TimeRange? initial;
  const _TimeRangeSheet({this.initial});

  @override
  State<_TimeRangeSheet> createState() => _TimeRangeSheetState();
}

class _TimeRangeSheetState extends State<_TimeRangeSheet> {
  static const double _itemExtent = 44;
  static const double _visibleCount = 7; // 上下各3个 + 中间1个

  late FixedExtentScrollController _sh;
  late FixedExtentScrollController _sm;
  late FixedExtentScrollController _eh;
  late FixedExtentScrollController _em;

  int _startHour = 9;
  int _startMinute = 0;
  int _endHour = 10;
  int _endMinute = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _startHour = widget.initial!.startHour;
      _startMinute = widget.initial!.startMinute;
      _endHour = widget.initial!.endHour;
      _endMinute = widget.initial!.endMinute;
    }
    _sh = FixedExtentScrollController(initialItem: _startHour);
    _sm = FixedExtentScrollController(initialItem: _startMinute);
    _eh = FixedExtentScrollController(initialItem: _endHour);
    _em = FixedExtentScrollController(initialItem: _endMinute);
  }

  @override
  void dispose() {
    _sh.dispose();
    _sm.dispose();
    _eh.dispose();
    _em.dispose();
    super.dispose();
  }

  Widget _wheel({
    required int count,
    required FixedExtentScrollController controller,
    required ValueChanged<int> onSelected,
  }) {
    return SizedBox(
      height: _itemExtent * _visibleCount, 
      width: 72,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= count) return null;
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            );
          },
          childCount: count,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  text: '取消',
                  isOutlined: true,
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                const Text('选择时间范围', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                CustomButton(
                  text: '确定',
                  onPressed: () {
                    final startTotal = _startHour * 60 + _startMinute;
                    final endTotal = _endHour * 60 + _endMinute;
                    int eh = _endHour;
                    int em = _endMinute;
                    if (endTotal < startTotal) {
                      eh = _startHour;
                      em = _startMinute;
                    }
                    Navigator.pop(
                      context,
                      TimeRange(
                        startHour: _startHour,
                        startMinute: _startMinute,
                        endHour: eh,
                        endMinute: em,
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _wheel(count: 24, controller: _sh, onSelected: (i) => _startHour = i),
                const Text(':', style: TextStyle(fontSize: 18)),
                _wheel(count: 60, controller: _sm, onSelected: (i) => _startMinute = i),
                const SizedBox(width: 16),
                const Text('-', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 16),
                _wheel(count: 24, controller: _eh, onSelected: (i) => _endHour = i),
                const Text(':', style: TextStyle(fontSize: 18)),
                _wheel(count: 60, controller: _em, onSelected: (i) => _endMinute = i),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


