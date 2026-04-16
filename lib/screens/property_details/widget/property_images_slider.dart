import 'package:dar_plus_app/utils/ui/app_net_image.dart';
import 'package:flutter/material.dart';

class PropertyImagesSlider extends StatefulWidget {
  final List<String> images;

  const PropertyImagesSlider({super.key, required this.images});

  @override
  State<PropertyImagesSlider> createState() => _PropertyImagesSliderState();
}

class _PropertyImagesSliderState extends State<PropertyImagesSlider> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    if (images.isEmpty) {
      return Container(color: Colors.grey.shade200);
    }

    if (images.length == 1) {
      return AppNetImage(url: images.first, fit: BoxFit.cover);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: images.length,
          physics: const PageScrollPhysics(),
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            return AppNetImage(url: images[i], fit: BoxFit.cover);
          },
        ),

        // Indicators
        Positioned(
          left: 0,
          right: 0,
          bottom: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white.withAlpha(130),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
