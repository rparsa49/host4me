import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HostInfoPage extends StatefulWidget {
  const HostInfoPage({Key? key, required this.info }) : super(key: key);
  final Map info;

  @override
  State<HostInfoPage> createState() => _HostInfoPageState();
}

class _HostInfoPageState extends State<HostInfoPage> {
  String getTransport() {
    String Transport = '';
    Transport = widget.info['bus']? 'bus, ': ' ';
    Transport += widget.info['metro/subway']? 'metro/subway, ': ' ';
    Transport += widget.info['trolley']? 'trolley, ': ' ';
    Transport += widget.info['train']? 'train, ': ' ';
    return Transport.isNotEmpty? Transport: 'None';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Host Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildCustomBar(size, 'Host Info'),
            SizedBox(
              height: 10,
            ),
            Text(
              'Address: ' + widget.info!['address'],
              style: const TextStyle(fontSize: 20),
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Nationality: ' + widget.info!['nationality'],
              style: const TextStyle(fontSize: 20),
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Transportation: ' + getTransport(),
              style: const TextStyle(fontSize: 20),
              maxLines: 3,
            ),
            SizedBox(
              height: 50,
            ),
            buildCustomBar(size, 'Contact'),
              Text(
                'Email: ' + widget.info!['email'],
                style: const TextStyle(fontSize: 20),
                maxLines: 2,
              ),
              const SizedBox(
                height: 10,
              ),
            Text(
              'Phone: ' + widget.info!['phone'],
              style: const TextStyle(fontSize: 20),
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
    Widget buildCustomBar(Size size, String text){
      return Container(
        height: size.height * 0.04,
        width: double.infinity,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0,-5),
              color: Colors.grey,
              blurRadius: 15,
              spreadRadius: 5
            )
          ]
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.brown),
          )
        ),

      );
    }
  }

