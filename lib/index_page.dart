import 'package:flutter/material.dart';
import 'package:weather_app/weather_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  clickGo() {
    Navigator.pushNamed(context, WeatherPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/index_wallpaper.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'พยากรณ์อากาศจากตำแหน่งของคุณ',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: clickGo,
                child: Text('เริ่มเลย'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.orangeAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
