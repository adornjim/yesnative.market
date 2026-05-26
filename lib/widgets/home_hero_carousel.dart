import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_spacing.dart';

class HomeHeroCarousel extends StatefulWidget {
  const HomeHeroCarousel({super.key});

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/hero_1.jpg',
      'label': 'Welcome to Yes Native',
      'title': 'Where tradition meets modern wellness.',
    },
    {
      'image': 'assets/images/hero_2.jpg',
      'label': 'Fuel Your Day, Naturally',
      'title': 'Clean energy for every lifestyle.',
    },
    {
      'image': 'assets/images/hero_3.jpg',
      'label': 'Made for Every Family',
      'title': "There's a Yes Native for everyone.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int next = _pageController.page!.round() + 1;
        if (next >= _slides.length) {
          next = 0;
          _pageController.animateToPage(next, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
        } else {
          _pageController.nextPage(duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    slide['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide['label']!,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            letterSpacing: 2,
                          ),
                        ).animate().fadeIn().slideX(),
                        AppSpacing.gapVsm,
                        Text(
                          slide['title']!,
                          style: Theme.of(context).textTheme.displaySmall,
                        ).animate().fadeIn(delay: 200.ms).slideX(),
                        AppSpacing.gapVlg,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.go('/shop'),
                                child: const Text('Shop Products'),
                              ),
                            ),
                            AppSpacing.gapHmd,
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.go('/wellness'),
                                child: const Text('Explore Wellness'),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Colors.grey.shade400,
                  dotHeight: 6,
                  dotWidth: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
