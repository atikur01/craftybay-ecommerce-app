class Urls {
  static const String _baseUrl = 'https://ecom-rs8e.onrender.com/api';

  static const String signUpUrl = '$_baseUrl/auth/signup';
  static const String verifyOtpUrl = '$_baseUrl/auth/verify-otp';
  static const String resendOtpUrl = '$_baseUrl/auth/resend-otp';
  static const String signInUrl = '$_baseUrl/auth/login';
  static const String profileUrl = '$_baseUrl/auth/profile';
  static const String homeSlidersUrl = '$_baseUrl/slides';

  static String categoryListUrl(int pageNo, int count) =>
      '$_baseUrl/categories?count=$count&page=$pageNo';

  static String brandListUrl(int pageNo, int count) =>
      '$_baseUrl/brands?count=$count&page=$pageNo';

  static String readBrandUrl(String brandId) => '$_baseUrl/brands/$brandId';

  static String productListUrl(
    int currentPage,
    int productsPerPage, {
    String? tag,
    String? remark,
    String? categoryId,
    String? brandId,
  }) {
    String url = '$_baseUrl/products?count=$productsPerPage&page=$currentPage';
    if (tag != null && tag.isNotEmpty) {
      url += '&tag=$tag';
    }
    if (remark != null && remark.isNotEmpty) {
      url += '&remark=$remark';
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      url += '&category=$categoryId';
    }
    if (brandId != null && brandId.isNotEmpty) {
      url += '&brand=$brandId';
    }
    return url;
  }

  static String wishlistUrl(int currentPage, int productsPerPage) =>
      '$_baseUrl/wishlist?count=$productsPerPage&page=$currentPage';

  static const String addToWishlistUrl = '$_baseUrl/wishlist';

  static String deleteWishlistUrl(String wishlistId) =>
      '$_baseUrl/wishlist/$wishlistId';

  static String productDetailsUrl(String productId) =>
      '$_baseUrl/products/id/$productId';

  static const String addToCartUrl = '$_baseUrl/cart';
  static const String cartListUrl = '$_baseUrl/cart';

  static String reviewListUrl(String productId) =>
      '$_baseUrl/reviews?product=$productId';

  static const String createReviewUrl = '$_baseUrl/review';
}
