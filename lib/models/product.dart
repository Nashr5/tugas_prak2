class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final double? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Review> reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<String> images;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    required this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Smartphone',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'smartphones',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>)
          : null,
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      availabilityStatus: json['availabilityStatus'] as String?,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      returnPolicy: json['returnPolicy'] as String?,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  // Helpers
  double get originalPrice {
    if (discountPercentage <= 0 || discountPercentage >= 100) return price;
    return price / (1 - (discountPercentage / 100));
  }

  double get savedAmount => originalPrice - price;

  String get brandDisplay {
    if (brand != null && brand!.trim().isNotEmpty) return brand!;
    if (title.toLowerCase().contains('iphone') ||
        title.toLowerCase().contains('apple')) {
      return 'Apple';
    }
    if (title.toLowerCase().contains('samsung') ||
        title.toLowerCase().contains('galaxy')) {
      return 'Samsung';
    }
    if (title.toLowerCase().contains('vivo')) return 'Vivo';
    if (title.toLowerCase().contains('oppo')) return 'Oppo';
    if (title.toLowerCase().contains('realme')) return 'Realme';
    if (tags.isNotEmpty) return tags.first;
    return 'Gadget';
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedOriginalPrice => '\$${originalPrice.toStringAsFixed(2)}';
  String get formattedDiscount => '${discountPercentage.toStringAsFixed(0)}% OFF';
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get formatted => '${width.toStringAsFixed(1)} x ${height.toStringAsFixed(1)} x ${depth.toStringAsFixed(1)} cm';
}

class Review {
  final double rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reviewerName: json['reviewerName'] as String? ?? 'Pembeli Terverifikasi',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }
}

