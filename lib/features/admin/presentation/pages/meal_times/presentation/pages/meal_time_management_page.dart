import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/di/service_locator.dart';
import '../../../../../../../core/utils/responsive_helper.dart';
import '../../../../../../../core/widgets/error_widget.dart';
import '../../domain/entities/meal_time.dart';
import '../bloc/meal_time_bloc.dart';
import '../bloc/meal_time_event.dart';
import '../bloc/meal_time_state.dart';
import '../widgets/add_meal_time_form.dart';
import '../widgets/meal_time_list_item.dart';

class MealTimeManagementPage extends StatelessWidget {
  const MealTimeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MealTimeBloc>()..add(const GetMealTimesEvent()),
      child: const MealTimeManagementView(),
    );
  }
}

class MealTimeManagementView extends StatelessWidget {
  const MealTimeManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أوقات الوجبات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMealTimeDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<MealTimeBloc, MealTimeState>(
        builder: (context, state) {
          if (state is MealTimeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MealTimeError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<MealTimeBloc>().add(const GetMealTimesEvent());
              },
            );
          }

          if (state is MealTimesLoaded) {
            if (state.mealTimes.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد أوقات وجبات مضافة',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }

            return ResponsiveHelper.responsiveLayout(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return _buildMobileList(context, state.mealTimes);
                } else if (constraints.maxWidth < 1200) {
                  return _buildTabletGrid(context, state.mealTimes);
                } else {
                  return _buildDesktopGrid(context, state.mealTimes);
                }
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<MealTime> mealTimes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mealTimes.length,
      itemBuilder: (context, index) {
        return MealTimeListItem(
          mealTime: mealTimes[index],
          onEdit: () => _showEditMealTimeDialog(context, mealTimes[index]),
          onDelete: () => _showDeleteConfirmation(context, mealTimes[index]),
          onStatusChanged: (isActive) {
            context.read<MealTimeBloc>().add(
              ToggleMealTimeStatusEvent(
                id: mealTimes[index].id,
                isActive: isActive,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabletGrid(BuildContext context, List<MealTime> mealTimes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: mealTimes.length,
      itemBuilder: (context, index) {
        return MealTimeListItem(
          mealTime: mealTimes[index],
          onEdit: () => _showEditMealTimeDialog(context, mealTimes[index]),
          onDelete: () => _showDeleteConfirmation(context, mealTimes[index]),
          onStatusChanged: (isActive) {
            context.read<MealTimeBloc>().add(
              ToggleMealTimeStatusEvent(
                id: mealTimes[index].id,
                isActive: isActive,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopGrid(BuildContext context, List<MealTime> mealTimes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: mealTimes.length,
      itemBuilder: (context, index) {
        return MealTimeListItem(
          mealTime: mealTimes[index],
          onEdit: () => _showEditMealTimeDialog(context, mealTimes[index]),
          onDelete: () => _showDeleteConfirmation(context, mealTimes[index]),
          onStatusChanged: (isActive) {
            context.read<MealTimeBloc>().add(
              ToggleMealTimeStatusEvent(
                id: mealTimes[index].id,
                isActive: isActive,
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMealTimeDialog(BuildContext context) {
    final bloc = context.read<MealTimeBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: AddMealTimeForm(
          onSubmit: (mealTime) {
            bloc.add(CreateMealTimeEvent(mealTime));
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showEditMealTimeDialog(BuildContext context, MealTime mealTime) {
    final bloc = context.read<MealTimeBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: AddMealTimeForm(
          mealTime: mealTime,
          onSubmit: (updatedMealTime) {
            bloc.add(UpdateMealTimeEvent(updatedMealTime));
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, MealTime mealTime) {
    final bloc = context.read<MealTimeBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من حذف وقت الوجبة "${mealTime.getDisplayName()}"؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              bloc.add(DeleteMealTimeEvent(mealTime.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
