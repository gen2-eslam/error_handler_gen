import 'package:error_handler_gen/error_handler_gen.dart';

void main() async {
  // Example 1: Synchronous success
  final result1 = Result.excute<int, int, String>(
    executeableFunction: () => 42,
    onError: (e) => Error(e.toString()),
    onSuccess: (value) => Success(value),
  );

  result1.when(
    success: (s) => print('Result 1 Success: ${s.value}'),
    error: (e) => print('Result 1 Error: ${e.value}'),
  );

  // Example 2: Synchronous error
  final result2 = Result.excute<int, int, String>(
    executeableFunction: () => throw Exception('Something went wrong'),
    onError: (e) => Error(e.toString()),
    onSuccess: (value) => Success(value),
  );

  result2.when(
    success: (s) => print('Result 2 Success: ${s.value}'),
    error: (e) => print('Result 2 Error: ${e.value}'),
  );

  // Example 3: Asynchronous success
  final result3 = await Result.excuteAsync<int, int, String>(
    executeableFunction: () async {
      await Future.delayed(Duration(milliseconds: 100));
      return 100;
    },
    onError: (e) => Error(e.toString()),
    onSuccess: (value) => Success(value),
  );

  result3.when(
    success: (s) => print('Result 3 Success: ${s.value}'),
    error: (e) => print('Result 3 Error: ${e.value}'),
  );
}
