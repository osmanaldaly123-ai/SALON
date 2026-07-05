import '../../../features/deals/domain/entities/deal.dart';
import '../../../features/reviews/domain/entities/review.dart';
import '../../../features/salons/domain/entities/salon.dart';
import '../../../features/services/domain/entities/service.dart';

/// Demo content for guest browsing without a backend API.
class DemoData {
  DemoData._();

  static const _salons = [
    Salon(
      id: 'demo-1',
      name: 'صالون الأناقة',
      description: 'صالون نسائي متكامل للعناية بالشعر والبشرة',
      imageUrl: 'https://picsum.photos/seed/salon1/400/300',
      rating: 4.8,
      address: 'حي النخيل، الرياض',
      distance: 1.2,
    ),
    Salon(
      id: 'demo-2',
      name: 'Glow Beauty',
      description: 'Premium beauty and wellness studio',
      imageUrl: 'https://picsum.photos/seed/salon2/400/300',
      rating: 4.6,
      address: 'Al Olaya, Riyadh',
      distance: 2.5,
    ),
    Salon(
      id: 'demo-3',
      name: 'صالون لمسة فنية',
      description: 'مكياج، أظافر، وعناية بالبشرة',
      imageUrl: 'https://picsum.photos/seed/salon3/400/300',
      rating: 4.9,
      address: 'حي الملقا، الرياض',
      distance: 3.1,
    ),
  ];

  static const _services = [
    Service(
      id: 'svc-1',
      salonId: 'demo-1',
      name: 'قص وتصفيف',
      description: 'قص شعر مع تصفيف احترافي',
      price: 120,
      durationMinutes: 45,
      imageUrl: 'https://picsum.photos/seed/svc1/200/200',
    ),
    Service(
      id: 'svc-2',
      salonId: 'demo-1',
      name: 'صبغة كاملة',
      description: 'صبغة شعر مع علاج',
      price: 250,
      durationMinutes: 90,
      imageUrl: 'https://picsum.photos/seed/svc2/200/200',
    ),
    Service(
      id: 'svc-3',
      salonId: 'demo-2',
      name: 'Facial Treatment',
      description: 'Deep cleansing facial',
      price: 180,
      durationMinutes: 60,
      imageUrl: 'https://picsum.photos/seed/svc3/200/200',
    ),
    Service(
      id: 'svc-4',
      salonId: 'demo-3',
      name: 'مكياج سهرة',
      description: 'مكياج كامل للمناسبات',
      price: 200,
      durationMinutes: 75,
      imageUrl: 'https://picsum.photos/seed/svc4/200/200',
    ),
  ];

  static const _deals = [
    Deal(
      id: 'deal-1',
      salonId: 'demo-1',
      title: 'خصم 30% على الصبغة',
      description: 'عرض محدود هذا الأسبوع',
      discountPercent: 30,
      imageUrl: 'https://picsum.photos/seed/deal1/400/200',
      validUntil: null,
    ),
    Deal(
      id: 'deal-2',
      salonId: 'demo-2',
      title: '20% Off First Visit',
      description: 'New customers welcome offer',
      discountPercent: 20,
      imageUrl: 'https://picsum.photos/seed/deal2/400/200',
      validUntil: null,
    ),
  ];

  static const _reviews = [
    Review(
      id: 'rev-1',
      salonId: 'demo-1',
      userName: 'سارة',
      rating: 5,
      comment: 'خدمة ممتازة ومو staff محترف جداً',
      createdAt: null,
    ),
    Review(
      id: 'rev-2',
      salonId: 'demo-1',
      userName: 'Noura',
      rating: 4.5,
      comment: 'Great experience, will come again',
      createdAt: null,
    ),
  ];

  static List<Salon> getSalons({String? query}) {
    if (query == null || query.trim().isEmpty) return List.unmodifiable(_salons);
    final q = query.trim().toLowerCase();
    return _salons
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              (s.address?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  static Salon getSalonById(String id) =>
      _salons.firstWhere((s) => s.id == id, orElse: () => _salons.first);

  static List<Service> getServices({String? salonId}) {
    if (salonId == null) return List.unmodifiable(_services);
    return _services.where((s) => s.salonId == salonId).toList();
  }

  static List<Deal> getDeals({String? salonId}) {
    if (salonId == null) return List.unmodifiable(_deals);
    return _deals.where((d) => d.salonId == salonId).toList();
  }

  static List<Review> getReviews(String salonId) =>
      _reviews.where((r) => r.salonId == salonId).toList();
}
