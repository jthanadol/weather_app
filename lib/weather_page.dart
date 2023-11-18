import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/weather_item.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  static const routeName = 'weather page';

  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Dio _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  WeatherItem? _weatherItem;
  Position? _position;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  getWeather() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(_position!.latitude);
      print(_position!.longitude);

      var response = await _dio.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${_position!.latitude}8&lon=${_position!.longitude}&appid=266b8dfb69bb2725262c958ea887de08&lang=th');
      print(response.toString());
      Map<String, dynamic> s = jsonDecode(response.data.toString());
      _weatherItem = WeatherItem.fromJson(s);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildLoadingOverlay() => Container(
        color: Colors.black.withOpacity(0.2),
        child: Center(child: CircularProgressIndicator()));

    buildError() => Center(
        child: Padding(
            padding: const EdgeInsets.all(40.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_errorMessage ?? '', textAlign: TextAlign.center),
              SizedBox(height: 32.0),
              ElevatedButton(onPressed: getWeather, child: Text('Retry'))
            ])));

    buildPage() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                _weatherItem!.name.toString(),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${_weatherItem!.weather!.icon.toString()}@2x.png',
                  ),
                  Text(
                    _weatherItem!.weather!.description.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${((_weatherItem!.main!.temp)! - (273.15)).toStringAsFixed(2)} °C',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Feel like ${((_weatherItem!.main!.feelsLike)! - 273.15).toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'อุณหภูมิสูงสุด ${((_weatherItem!.main!.tempMax)! - 273.15).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '|',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Text(
                        'อุณหภูมิต่ำสุด ${((_weatherItem!.main!.tempMin)! - 273.15).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.water_drop, size: 24),
                      Text(
                        'Humidity',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${_weatherItem!.main!.humidity}%',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 40),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.air, size: 24),
                      Text(
                        'Wind',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${_weatherItem!.wind!.speed} m/s',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 40),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.wind_power, size: 24),
                      Text(
                        'ความกดอากาศบนพื้นดิน',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${_weatherItem!.main!.grndLevel} hPa',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg_sky.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            if (_weatherItem != null) buildPage(),
            if (_errorMessage != null) buildError(),
            if (_isLoading) buildLoadingOverlay()
          ],
        ),
      ),
    );
  }
}
