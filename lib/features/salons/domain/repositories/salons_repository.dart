import '../entities/salon.dart';

abstract class SalonsRepository {
  Future<List<Salon>> getSalons({String? query});
  Future<Salon> getSalonById(String id);
}
