import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_meal_time.dart';
import '../../domain/usecases/delete_meal_time.dart';
import '../../domain/usecases/get_meal_times.dart';
import '../../domain/usecases/toggle_meal_time_status.dart';
import '../../domain/usecases/update_meal_time.dart';
import '../../domain/usecases/update_meal_times_order.dart';
import 'meal_time_event.dart';
import 'meal_time_state.dart';

class MealTimeBloc extends Bloc<MealTimeEvent, MealTimeState> {
  final GetMealTimes _getMealTimes;
  final CreateMealTime _createMealTime;
  final UpdateMealTime _updateMealTime;
  final DeleteMealTime _deleteMealTime;
  final ToggleMealTimeStatus _toggleMealTimeStatus;
  final UpdateMealTimesOrder _updateMealTimesOrder;

  MealTimeBloc({
    required GetMealTimes getMealTimes,
    required CreateMealTime createMealTime,
    required UpdateMealTime updateMealTime,
    required DeleteMealTime deleteMealTime,
    required ToggleMealTimeStatus toggleMealTimeStatus,
    required UpdateMealTimesOrder updateMealTimesOrder,
  }) : _getMealTimes = getMealTimes,
       _createMealTime = createMealTime,
       _updateMealTime = updateMealTime,
       _deleteMealTime = deleteMealTime,
       _toggleMealTimeStatus = toggleMealTimeStatus,
       _updateMealTimesOrder = updateMealTimesOrder,
       super(MealTimeInitial()) {
    on<GetMealTimesEvent>(_onGetMealTimes);
    on<SelectMealTimeEvent>(_onSelectMealTime);
    on<CreateMealTimeEvent>(_onCreateMealTime);
    on<UpdateMealTimeEvent>(_onUpdateMealTime);
    on<DeleteMealTimeEvent>(_onDeleteMealTime);
    on<ToggleMealTimeStatusEvent>(_onToggleMealTimeStatus);
    on<UpdateMealTimesOrderEvent>(_onUpdateMealTimesOrder);
  }

  Future<void> _onGetMealTimes(
    GetMealTimesEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _getMealTimes(isActive: event.isActive);
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (mealTimes) => emit(
        MealTimesLoaded(
          mealTimes: mealTimes,
          currentMealTime: mealTimes
              .where((mt) => mt.isAvailableNow())
              .firstOrNull,
        ),
      ),
    );
  }

  void _onSelectMealTime(
    SelectMealTimeEvent event,
    Emitter<MealTimeState> emit,
  ) {
    emit(
      MealTimeSelected(
        selectedMealTime: event.mealTime,
        allMealTimes: event.allMealTimes,
      ),
    );
  }

  Future<void> _onCreateMealTime(
    CreateMealTimeEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _createMealTime(event.mealTime);
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (mealTime) => emit(MealTimeCreated(mealTime)),
    );
  }

  Future<void> _onUpdateMealTime(
    UpdateMealTimeEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _updateMealTime(event.mealTime);
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (mealTime) => emit(MealTimeUpdated(mealTime)),
    );
  }

  Future<void> _onDeleteMealTime(
    DeleteMealTimeEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _deleteMealTime(event.id);
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (_) => emit(MealTimeDeleted(event.id)),
    );
  }

  Future<void> _onToggleMealTimeStatus(
    ToggleMealTimeStatusEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _toggleMealTimeStatus(
      ToggleMealTimeParams(id: event.id, isActive: event.isActive),
    );
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (mealTime) => emit(MealTimeStatusToggled(mealTime)),
    );
  }

  Future<void> _onUpdateMealTimesOrder(
    UpdateMealTimesOrderEvent event,
    Emitter<MealTimeState> emit,
  ) async {
    emit(MealTimeLoading());
    final result = await _updateMealTimesOrder(event.mealTimes);
    result.fold(
      (failure) => emit(MealTimeError(failure.message)),
      (mealTimes) => emit(MealTimesOrderUpdated(mealTimes)),
    );
  }
}
