import 'package:flutter/material.dart';
import 'package:flutter_application_1/location/location.dart';
import 'package:flutter_application_1/weather/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late LocationHelper locationData;

  Future<void> getLocationData() async {
    locationData = LocationHelper();
    await locationData.checkService();
    if (locationData.latitude == null || locationData.longitude == null) {
      print("Konum bilgileri gelmiyor");
    } else {
      print(
          "latitude: ${locationData.latitude.toString()} longitude: ${locationData.longitude.toString()}");
    }
  }

  Future<void> getWeatherData() async {
    await getLocationData();
    print("Lat: ${locationData.latitude}, Lon: ${locationData.longitude}");
    if (locationData.latitude == null || locationData.longitude == null) {
      print("konum boş");
      return;
    }
    WeatherData weatherData = WeatherData(locationData: locationData);
    await weatherData.getCurrentTempature();
    if (weatherData.currentTempature == null ||
        weatherData.currentCondition == null) {
      print("Hava durumu bilgisi alınamadı.");
      return;
    }
    weatherDisplayInfo(weatherData);
  }

  void weatherDisplayInfo(WeatherData weatherData) {
    setState(
      () {
        tempature = weatherData.currentTempature!.round();
        WeatherDisplayData? weatherDisplayData =
            weatherData.getWeatherDisplayData();
        if (weatherDisplayData != null) {
          backgroundImage = weatherDisplayData.weatherImage;
          weatherDisplayIcon = weatherDisplayData.weatherIcon;
        } else {
          print("weatherDisplayData null döndü");
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      getWeatherData();
    });
  }

  int? tempature;
  Icon? weatherDisplayIcon;
  AssetImage? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundImage == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: backgroundImage!,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: weatherDisplayIcon ??
                          Icon(FontAwesomeIcons.question,
                              size: 110, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "$tempature °",
                      style: TextStyle(
                          fontSize: 80,
                          letterSpacing: -10,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
