import 'package:flutter/material.dart';

// ================== 悬浮窗菜单项 ==================
class YicoreFloatingActionMenuItem {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const YicoreFloatingActionMenuItem({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
  });
}

// ================== 悬浮窗按钮 ==================
class YicoreFab extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final List<YicoreFloatingActionMenuItem>? menuItems;
  final double size;
  final bool draggable;

  const YicoreFab({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.menuItems,
    this.size = 56.0,
    this.draggable = true,
    Key? key,
  }) : super(key: key);

  @override
  State<YicoreFab> createState() => _YicoreFabState();
}

class _YicoreFabState extends State<YicoreFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  Offset _position = const Offset(24, 24); // 初始位置（右下角）

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45度
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (widget.menuItems == null || widget.menuItems!.isEmpty) {
      widget.onPressed?.call();
      return;
    }
    
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final expandedHeight = widget.menuItems != null && widget.menuItems!.isNotEmpty
        ? widget.size * (widget.menuItems!.length + 1) + 16 * widget.menuItems!.length
        : widget.size;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 菜单项（从下往上排列，从最后一个开始）
        if (_isExpanded && widget.menuItems != null && widget.menuItems!.isNotEmpty)
          ...widget.menuItems!.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMenuItem(item, index),
            );
          }).toList(),
        // 主按钮
        GestureDetector(
          onPanUpdate: widget.draggable
              ? (details) {
                  setState(() {
                    final newX = _position.dx - details.delta.dx;
                    final newY = _position.dy - details.delta.dy;
                    
                    // 限制在屏幕边界内
                    final minX = 0.0;
                    final maxX = screenSize.width - widget.size;
                    final minY = 0.0;
                    final maxY = screenSize.height - expandedHeight;
                    
                    _position = Offset(
                      newX.clamp(minX, maxX),
                      newY.clamp(minY, maxY),
                    );
                  });
                }
              : null,
          child: _buildMainButton(),
        ),
      ],
    );

    // 如果可拖动，使用 Stack + Positioned 进行定位
    if (widget.draggable) {
      return Stack(
        children: [
          Positioned(
            right: _position.dx,
            bottom: _position.dy,
            child: content,
          ),
        ],
      );
    }

    // 如果不可拖动，直接返回内容（适合在常规布局中使用）
    return content;
  }

  Widget _buildMainButton() {
    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleMenu,
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(
              _isExpanded ? Icons.close : widget.icon,
              color: Colors.black.withValues(alpha: 0.85),
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty && !_isExpanded) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  Widget _buildMenuItem(YicoreFloatingActionMenuItem item, int index) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            item.onPressed?.call();
            _closeMenu();
          },
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: item.backgroundColor ?? Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              color: Colors.black.withValues(alpha: 0.85),
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

