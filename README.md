<p align="center">
<img src="logo-no-background.svg" height="300" width="300" alt="Error Handler Gen Logo">
</p>

# Result<T, E> - Type-Safe Error Handling for Dart

A lightweight, type-safe sealed class for functional error handling in Dart. Eliminate exceptions and embrace explicit error handling with a clean, composable API.

## Installation

Add to your pubspec.yaml:

```yaml
error_handler_gen:
  git:
    url: https://github.com/gen2-eslam/error_handler_gen.git
```
    
## Features

- ✅ **Type-safe** - Compile-time safety for success and error types
- ✅ **Sealed class** - Exhaustive pattern matching support
- ✅ **Async ready** - Full support for async operations
- ✅ **Functional** - Composable operations with map, flatMap, etc.
- ✅ **Zero dependencies** - Pure Dart implementation

## Usage/Examples

```dart
import 'package:error_handler_gen/error_handler_gen.dart';
import 'package:dio/dio.dart';

void main() async {
  // Create instance of Result with generic type parameters
  Result<Response, String> res;
  final dio = Dio();

  // Call Result.excuteAsync or Result.excute    
  res = await Result.excuteAsync<Response, Response, String>(
    executeableFunction: () async {
      var res = await dio.get("https://dart.dev");
      return res;
    },
    onError: (error) {
      return Error<Response, String>(error.toString());
    },
    onSuccess: (data) {
      return Success<Response, String>(data);
    },
  );

  // Call res.when to show data
  res.when(
    success: (data) {
      print(data.value.toString());
    },
    error: (error) {
      print(error.value.toString());
    },
  );
}
```

## Video 

https://youtu.be/QV2P_wBSKg4
