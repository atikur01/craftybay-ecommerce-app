import 'package:crafty_bay/app/get_network_caller.dart';
import 'package:crafty_bay/app/urls.dart';
import 'package:crafty_bay/core/service/network_caller/network_caller.dart';
import 'package:crafty_bay/features/home/data/models/slider_model.dart';
import 'package:flutter/foundation.dart';

class HomeSlidersProvider extends ChangeNotifier {
  bool _getSlidersInProgress = false;

  List<SliderModel> _sliders = [];

  String? _errorMessage;

  bool get getSlidersInProgress => _getSlidersInProgress;

  List<SliderModel> get sliders => _sliders;

  String? get errorMessage => _errorMessage;

  Future<bool> getSliders() async {
    bool isSuccess = false;

    _getSlidersInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      Urls.homeSlidersUrl,
    );
    if (response.isSuccess) {
      List<SliderModel> sliderModels = [];
      for (Map<String, dynamic> model in response.body['data']['results']) {
        sliderModels.add(SliderModel.fromJson(model));
      }
      _sliders = sliderModels;
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getSlidersInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
