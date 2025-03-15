import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/features/auth/view_models/auth_view_model.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    // 컨트롤러 생성
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // 폼 키 생성
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // 로그인 상태 확인
    useEffect(() {
      // 이미 로그인되어 있으면 홈 화면으로 이동
      if (authState.isAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/');
        });
      }
      return null;
    }, [authState.isAuthenticated]);

    // 로그인 처리 함수
    Future<void> handleLogin() async {
      if (formKey.currentState?.validate() ?? false) {
        try {
          await authViewModel.login(
            emailController.text,
            passwordController.text,
          );

          if (!context.mounted) return;

          // 로그인 성공 시 홈 화면으로 직접 이동
          if (authState.isAuthenticated) {
            context.go('/');
          }
        } catch (e) {
          // 에러는 이미 화면에 표시됨
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '사진 스팟 앱',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => handleLogin(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : handleLogin,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('로그인'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text('계정이 없으신가요? 회원가입'),
                  ),
                  if (authState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SelectableText.rich(
                        TextSpan(
                          text: '오류: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: authState.error.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 이전 상태를 추적하기 위한 Hook
T? usePrevious<T>(T value) {
  final ref = useRef<T?>(null);
  useEffect(() {
    ref.value = value;
    return null;
  }, [value]);
  return ref.value;
}
