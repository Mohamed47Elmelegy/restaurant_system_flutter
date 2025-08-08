# نظام معالجة الأخطاء - دليل شامل

## 📋 نظرة عامة

نظام معالجة الأخطاء الموحد يدعم اللغة العربية ويوفر تدفق بيانات منظم عبر طبقات التطبيق المختلفة.

## 🏗️ البنية الأساسية

### 1️⃣ **AppError** - المصدر الأساسي
```dart
class AppError {
  final String message;           // رسالة إنجليزية للمطور
  final String? arabicMessage;    // رسالة عربية للمستخدم
  final int? statusCode;          // رمز الحالة HTTP
  final Map<String, List<String>>? validationErrors; // أخطاء التحقق
  final ErrorType type;           // نوع الخطأ
  final String? code;             // رمز الخطأ
  final DateTime? timestamp;      // وقت حدوث الخطأ
}
```

### 2️⃣ **Failure** - مستوى Domain
```dart
abstract class Failure extends Equatable {
  final String message;
  final String? arabicMessage;
  final String? code;
  final DateTime? timestamp;
  final ErrorType? errorType;
}
```

### 3️⃣ **ApiResponse** - مستوى Data
```dart
class ApiResponse<T> {
  final bool status;
  final String message;
  final String? arabicMessage;
  final T? data;
  final Map<String, List<String>>? errors;
  final int? statusCode;
  final String? code;
  final DateTime? timestamp;
}
```

## 🎯 **رسائل نظيفة للمستخدم**

### ✅ **حل مشكلة "Exception:"**

تم تعديل جميع الـ `toString()` methods لتعرض رسائل نظيفة للمستخدم:

```dart
// قبل التعديل
print(error.toString()); // "Exception: خطاء في البريد الإلكتروني أو كلمة المرور"

// بعد التعديل
print(error.toString()); // "خطاء في البريد الإلكتروني أو كلمة المرور"
```

### 📝 **التعديلات المطبقة:**

#### **1. AppError.toString()**
```dart
@override
String toString() {
  return cleanUserMessage; // رسالة عربية نظيفة
}
```

#### **2. Failure.toString()**
```dart
@override
String toString() {
  return cleanUserMessage; // رسالة عربية نظيفة
}
```

#### **3. ApiResponse.toString()**
```dart
@override
String toString() {
  return cleanUserMessage; // رسالة عربية نظيفة
}
```

### 🎯 **النتيجة:**

الآن عندما يحدث خطأ، المستخدم سيرى فقط:
- ✅ **"خطاء في البريد الإلكتروني أو كلمة المرور"**

بدلاً من:
- ❌ **"Exception: خطاء في البريد الإلكتروني أو كلمة المرور"**
- ❌ **"AuthFailure: خطاء في البريد الإلكتروني أو كلمة المرور"**
- ❌ **"AppError(type: auth, message: ...)"**

## 🔄 تدفق البيانات - مثال تسجيل الدخول

### 📊 **الرسم البياني للتدفق:**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │    Use Case     │    │   Repository    │    │  Data Source    │
│     (Bloc)      │    │                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
    ┌─────────┐            ┌─────────┐            ┌─────────┐            ┌─────────┐
    │  State  │            │ Either  │            │ Either  │            │ApiResponse│
    │         │            │         │            │         │            │         │
    │  Error  │◄───────────│ Failure │◄───────────│ Failure │◄───────────│  Error  │
    │ Success │            │ Success │            │ Success │            │ Success │
    └─────────┘            └─────────┘            └─────────┘            └─────────┘
