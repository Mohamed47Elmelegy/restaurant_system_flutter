import '../base/base_entity.dart';
import '../../features/admin/presentation/pages/meal_times/domain/entities/meal_time.dart';

/// 🟦 MainCategory Entity - مبدأ المسؤولية الواحدة (SRP)
/// مسؤول عن تمثيل فئة رئيسية في الأعمال فقط
class CategoryEntity extends BaseEntity {
  final String name;
  final String? icon;
  final String? color;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final int? productsCount;
  final List<MealTime>? mealTimes;

  const CategoryEntity({
    required super.id,
    required this.name,

    this.icon,
    this.color,
    this.description,
    required this.isActive,
    required this.sortOrder,
    super.createdAt,
    super.updatedAt,
    this.productsCount,
    this.mealTimes,
  });

  /// Constructor for creating MainCategory from existing data with int id
  factory CategoryEntity.fromIntId({
    int? id,
    required String name,
    String? icon,
    String? color,
    String? description,
    required bool isActive,
    required int sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
    List<MealTime>? mealTimes,
  }) {
    return CategoryEntity(
      id: id?.toString() ?? '',
      name: name,
      icon: icon,
      color: color,
      description: description,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
      mealTimes: mealTimes,
    );
  }

  /// Get int id for backward compatibility
  int? get intId {
    return int.tryParse(id);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    color,
    description,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    productsCount,
    mealTimes,
  ];

  @override
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    String? description,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productsCount,
    List<MealTime>? mealTimes,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,

      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productsCount: productsCount ?? this.productsCount,
      mealTimes: mealTimes ?? this.mealTimes,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

      'icon': icon,
      'color': color,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products_count': productsCount,
      'meal_times': mealTimes
          ?.map(
            (e) => {
              'id': e.id,
              'name': e.name,
              'name_ar': e.nameAr,
              'start_time':
                  '${e.startTime.hour.toString().padLeft(2, '0')}:${e.startTime.minute.toString().padLeft(2, '0')}',
              'end_time':
                  '${e.endTime.hour.toString().padLeft(2, '0')}:${e.endTime.minute.toString().padLeft(2, '0')}',
              'is_active': e.isActive,
              'category_ids': e.categoryIds,
              'sort_order': e.sortOrder,
            },
          )
          .toList(),
    };
  }

  @override
  bool get isValid {
    return name.isNotEmpty && sortOrder >= 0;
  }
  factory CategoryEntity.fake() {
    return CategoryEntity(
      id: '0',
      name: 'تصنيف تجريبي',
      isActive: true,
      sortOrder: 0,
    );
  }
}
