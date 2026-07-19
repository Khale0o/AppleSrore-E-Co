abstract final class AppRoutes {
  static const splash = 'splash',
      onboarding = 'onboarding',
      home = 'home',
      catalog = 'catalog',
      product = 'product',
      configure = 'configure',
      checkout = 'checkout',
      cart = 'cart',
      saved = 'saved',
      profile = 'profile';
  static const splashPath = '/',
      onboardingPath = '/onboarding',
      homePath = '/home',
      catalogPath = '/catalog',
      productPath = '/product/:productId',
      configurePath = '/product/:productId/configure',
      checkoutPath = '/checkout',
      cartPath = '/cart',
      savedPath = '/saved',
      profilePath = '/profile';
}
