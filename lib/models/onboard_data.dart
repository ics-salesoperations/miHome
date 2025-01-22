class OnBoarding {
  final String title;
  final String image;

  OnBoarding({
    required this.title,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Bienvenido a \n Mi Home',
    image: 'assets/images/onboarding_image_1.png',
  ),
  OnBoarding(
    title: 'Sé puntual en tus visitas',
    image: 'assets/images/onboarding_image_2.png',
  ), /*
  OnBoarding(
    title: 'ES PARTE DE TU RENDIMIENTO SEMANAL',
    image: 'assets/images/onboarding_image_3.png',
  ),
  OnBoarding(
    title: 'DISFRUTA DE TU APP Mi Home',
    image: 'assets/images/onboarding_image_4.png',
  ),*/
];
