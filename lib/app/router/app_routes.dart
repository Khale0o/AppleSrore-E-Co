abstract final class AppRoutes {
  static const splash = 'splash',
      home = 'home',
      catalog = 'catalog',
      product = 'product',
      configure = 'configure',
      checkout = 'checkout',
      cart = 'cart',
      saved = 'saved',
      profile = 'profile';
  static const splashPath = '/',
      homePath = '/home',
      catalogPath = '/catalog',
      productPath = '/product/:productId',
      configurePath = '/product/:productId/configure',
      checkoutPath = '/checkout',
      cartPath = '/cart',
      savedPath = '/saved',
      profilePath = '/profile';
}
