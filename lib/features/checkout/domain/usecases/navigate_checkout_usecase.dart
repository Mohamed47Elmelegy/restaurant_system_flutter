import '../entities/checkout_process_entity.dart';
import '../entities/checkout_step_entity.dart';

/// 🟦 NavigateCheckoutUseCase - Domain Layer
/// Single Responsibility: Handle checkout navigation logic
class NavigateCheckoutUseCase {
  /// Navigate to next step
  CheckoutProcessEntity goToNextStep(CheckoutProcessEntity currentProcess) {
    if (!currentProcess.canProceedToNext) {
      return currentProcess;
    }

    // Find next enabled step
    final nextStepIndex = _findNextEnabledStep(
      currentProcess.steps,
      currentProcess.currentStepIndex,
    );

    if (nextStepIndex == -1) {
      return currentProcess; // No next enabled step found
    }

    final updatedSteps = _updateStepsForNavigation(
      currentProcess.steps,
      nextStepIndex,
    );

    return currentProcess.copyWith(
      currentStepIndex: nextStepIndex,
      steps: updatedSteps,
    );
  }

  /// Navigate to previous step
  CheckoutProcessEntity goToPreviousStep(CheckoutProcessEntity currentProcess) {
    if (!currentProcess.canGoBack) {
      return currentProcess;
    }

    // Find previous enabled step
    final previousStepIndex = _findPreviousEnabledStep(
      currentProcess.steps,
      currentProcess.currentStepIndex,
    );

    if (previousStepIndex == -1) {
      return currentProcess; // No previous enabled step found
    }

    final updatedSteps = _updateStepsForNavigation(
      currentProcess.steps,
      previousStepIndex,
    );

    return currentProcess.copyWith(
      currentStepIndex: previousStepIndex,
      steps: updatedSteps,
    );
  }

  /// Navigate to specific step
  CheckoutProcessEntity goToStep(
    CheckoutProcessEntity currentProcess,
    int stepIndex,
  ) {
    if (stepIndex < 0 || stepIndex >= currentProcess.steps.length) {
      return currentProcess;
    }

    final targetStep = currentProcess.steps[stepIndex];
    if (!targetStep.isEnabled) {
      return currentProcess;
    }

    final updatedSteps = _updateStepsForNavigation(
      currentProcess.steps,
      stepIndex,
    );

    return currentProcess.copyWith(
      currentStepIndex: stepIndex,
      steps: updatedSteps,
    );
  }

  /// Update steps for navigation
  List<CheckoutStepEntity> _updateStepsForNavigation(
    List<CheckoutStepEntity> steps,
    int activeStepIndex,
  ) {
    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;

      return step.copyWith(
        isActive: index == activeStepIndex && step.isEnabled,
      );
    }).toList();
  }

  /// Get available navigation options
  CheckoutNavigationOptions getNavigationOptions(
    CheckoutProcessEntity currentProcess,
  ) {
    return CheckoutNavigationOptions(
      canGoBack: currentProcess.canGoBack,
      canGoNext: currentProcess.canProceedToNext,
      availableSteps: currentProcess.steps
          .asMap()
          .entries
          .where((entry) => entry.value.isEnabled)
          .map((entry) => entry.key)
          .toList(),
      currentStepIndex: currentProcess.currentStepIndex,
    );
  }
}

/// 🟩 CheckoutNavigationOptions - Value Object
class CheckoutNavigationOptions {
  final bool canGoBack;
  final bool canGoNext;
  final List<int> availableSteps;
  final int currentStepIndex;

  const CheckoutNavigationOptions({
    required this.canGoBack,
    required this.canGoNext,
    required this.availableSteps,
    required this.currentStepIndex,
  });

  bool canNavigateToStep(int stepIndex) {
    return availableSteps.contains(stepIndex);
  }
}

/// Helper functions for finding enabled steps
int _findNextEnabledStep(List<CheckoutStepEntity> steps, int currentIndex) {
  for (int i = currentIndex + 1; i < steps.length; i++) {
    if (steps[i].isEnabled) {
      return i;
    }
  }
  return -1; // No enabled step found
}

int _findPreviousEnabledStep(List<CheckoutStepEntity> steps, int currentIndex) {
  for (int i = currentIndex - 1; i >= 0; i--) {
    if (steps[i].isEnabled) {
      return i;
    }
  }
  return -1; // No enabled step found
}
