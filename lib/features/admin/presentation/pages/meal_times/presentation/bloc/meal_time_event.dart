import 'package:equatable/equatable.dart';
import '../../domain/entities/meal_time.dart';

abstract class MealTimeEvent extends Equatable {
  const MealTimeEvent();

  @override
  List<Object?> get props => [];
}

class GetMealTimesEvent extends MealTimeEvent {
  final bool? isActive;

  const GetMealTimesEvent({this.isActive});

  @override
  List<Object?> get props => [isActive];
}

class SelectMealTimeEvent extends MealTimeEvent {
  final MealTime mealTime;
  final List<MealTime> allMealTimes;

  const SelectMealTimeEvent({
    required this.mealTime,
    required this.allMealTimes,
  });

  @override
  List<Object?> get props => [mealTime, allMealTimes];
}

class CreateMealTimeEvent extends MealTimeEvent {
  final MealTime mealTime;

  const CreateMealTimeEvent(this.mealTime);

  @override
  List<Object?> get props => [mealTime];
}

class UpdateMealTimeEvent extends MealTimeEvent {
  final MealTime mealTime;

  const UpdateMealTimeEvent(this.mealTime);

  @override
  List<Object?> get props => [mealTime];
}

class DeleteMealTimeEvent extends MealTimeEvent {
  final String id;

  const DeleteMealTimeEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleMealTimeStatusEvent extends MealTimeEvent {
  final String id;
  final bool isActive;

  const ToggleMealTimeStatusEvent({required this.id, required this.isActive});

  @override
  List<Object?> get props => [id, isActive];
}

class UpdateMealTimesOrderEvent extends MealTimeEvent {
  final List<MealTime> mealTimes;

  const UpdateMealTimesOrderEvent(this.mealTimes);

  @override
  List<Object?> get props => [mealTimes];
}
