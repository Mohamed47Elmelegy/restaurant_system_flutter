import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (auth) {
      // حفظ البيانات في الـ secure storage
      authRepository.saveAuthData(auth);
      emit(AuthSuccess(auth));
    });
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (auth) {
      // حفظ البيانات في الـ secure storage
      authRepository.saveAuthData(auth);
      emit(AuthSuccess(auth));
    });
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthLoggedOut());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    isLoggedIn.fold((failure) => emit(AuthLoggedOut()), (loggedIn) {
      if (loggedIn) {
        // محاولة استرجاع البيانات المحفوظة
        authRepository.getAuthData().then((result) {
          result.fold(
            (failure) => emit(AuthLoggedOut()),
            (auth) => emit(AuthSuccess(auth!)),
          );
        });
      } else {
        emit(AuthLoggedOut());
      }
    });
  }
}
