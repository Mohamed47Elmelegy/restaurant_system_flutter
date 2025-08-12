import 'package:flutter/material.dart';
import '../../domain/entities/meal_time.dart';

class AddMealTimeForm extends StatefulWidget {
  final MealTime? mealTime;
  final ValueChanged<MealTime> onSubmit;

  const AddMealTimeForm({super.key, this.mealTime, required this.onSubmit});

  @override
  State<AddMealTimeForm> createState() => _AddMealTimeFormState();
}

class _AddMealTimeFormState extends State<AddMealTimeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nameArController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.mealTime?.name);
    _nameArController = TextEditingController(text: widget.mealTime?.nameAr);
    _startTime =
        widget.mealTime?.startTime ?? const TimeOfDay(hour: 8, minute: 0);
    _endTime = widget.mealTime?.endTime ?? const TimeOfDay(hour: 22, minute: 0);
    _isActive = widget.mealTime?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.mealTime == null ? 'إضافة وقت وجبة' : 'تعديل وقت الوجبة',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم بالإنجليزية',
                hintText: 'مثال: Breakfast',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم بالإنجليزية';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameArController,
              decoration: const InputDecoration(
                labelText: 'الاسم بالعربية',
                hintText: 'مثال: فطور',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم بالعربية';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('وقت البداية'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectTime(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTimeOfDay(_startTime)),
                              const Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('وقت النهاية'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectTime(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTimeOfDay(_endTime)),
                              const Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('نشط'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.mealTime == null ? 'إضافة' : 'تعديل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final mealTime = MealTime(
        id: widget.mealTime?.id ?? '',
        name: _nameController.text,
        nameAr: _nameArController.text,
        startTime: _startTime,
        endTime: _endTime,
        isActive: _isActive,
        categoryIds: widget.mealTime?.categoryIds ?? [],
        sortOrder: widget.mealTime?.sortOrder ?? 0,
      );
      widget.onSubmit(mealTime);
    }
  }
}
