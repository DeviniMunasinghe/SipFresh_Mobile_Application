import 'package:flutter/material.dart';

class ProductImage extends StatefulWidget {
  final List<String> imagePaths;
  final ValueChanged<int>? onImageChanged;

  const ProductImage({
    super.key,
    required this.imagePaths,
    this.onImageChanged,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousPage() {
    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) prevIndex = widget.imagePaths.length - 1;
    _pageController.animateToPage(
      prevIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _nextPage() {
    int nextIndex = _currentIndex + 1;
    if (nextIndex >= widget.imagePaths.length) nextIndex = 0;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });

              if (widget.onImageChanged != null) {
                widget.onImageChanged!(index);
              }
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Image not available'));
                    },
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.imagePaths.length > 1)
          Positioned(
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.green, size: 30),
              onPressed: _previousPage,
            ),
          ),
        if (widget.imagePaths.length > 1)
          Positioned(
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 30),
              onPressed: _nextPage,
            ),
          ),
      ],
    );
  }
}
