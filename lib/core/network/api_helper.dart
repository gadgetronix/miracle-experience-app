import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as network;

import '../basic_features.dart';
import 'api_url.dart';
import 'network_result.dart';

class APIHelper {
  final bool _isDebug = kDebugMode;
  Map<String, String>? _headers;

  APIHelper._privateConstructor() {
    _createHeaders();
  }

  static final APIHelper _instance = APIHelper._privateConstructor();

  static APIHelper get instance => _instance;

  Future<NetworkResult> callPostApi(
    String path,
    dynamic params,
    bool showLoader, {
    bool? useDefaultBaseURL,
  }) async {
    var callingURL = useDefaultBaseURL == false
        ? path
        : "${NetworkConstant.baseUrlAPI}/$path";
    await _createHeaders();
    var parameter = json.encode(params);

    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers");
      timber("API Parameters -> $parameter");
    }

    if (await isConnected()) {
      if (showLoader) {
        EasyLoading.show();
      }
      try {
        var resp = await network
            .post(Uri.parse(callingURL), body: parameter, headers: _headers)
            .timeout(const Duration(minutes: 1));
        timber("API Resp -> ${resp.statusCode} ${resp.body}");
        EasyLoading.dismiss();
        if (resp.statusCode == 200 || resp.statusCode == 201) {
          return Future.value(NetworkResult.success(resp.body));
        } else if (resp.statusCode == 401 || resp.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(NetworkResult.error(resp.body));
        }
      } on TimeoutException catch (e) {
        logger.e(e);
        return Future.value(NetworkResult.timeout());
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      // _showNoInternetDialog(0, path, params, isLoader);
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callPutApi(
    String path,
    dynamic params,
    bool showLoader, {
    bool? useDefaultBaseURL,
  }) async {
    var callingURL = useDefaultBaseURL == false
        ? path
        : "${NetworkConstant.baseUrlAPI}/$path";
    await _createHeaders();
    var parameter = json.encode(params);

    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers");
      timber("API Parameters -> $parameter");
    }

    if (await isConnected()) {
      if (showLoader) {
        EasyLoading.show();
      }
      try {
        var resp = await network
            .put(Uri.parse(callingURL), body: parameter, headers: _headers)
            .timeout(const Duration(minutes: 1));
        timber("API Resp -> ${resp.statusCode} ${resp.body}");
        EasyLoading.dismiss();
        if (resp.statusCode == 200 || resp.statusCode == 201) {
          return Future.value(NetworkResult.success(resp.body));
        } else if (resp.statusCode == 401 || resp.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(NetworkResult.error(resp.body));
        }
      } on TimeoutException catch (e) {
        logger.e(e);
        return Future.value(NetworkResult.timeout());
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      // _showNoInternetDialog(0, path, params, isLoader);
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callDeleteApi(
    String path,
    dynamic params,
    bool showLoader, {
    bool? useDefaultBaseURL,
  }) async {
    var callingURL = useDefaultBaseURL == false
        ? path
        : "${NetworkConstant.baseUrlAPI}/$path";
    await _createHeaders();
    var parameter = json.encode(params);

    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers");
      timber("API Parameters -> $parameter");
    }

    if (await isConnected()) {
      if (showLoader) {
        EasyLoading.show();
      }
      try {
        var resp = await network
            .delete(Uri.parse(callingURL), body: parameter, headers: _headers)
            .timeout(const Duration(minutes: 1));
        timber("API Resp -> ${resp.statusCode} ${resp.body}");
        EasyLoading.dismiss();
        if (resp.statusCode == 200 || resp.statusCode == 201) {
          return Future.value(NetworkResult.success(resp.body));
        } else if (resp.statusCode == 401 || resp.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(NetworkResult.error(resp.body));
        }
      } on TimeoutException catch (e) {
        logger.e(e);
        return Future.value(NetworkResult.timeout());
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      // _showNoInternetDialog(0, path, params, isLoader);
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callGetApi(
    String path,
    dynamic params,
    bool isLoader, {
    bool? useDefaultBaseURL,
  }) async {
    var callingURL = useDefaultBaseURL == false
        ? Uri.parse(path).replace(queryParameters: params).toString()
        : Uri.parse(
            "${NetworkConstant.baseUrlAPI}/$path",
          ).replace(queryParameters: params).toString();
    //Uri? uri;
    await _createHeaders();
    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers", usePrint: true);
    }

    if (await isConnected()) {
      if (isLoader) {
        EasyLoading.show();
      }
      try {
        var resp = await network.get(Uri.parse(callingURL), headers: _headers);
        if (_isDebug) timber("API Response -> ${resp.statusCode} ${resp.body}");
        EasyLoading.dismiss();

        logger.i(resp.statusCode);
        if (resp.statusCode == 200) {
          return Future.value(NetworkResult.success(resp.body));
        } else if (resp.statusCode == 401 || resp.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(NetworkResult.error(resp.body));
        }
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      //  _showNoInternetDialog(1, path, params, isLoader);

      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callPostMultiPart(
    String path,
    dynamic params,
    bool isLoader,
    String uploadFilePath, {
    String dataPathName = "data",
    String imagePathName = "image",
  }) async {
    var callingURL = "${NetworkConstant.baseUrlAPI}/$path";
    /*  if (_notProperHeader())*/
    await _createHeadersForMultipart();

    // var parameter = json.encode(params);
    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers");
      // timber("API Parameters -> $parameter");
      timber("Selected Image Path -> $uploadFilePath");
    }

    if (await isConnected()) {
      if (isLoader) {
        EasyLoading.show();
      }
      var formData = FormData();
      if (params != null) {
        formData = FormData.fromMap(params.toJson());
      }

      if (uploadFilePath.isNotNullOrEmpty()) {
        var multipartFile = await MultipartFile.fromFile(uploadFilePath);
        formData.files.add(MapEntry(imagePathName, multipartFile));

        // formData = FormData.fromMap({
        //   dataPathName: parameter,
        //   imagePathName: await MultipartFile.fromFile(uploadFilePath)
        // });
      }

      // else {
      //   formData = FormData.fromMap({dataPathName: parameter});
      // }

      timber(formData.fields.map((e) => timber("~~~~~~~~`${e.value}")));
      timber(formData.files.map((e) => timber("~~~~~~~~`${e.value.filename}")));

      try {
        var dio = Dio();
        var responseString = await dio.post(
          callingURL,
          data: formData,
          options: Options(headers: _headers, contentType: "application/json"),
        );

        if (_isDebug) timber("API Response -> $responseString");
        EasyLoading.dismiss();
        if (responseString.statusCode == 200) {
          return Future.value(
            NetworkResult.success(json.encode(responseString.data)),
          );
        } else if (responseString.statusCode == 401 ||
            responseString.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(
            NetworkResult.error(json.encode(responseString.data)),
          );
        }
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callPostMultiPartForMultipleFiles(
    String path,
    List<String>? uploadFilePaths,
    bool isLoader, {
    String imagePathName = "personalPhotos",
  }) async {
    var callingURL = "${NetworkConstant.baseUrlAPI}/$path";
    await _createHeadersForMultipart();

    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers", usePrint: true);
      timber("Selected Image Path -> $uploadFilePaths");
    }

    if (await isConnected()) {
      if (isLoader) {
        EasyLoading.show();
      }
      List<MultipartFile> multiPartList = [];

      if (!uploadFilePaths.isNullOrEmpty()) {
        multiPartList = [];

        for (int i = 0; i < uploadFilePaths!.length; i++) {
          var localPath = uploadFilePaths[i];
          if (!localPath.isNullOrEmpty()) {
            var multipartFile = await MultipartFile.fromFile(
              uploadFilePaths[i],
            );
            multiPartList.add(multipartFile);
          }
        }
      }

      try {
        var formData = FormData.fromMap({imagePathName: multiPartList});
        var dio = Dio();
        var responseString = await dio.post(
          callingURL,
          data: formData,
          options: Options(headers: _headers, contentType: "application/json"),
        );

        if (_isDebug) timber("API Response -> $responseString");
        EasyLoading.dismiss();
        if (responseString.statusCode == 200) {
          return Future.value(
            NetworkResult.success(json.encode(responseString.data)),
          );
        } else if (responseString.statusCode == 401 ||
            responseString.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(
            NetworkResult.error(json.encode(responseString.data)),
          );
        }
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<NetworkResult> callPostMultiPartWithFromData(
    String path,
    FormData formData,
    bool isLoader, {
    String imagePathName = "image",
  }) async {
    var callingURL = "${NetworkConstant.baseUrlAPI}/$path";
    /* if (_notProperHeader()) */
    await _createHeadersForMultipart();
    if (_isDebug) {
      timber("API URL -> $callingURL");
      timber("API Headers -> $_headers", usePrint: true);
      timber("API Parameters -> ${formData.fields}");
    }

    if (await isConnected()) {
      if (isLoader) {
        EasyLoading.show();
      }
      try {
        var dio = Dio();
        var responseString = await dio.post(
          callingURL,
          data: formData,
          options: Options(headers: _headers, contentType: "application/json"),
        );

        if (_isDebug) timber("API Response -> $responseString");
        EasyLoading.dismiss();
        if (responseString.statusCode == 200) {
          return Future.value(
            NetworkResult.success(json.encode(responseString.data)),
          );
        } else if (responseString.statusCode == 401 ||
            responseString.statusCode == 403) {
          return Future.value(NetworkResult.unAuthorised());
        } else {
          return Future.value(
            NetworkResult.error(json.encode(responseString.data)),
          );
        }
      } catch (e, s) {
        EasyLoading.dismiss();
        if (_isDebug) {
          timber(e);
          timber(s);
        } else {
          // FirebaseCrashlytics.instance.recordError(e, s);
        }
        return Future.value(NetworkResult.cacheError());
      }
    } else {
      return Future.value(NetworkResult.noInternet());
    }
  }

  Future<void> _createHeaders() async {
    String authToken = SharedPrefUtils.getToken();
    // String authToken = Env.authToken;
    logger.d("Api header auth token ===> $authToken");

    if (authToken.isNotEmpty) {
      _headers = {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "platform": Platform.isIOS ? "ios" : "android",
        NetworkConstant.authorization: NetworkConstant.bearer + authToken,
      };
    } else {
      _headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "platform": Platform.isIOS ? "ios" : "android",
        //  NetworkConstant.authorization: "${NetworkConstant.bearer}b20f1291-1590-42c9-aacf-77548f268a70",
      };
    }
  }

  Future<void> _createHeadersForMultipart() async {
    String authToken = SharedPrefUtils.getToken();
    if (authToken.isNotEmpty) {
      _headers = {
        "Content-Type": "multipart/form-data",
        'Accept': '*/*',
        "platform": Platform.isIOS ? "ios" : "android",
        NetworkConstant.authorization: NetworkConstant.bearer + authToken,
      };
    } else {
      _headers = {
        'Accept': '*/*',
        "Content-Type": "multipart/form-data",
        "platform": Platform.isIOS ? "ios" : "android",
      };
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first == ConnectivityResult.mobile ||
        connectivityResult.first == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void makeHeaderNull() {
    _headers = null;
  }
}
