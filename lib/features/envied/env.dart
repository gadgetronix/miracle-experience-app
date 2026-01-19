import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/features/envied/.env')
abstract class Env {
  @EnviedField(
    varName: 'ZOHOCLIENTID',
  )
  static const String zohoClientId = _Env.zohoClientId;
}
