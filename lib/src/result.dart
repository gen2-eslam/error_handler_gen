import 'dart:async';

/// A sealed class representing the result of an operation.
///
/// Can be either [Success] containing a value of type [S],
/// or [Error] containing an error of type [E].
sealed class Result<S, E> {
  const Result();

  /// Creates a [Success] result with the given [value].
  factory Result.success(S value) = Success<S, E>;

  /// Creates an [Error] result with the given [error].
  factory Result.error(E error) = Error<S, E>;

  /// Handles the result based on whether it is [Success] or [Error].
  ///
  /// [success] callback is called if the result is [Success].
  /// [error] callback is called if the result is [Error].
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

  /// Executes an asynchronous [executeableFunction] and returns a [Future] of [Result].
  ///
  /// [onError] converts any exception thrown/caught into an [Error].
  /// [onSuccess] converts the result of the function into a [Success].
  /// [onFinally] is called after execution completes or fails.
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

  /// Executes a synchronous [executeableFunction] and returns a [Result].
  ///
  /// [onError] converts any exception thrown/caught into an [Error].
  /// [onSuccess] converts the result of the function into a [Success].
  /// [onFinally] is called after execution completes or fails.
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

  /// Transforms a stream returned by [streamFunction] into a [Stream] of [Result]s.
  ///
  /// [onError] converts any error emitted by the stream into an [Error].
  /// [onSuccess] converts data emitted by the stream into a [Success].
  /// [onDone] is called when the stream is done.
  /// [onCancel] is currently not used in the implementation (passed as parameter but unused).
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

/// A subclass of [Result] representing a successful operation.
class Success<S, E> extends Result<S, E> {
  /// The value of the successful result.
  final S value;
  Success(this.value);
}

/// A subclass of [Result] representing a failed operation.
class Error<S, E> extends Result<S, E> {
  /// The error value.
  final E value;
  Error(this.value);
}
