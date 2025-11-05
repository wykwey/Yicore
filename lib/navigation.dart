import 'package:flutter/material.dart';

// ================== 底部导航项 ==================
class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.icon,
    required this.label,
  });
}

// ================== 自定义底部导航栏 ==================
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          BottomNavItem item = entry.value;
          bool isSelected = index == currentIndex;

          return Expanded(
            child: _NavItem(
              item: item,
              isSelected: isSelected,
              onTap: () => onTap(index),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ================== 导航项组件（带动画） ==================
class _NavItem extends StatefulWidget {
  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: widget.isSelected ? 1.0 : 0.0),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      Colors.transparent,
                      Colors.black,
                      value,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: 0.0, end: widget.isSelected ? 1.0 : 0.0),
                    curve: Curves.easeInOut,
                    builder: (context, scaleValue, child) {
                      return Transform.scale(
                        scale: 0.8 + (scaleValue * 0.2),
                        child: Icon(
                          widget.item.icon,
                          size: 20,
                          color: Color.lerp(
                            Colors.grey[600],
                            Colors.white,
                            value,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 3),
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: widget.isSelected ? 1.0 : 0.0),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 13 + (value * 1.0),
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
