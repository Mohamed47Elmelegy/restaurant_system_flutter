import '../models/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> get onboardingScreens => [
    OnboardingModel(
      title: 'Welcome to Our Restaurant',
      description:
          'Discover delicious meals prepared by our expert chefs with the finest ingredients and authentic recipes.',
      imagePath: 'assets/images/Chef-bro.svg',
    ),
    OnboardingModel(
      title: 'Easy Food Ordering',
      description:
          'Order your favorite dishes with just a few taps. Fast, convenient, and hassle-free ordering experience.',
      imagePath: 'assets/images/Order food-bro.svg',
    ),
    OnboardingModel(
      title: 'Fast Delivery',
      description:
          'Get your food delivered to your doorstep in no time. Fresh, hot, and ready to enjoy.',
      imagePath: 'assets/images/Chef-bro.svg',
    ),
  ];
}
