<a href="url"><img src="./logo-no-background.svg" align="left" height="100" width="100" ></a> \n

# Result<T, E> - Type-Safe Error Handling for Dart
A lightweight, type-safe sealed class for functional error handling in Dart. Eliminate exceptions and embrace explicit error handling with a clean, composable API.






## Installation

Add to your pubspec.yaml:
```bash
   error_handler_gen:
    git:
      url: https://github.com/gen2-eslam/error_handler_gen.git
```
    
## Features

- ✅ Type-safe - Compile-time safety for success and error types

- ✅ Sealed class - Exhaustive pattern matching support

- ✅ Async ready - Full support for async operations

- ✅ Functional - Composable operations with map, flatMap, etc.

- ✅ Zero dependencies - Pure Dart implementation


## Usage/Examples


```dart


import 'package:result/result.dart';


//create instance of Result with generic type parameters
   Result<Response, String> res;
  final dio = Dio();
//call Result.excuteAsync or Result.excute    
   void data() async {
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
  }
  //call  res.when to show data
    onPressed: () {
          res.when(
            success: (data) {
              log(data.value.toString());
            },
            error: (error) {
              log(error.value.toString());
            },
          );
        },
```


## Video 
https://youtu.be/QV2P_wBSKg4



