import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../utils/enum.dart';

@immutable
abstract class APIResultState<T> extends Equatable {
  final String? message;
  final APIResultType? resultType;
  final T? result;

  const APIResultState({this.message, this.resultType, this.result});

  @override
  List<Object?> get props => [message, resultType, result];
}

// STATES
class LoadingState<T> extends APIResultState<T> {
  const LoadingState({super.result})
    : super(message: "Loading", resultType: APIResultType.loading);
}

class NoInternetState<T> extends APIResultState<T> {
  const NoInternetState({super.resultType})
    : super(message: "No internet found");
}

class SuccessState<T> extends APIResultState<T> {
  const SuccessState({super.message, super.resultType, super.result});
}

class FailureState<T> extends APIResultState<T> {
  const FailureState({super.message, super.resultType, super.result});
}

class UserUnauthorisedState<T> extends APIResultState<T> {
  const UserUnauthorisedState({super.message, super.resultType, super.result});
}

class TimeOutState<T> extends APIResultState<T> {
  const TimeOutState({super.resultType}) : super(message: "Request timed out");
}

class UserDeletedState<T> extends APIResultState<T> {
  const UserDeletedState({super.resultType}) : super(message: "User deleted");
}

class SessionExpiredState<T> extends APIResultState<T> {
  const SessionExpiredState({super.resultType, super.result})
    : super(message: "Session expired");
}

// UTILITY CLASS FOR CHECKING STATES
class APIResult {
  static bool isLoading(APIResultState? state) => state is LoadingState;
  static bool isSuccess(APIResultState? state) => state is SuccessState;
  static bool isFailure(APIResultState? state) => state is FailureState;
  static bool isNoInternet(APIResultState? state) => state is NoInternetState;
}
