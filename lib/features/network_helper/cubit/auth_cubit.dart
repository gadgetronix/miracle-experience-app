import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../../core/basic_features_network.dart';
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
