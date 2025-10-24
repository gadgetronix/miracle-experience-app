import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../../core/basic_features_network.dart';
import '../../../core/network/base_response_model_entity.dart';
import '../repositories/auth_repository.dart';

class SigninCubit extends Cubit<APIResultState<ModelResponseSigninEntity>?> {
  SigninCubit() : super(null);

  Future<void> callSigninAPI(
    ModelRequestSigninEntity modelRequestSigninEntity,
  ) async {
    emit(const LoadingState());

    final APIResultState<ModelResponseSigninEntity> apiResultFromNetwork =
        await AuthRepository.callSigninAPI(modelRequestSigninEntity);

    emit(apiResultFromNetwork);
  }
}

class SignOutCubit extends Cubit<APIResultState<BaseResponseModelEntity>?> {
  SignOutCubit() : super(null);

  Future<void> callSignOutAPI(
    ModelRequestSigninEntity modelRequestSigninEntity,
  ) async {
    emit(const LoadingState());

    final APIResultState<BaseResponseModelEntity> apiResultFromNetwork =
        await AuthRepository.callSignoutAPI(modelRequestSigninEntity);

    emit(apiResultFromNetwork);
  }
}
