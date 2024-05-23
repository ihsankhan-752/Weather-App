import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/weather_services.dart';

import '../models/weather_model.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({super.key});

  @override
  State<WeatherMainScreen> createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  WeatherServices weatherServices = WeatherServices();
  Future<WeatherModel>? _weatherModel;

  @override
  void initState() {
    _weatherModel = getWeatherData();
    super.initState();
  }

  Future<WeatherModel> getWeatherData() async {
    return await weatherServices.getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff29233c),
      appBar: AppBar(
        backgroundColor: const Color(0xff29233c),
        elevation: 10,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Weather Updates",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _weatherModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            WeatherModel weatherModel = snapshot.data!;

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('d MMMM, y').format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                  child: Text(
                                weatherModel.city!.name!,
                                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                              )),
                              const SizedBox(height: 10),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _kelvinToCelsius(weatherModel.list![0].main!.temp!.toDouble()).toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 35,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Transform.translate(
                                          offset: const Offset(2, -10),
                                          child: const Text(
                                            '°C',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 05),
                              if (weatherModel.list![0].weather!.isNotEmpty) ...{
                                if (weatherModel.list![0].weather![0].main == 'Clouds') ...{
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Cloudy",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.cloud, color: Colors.white),
                                    ],
                                  ),
                                },
                                if (weatherModel.list![0].weather![0].main == 'Rain') ...{
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rain",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.cloudy_snowing, color: Colors.white),
                                    ],
                                  ),
                                },
                                if (weatherModel.list![0].weather![0].main == 'Clear') ...{
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Clear",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.sunny, color: Colors.amber),
                                    ],
                                  ),
                                },
                              },
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: weatherModel.list!.length - 1,
                        itemBuilder: (context, index) {
                          var weatherItem = weatherModel.list![index];
                          var nextWeatherItem = weatherModel.list![index + 1];

                          return Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            width: 90,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white.withOpacity(.2), width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.white.withOpacity(0.25), offset: const Offset(1, 1)),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: const Offset(5, 4),
                                  blurRadius: 10,
                                ),
                              ],
                              color: const Color(0xff48319d).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      DateFormat.j().format(
                                        DateTime.parse(nextWeatherItem.dtTxt!),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (nextWeatherItem.weather!.isNotEmpty) ...{
                                    if (nextWeatherItem.weather![0].main == 'Clouds') ...{
                                      const Icon(Icons.cloud, color: Colors.white),
                                    },
                                    if (nextWeatherItem.weather![0].main == 'Rain') ...{
                                      const Icon(Icons.cloudy_snowing, color: Colors.white),
                                    },
                                    if (nextWeatherItem.weather![0].main == 'Clear') ...{
                                      const Icon(Icons.sunny, color: Colors.amber),
                                    },
                                  },
                                  Center(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _kelvinToCelsius(weatherItem.main!.temp!.toDouble()).toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(2, 8),
                                              child: const Text(
                                                '°',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OtherInformationCard(
                            title: "Wind",
                            value: "${weatherModel.list![0].wind!.speed} km/h",
                            icon: "images/wind.png",
                          ),
                          OtherInformationCard(
                            title: "Pressure",
                            value: "${weatherModel.list![0].main!.pressure} MB",
                            icon: "images/pressure.png",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OtherInformationCard(
                            title: "Humidity",
                            value: "${weatherModel.list![0].main!.humidity}%",
                            icon: "images/humidity.png",
                          ),
                          OtherInformationCard(
                            title: "Sun Rise",
                            value:
                                DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(weatherModel.city!.sunrise! * 1000)),
                            icon: "images/sun_rise.png",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}

class OtherInformationCard extends StatelessWidget {
  final dynamic value;
  final String icon;
  final String title;
  const OtherInformationCard({super.key, this.value, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.sizeOf(context).width * .42,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey), boxShadow: [
        BoxShadow(
          blurRadius: 2,
          color: Colors.black.withOpacity(0.1),
        ),
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: Image.asset(icon, color: Colors.white, fit: BoxFit.cover),
          ),
          const SizedBox(height: 08),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 05),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
