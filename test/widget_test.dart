import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_prak2/models/product.dart';

void main() {
  test('Product model parsing and calculation test', () {
    final sampleJson = {
      'id': 101,
      'title': 'iPhone 13 Pastel Edition',
      'description': 'Smartphone berkualitas tinggi dengan warna pastel.',
      'category': 'smartphones',
      'price': 1000.0,
      'discountPercentage': 10.0,
      'rating': 4.9,
      'stock': 15,
      'tags': ['smartphones', 'apple'],
      'brand': 'Apple',
      'thumbnail': 'https://dummyjson.com/thumb.jpg',
      'images': ['https://dummyjson.com/1.jpg'],
      'reviews': [
        {
          'rating': 5,
          'comment': 'Sangat bagus!',
          'date': '2026-01-01',
          'reviewerName': 'Andi',
          'reviewerEmail': 'andi@mail.com',
        }
      ]
    };

    final product = Product.fromJson(sampleJson);

    expect(product.id, 101);
    expect(product.brandDisplay, 'Apple');
    expect(product.formattedPrice, '\$1000.00');
    expect(product.originalPrice, closeTo(1111.11, 0.01));
    expect(product.reviews.length, 1);
  });
}
