abstract final class AppRoutes {
  static const splash = 'splash',
      home = 'home',
      catalog = 'catalog',
      product = 'product',
      configure = 'configure',
      cart = 'cart';
  static const splashPath = '/',
      homePath = '/home',
      catalogPath = '/catalog',
      productPath = '/product/:productId',
      configurePath = '/product/:productId/configure',
      cartPath = '/cart';
}
