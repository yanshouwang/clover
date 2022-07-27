import 'package:flutter/widgets.dart';

class VisibilityChanger extends StatefulWidget {
  final Key tapKey;
  final Widget child;
  final bool visible;

  const VisibilityChanger({
    Key? key,
    required this.tapKey,
    required this.child,
    this.visible = true,
  }) : super(key: key);

  @override
  State<VisibilityChanger> createState() => _VisibilityChangerState();
}

class _VisibilityChangerState extends State<VisibilityChanger> {
  late ValueNotifier<bool> visible;

  @override
  void initState() {
    super.initState();
    visible = ValueNotifier(widget.visible);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (context, visible, child) {
            return Visibility(
              visible: visible,
              child: widget.child,
            );
          },
        ),
        GestureDetector(
          onTap: () => visible.value = !visible.value,
          child: Text(
            'Change Visibility',
            key: widget.tapKey,
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    visible.dispose();
    super.dispose();
  }
}
