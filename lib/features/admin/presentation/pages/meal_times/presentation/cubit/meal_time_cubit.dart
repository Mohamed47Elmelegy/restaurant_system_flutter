import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/meal_time.dart';
import '../bloc/meal_time_state.dart';

class MealTimeCubit extends Cubit<MealTimeState> {
  final List<MealTime> _mealTimes;
  MealTime? _selectedMealTime;

  MealTimeCubit({List<MealTime>? initialMealTimes})
    : _mealTimes = initialMealTimes ?? [],
      super(MealTimeInitial());

  void selectMealTime(MealTime mealTime) {
    _selectedMealTime = mealTime;
    emit(
      MealTimeSelected(selectedMealTime: mealTime, allMealTimes: _mealTimes),
    );
  }

  void updateMealTimes(List<MealTime> mealTimes) {
    _mealTimes.clear();
    _mealTimes.addAll(mealTimes);
    emit(
      MealTimesLoaded(
        mealTimes: mealTimes,
        currentMealTime: mealTimes
            .where((mt) => mt.isAvailableNow())
            .firstOrNull,
      ),
    );
  }

  void refresh() {
    emit(
      MealTimesLoaded(
        mealTimes: _mealTimes,
        currentMealTime: _mealTimes
            .where((mt) => mt.isAvailableNow())
            .firstOrNull,
      ),
    );
  }

  MealTime? get selectedMealTime => _selectedMealTime;
  List<MealTime> get mealTimes => List.unmodifiable(_mealTimes);
}
