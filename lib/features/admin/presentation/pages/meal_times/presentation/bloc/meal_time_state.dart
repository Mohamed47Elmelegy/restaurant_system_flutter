import 'package:equatable/equatable.dart';
import '../../domain/entities/meal_time.dart';

abstract class MealTimeState extends Equatable {
  const MealTimeState();

  @override
  List<Object?> get props => [];
}

class MealTimeInitial extends MealTimeState {}

class MealTimeLoading extends MealTimeState {}

class MealTimeError extends MealTimeState {
  final String message;

  const MealTimeError(this.message);

  @override
  List<Object?> get props => [message];
}

class MealTimesLoaded extends MealTimeState {
  final List<MealTime> mealTimes;
  final MealTime? currentMealTime;

  const MealTimesLoaded({required this.mealTimes, this.currentMealTime});

  @override
  List<Object?> get props => [mealTimes, currentMealTime];
}

class MealTimeSelected extends MealTimeState {
  final MealTime selectedMealTime;
  final List<MealTime> allMealTimes;

  const MealTimeSelected({
    required this.selectedMealTime,
    required this.allMealTimes,
  });

  @override
  List<Object?> get props => [selectedMealTime, allMealTimes];
}

class MealTimeCreated extends MealTimeState {
  final MealTime mealTime;

  const MealTimeCreated(this.mealTime);

  @override
  List<Object?> get props => [mealTime];
}

class MealTimeUpdated extends MealTimeState {
  final MealTime mealTime;

  const MealTimeUpdated(this.mealTime);

  @override
  List<Object?> get props => [mealTime];
}

class MealTimeDeleted extends MealTimeState {
  final String id;

  const MealTimeDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class MealTimeStatusToggled extends MealTimeState {
  final MealTime mealTime;

  const MealTimeStatusToggled(this.mealTime);

  @override
  List<Object?> get props => [mealTime];
}

class MealTimesOrderUpdated extends MealTimeState {
  final List<MealTime> mealTimes;

  const MealTimesOrderUpdated(this.mealTimes);

  @override
  List<Object?> get props => [mealTimes];
}