```

### 🚀 **مثال تفصيلي - تسجيل الدخول:**

#### **1️⃣ Data Source Layer (مستوى مصدر البيانات)**

```dart
// lib/features/auth/data/datasources/auth_remote_data_source.dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ApiResponse<AuthModel>> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // نجاح - تحويل JSON إلى ApiResponse
      return ApiResponse.fromJson(
        response.data,
        (json) => AuthModel.fromJson(json),
      );

    } catch (e) {
      // فشل - معالجة الخطأ
      if (e is DioException) {
        return ApiResponse.fromDioException(e); // يستخدم AppError داخلياً
      }
      
      // خطأ غير متوقع
      return ApiResponse.error(
        'Unexpected error occurred',
        arabicMessage: 'حدث خطأ غير متوقع',
      );
    }
  }
}
```

**📝 ملاحظات:**
- يستخدم `ApiResponse.fromDioException()` الذي يستدعي `AppError.fromDioException()` داخلياً
- ينتج `ApiResponse<AuthModel>` في حالة النجاح
- ينتج `ApiResponse<AuthModel>` في حالة الفشل (مع رسالة خطأ)

#### **2️⃣ Repository Layer (مستوى المستودع)**

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    try {
      // استدعاء Data Source
      final response = await remoteDataSource.login(email, password);

      // تحويل ApiResponse إلى Either
      if (response.isSuccess) {
        final authModel = response.data!;
        
        // حفظ البيانات محلياً
        await localDataSource.cacheAuth(authModel);
        
        // تحويل Model إلى Entity
        final authEntity = authModel.toEntity();
        
        return Right(authEntity); // نجاح
      } else {
        // فشل - تحويل إلى Failure
        return Left(Failure.fromAppError(response.toAppError()));
      }

    } catch (e) {
      // معالجة الأخطاء غير المتوقعة
      final appError = ErrorHelper.handleException(e);
      return Left(Failure.fromAppError(appError));
    }
  }
}
```

**📝 ملاحظات:**
- يستخدم `response.toEither()` لتحويل `ApiResponse` إلى `Either`
- يستخدم `Failure.fromAppError()` لتحويل `AppError` إلى `Failure`
- ينتج `Either<Failure, AuthEntity>`

#### **3️⃣ Use Case Layer (مستوى حالة الاستخدام)**

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
```

**📝 ملاحظات:**
- يمرر البيانات من Repository إلى Presentation
- لا يضيف منطق إضافي لمعالجة الأخطاء
- ينتج `Either<Failure, AuthEntity>`

#### **4️⃣ Presentation Layer (مستوى العرض)**

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      // فشل - عرض رسالة خطأ للمستخدم
      (failure) {
        emit(AuthError(failure.toString())); // رسالة نظيفة
      },
      // نجاح - الانتقال للشاشة التالية
      (authEntity) {
        emit(AuthSuccess(authEntity));
      },
    );
  }
}

// lib/features/auth/presentation/bloc/auth_state.dart
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final AuthEntity authEntity;

  const AuthSuccess(this.authEntity);

  @override
  List<Object?> get props => [authEntity];
}

class AuthError extends AuthState {
  final String message; // رسالة عربية نظيفة

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
```

**📝 ملاحظات:**
- يستخدم `failure.toString()` للحصول على رسالة نظيفة للمستخدم
- ينتج `AuthState` (Loading, Success, Error)

#### **5️⃣ UI Layer (مستوى واجهة المستخدم)**

