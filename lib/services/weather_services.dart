import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/keys.dart';
import '../models/weather_model.dart';

class WeatherServices {
  String cityName = 'London';

  Future<WeatherModel> getWeatherData() async {
    String url = 'https://api.openweathermap.org/data/2.5/forecast?q=London&APPID=$weatherMapApiKey';

    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        WeatherModel weatherModel = WeatherModel.fromJson(data);
        return weatherModel;
      } else {
        throw Exception("No Data Found");
      }
    } catch (e) {
      rethrow;
    }
  }
}
