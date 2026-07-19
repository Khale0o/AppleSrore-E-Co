abstract final class AppRoutes {
  static const splash = 'splash',
      home = 'home',
      catalog = 'catalog',
      product = 'product',
      configure = 'configure',
      cart = 'cart',
      saved = 'saved',
      profile = 'profile';
  static const splashPath = '/',
      homePath = '/home',
      catalogPath = '/catalog',
      productPath = '/product/:productId',
      configurePath = '/product/:productId/configure',
      cartPath = '/cart',
      savedPath = '/saved',
      profilePath = '/profile';
}
