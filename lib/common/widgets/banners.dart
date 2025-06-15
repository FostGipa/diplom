import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController pageController = PageController();
  final List<String> banners = [
    'assets/images/banner_tatneft.jpg',
    'assets/images/banner_dobro.jpg',
  ];
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (currentIndex < banners.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      if (mounted) {
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 190, width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 2),
                  ),],),
              child: PageView.builder(
                controller: pageController, itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });},
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FittedBox(fit: BoxFit.fill,
                      child: Image.asset(banners[index]),
                    ),);},),),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: pageController, count: banners.length,
              effect: WormEffect(
                dotHeight: 8, dotWidth: 8, activeDotColor: Colors.green, dotColor: Colors.grey.shade300,
              ),),],),
      ),
    );
  }
}
