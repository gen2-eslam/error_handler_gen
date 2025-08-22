import 'dart:async';

sealed class Result<S, E> {
  const Result();
  factory Result.success(S value) = Success<S, E>;
  factory Result.error(E error) = Error<S, E>;

  void when({
    required void Function(Success<S, E> success) success,
    required void Function(Error<S, E> error) error,
  }) {
    if (this is Success<S, E>) {
      success(this as Success<S, E>);
    } else if (this is Error<S, E>) {
      error(this as Error<S, E>);
    }
  }

  static Future<Result<S, E>> excuteAsync<T, S, E>({
    required Future<T> Function() executeableFunction,
    required Error<S, E> Function(Object) onError,
    required Success<S, E> Function(T) onSuccess,
    void Function()? onFinally,
  }) async {
    try {
      T result = await executeableFunction();
      return onSuccess(result);
    } catch (e) {
      return onError(e);
    } finally {
      onFinally?.call();
    }
  }

  static Result<S, E> excute<T, S, E>({
    required T Function() executeableFunction,
    required Error<S, E> Function(Object) onError,
    required Success<S, E> Function(T) onSuccess,
    void Function()? onFinally,
  }) {
    try {
      T result = executeableFunction();
      return onSuccess(result);
    } catch (e) {
      return onError(e);
    } finally {
      onFinally?.call();
    }
  }

  static Stream<Result<S, E>> executeStream<T, S, E>({
    required Stream<T> Function() streamFunction,
    required Error<S, E> Function(Object) onError,
    required Success<S, E> Function(T) onSuccess,
    void Function()? onDone,
    void Function()? onCancel,
  }) {
    return streamFunction().transform<Result<S, E>>(
      StreamTransformer<T, Result<S, E>>.fromHandlers(
        handleData: (data, sink) {
          try {
            sink.add(onSuccess(data));
          } catch (e) {
            sink.add(onError(e));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(onError(error));
        },
        handleDone: (sink) {
          onDone?.call();
          sink.close();
        },
      ),
    );
  }
}

class Success<S, E> extends Result<S, E> {
  final S value;
  Success(this.value);
}

class Error<S, E> extends Result<S, E> {
  final E value;
  Error(this.value);
}
