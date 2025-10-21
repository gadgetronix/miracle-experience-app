import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/repositories/balloon_manifest_repository.dart';

import '../../../core/basic_features_network.dart';

class BalloonManifestCubit
    extends Cubit<APIResultState<ModelResponseBalloonManifestEntity>?> {
  BalloonManifestCubit() : super(null);

  Future<void> callBalloonManifestAPI() async {
    emit(const LoadingState());

    final APIResultState<ModelResponseBalloonManifestEntity>
    apiResultFromNetwork =
        await BalloonManifestRepository.callBalloonManifestAPI();

    emit(apiResultFromNetwork);
  }
}