```dart
// lib/features/auth/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // الانتقال للشاشة الرئيسية
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // نموذج تسجيل الدخول
                  TextFormField(
                    decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                    onChanged: (email) => context.read<AuthBloc>().email = email,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                    onChanged: (password) => context.read<AuthBloc>().password = password,
                  ),
                  SizedBox(height: 24),
                  
                  // زر تسجيل الدخول
                  ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(LoginRequested());
                          },
                    child: state is AuthLoading
                        ? CircularProgressIndicator()
                        : Text('تسجيل الدخول'),
                  ),
                  
                  // عرض رسالة الخطأ
                  if (state is AuthError) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.message, // رسالة عربية نظيفة
                        style: TextStyle(color: Colors.red.shade800),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

**📝 ملاحظات:**
- يعرض `state.message` مباشرة للمستخدم (رسالة عربية نظيفة)
- لا يحتاج لمعالجة إضافية للرسائل

## 🔄 **تدفق البيانات التفصيلي**

### **سيناريو النجاح:**
```
1. UI → Bloc: LoginRequested(email, password)
2. Bloc → UseCase: loginUseCase(params)
3. UseCase → Repository: repository.login(email, password)
4. Repository → DataSource: remoteDataSource.login(email, password)
5. DataSource → API: HTTP POST /auth/login
6. API → DataSource: ApiResponse.success(authModel)
7. DataSource → Repository: ApiResponse<AuthModel>
8. Repository → UseCase: Either<Failure, AuthEntity> (Right)
9. UseCase → Bloc: Either<Failure, AuthEntity> (Right)
10. Bloc → UI: AuthSuccess(authEntity)
```

### **سيناريو الفشل (بيانات خاطئة):**
```
1. UI → Bloc: LoginRequested(email, password)
2. Bloc → UseCase: loginUseCase(params)
3. UseCase → Repository: repository.login(email, password)
4. Repository → DataSource: remoteDataSource.login(email, password)
5. DataSource → API: HTTP POST /auth/login
6. API → DataSource: 401 Unauthorized
7. DataSource: DioException → AppError.fromDioException()
8. DataSource → Repository: ApiResponse.error(appError)
9. Repository: ApiResponse.toEither() → Either<Failure, AuthEntity> (Left)
10. UseCase → Bloc: Either<Failure, AuthEntity> (Left)
11. Bloc: failure.toString() → "خطاء في البريد الإلكتروني أو كلمة المرور"
12. Bloc → UI: AuthError("خطاء في البريد الإلكتروني أو كلمة المرور")
```

## 🎯 **التحويلات الرئيسية**

### **1. DioException → AppError**
```dart
// في AppError.fromDioException()
static AppError fromDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.badResponse:
      return _handleBadResponse(error);
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return AppError.custom(
        message: 'Request timeout',
        arabicMessage: 'انتهت مهلة الاتصال',
        type: ErrorType.timeout,
        code: 'TIMEOUT_ERROR',
      );
    // ... باقي الحالات
  }
}
```

### **2. AppError → Failure**
```dart
// في Failure.fromAppError()
factory Failure.fromAppError(AppError error) {
  switch (error.type) {
    case ErrorType.auth:
      return AuthFailure(
        message: error.message,
        arabicMessage: error.arabicMessage,
        code: error.code,
        timestamp: error.timestamp,
      );
    // ... باقي الحالات
  }
}
```

### **3. ApiResponse → Either**
```dart
// في ErrorHelper.apiResponseToEither()
static Either<Failure, T> apiResponseToEither<T>(ApiResponse<T> response) {
  if (response.isSuccess) {
    return Right(response.data!);
  } else {
    return Left(Failure.fromAppError(response.toAppError()));
  }
}
```

## 📊 **مثال عملي - رسائل الأخطاء**

### **خطأ مصادقة (401):**
```
API Response: 401 Unauthorized
↓
AppError: {
  message: "Email or password is incorrect",
  arabicMessage: "خطاء في البريد الإلكتروني أو كلمة المرور",
  type: ErrorType.auth,
  statusCode: 401
}
↓
Failure: AuthFailure(
  message: "Email or password is incorrect",
  arabicMessage: "خطاء في البريد الإلكتروني أو كلمة المرور"
)
↓
UI: "خطاء في البريد الإلكتروني أو كلمة المرور"
```

### **خطأ شبكة:**
```
DioException: DioExceptionType.connectionError
↓
AppError: {
  message: "Network connection failed",
  arabicMessage: "فشل في الاتصال بالشبكة",
  type: ErrorType.network
}
↓
Failure: NetworkFailure(
  message: "Network connection failed",
  arabicMessage: "فشل في الاتصال بالشبكة"
)
↓
UI: "فشل في الاتصال بالشبكة"
```

## 🎯 **الخلاصة**

نظام معالجة الأخطاء يوفر:

1. **تدفق منظم**: من Data Source إلى UI
2. **رسائل نظيفة**: بدون تفاصيل تقنية للمستخدم
3. **دعم العربية**: رسائل خطأ باللغة العربية
4. **مرونة عالية**: يمكن تخصيص الرسائل حسب الحاجة
5. **سهولة الاستخدام**: واجهة بسيطة وواضحة

هذا النظام يجعل معالجة الأخطاء أكثر بساطة وفعالية مع الحفاظ على المرونة والقوة. 