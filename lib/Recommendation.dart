import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HostInfo.dart';

class RecommendationPage extends StatefulWidget {
   RecommendationPage({Key? key, required this.data}) : super(key: key);
   final Map data;

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List _hosts = [];
  bool isSending = true;
  @override
  void initState(){
    super.initState();
    _getRecommendation();
  }

  Future<void> _getRecommendation() async{
    var url = 'https://host4me.marisabelchang.repl.co/recommend';
    var body = json.encode(widget.data);
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body:body
    );
    if(response.statusCode == 200){
      var result = jsonDecode(response.body);
      setState(() {
        _hosts = result;
        isSending = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        title: const Text('Recommendation'),
      ),
      body: isSending ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Analyzing'),),


          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _hosts.length,
        itemBuilder: (BuildContext context, int i){
          return Card(
            child: ListTile(
              leading: Text(
                '${_hosts[i]['distance']} mile', style: TextStyle(color: Colors.green),
              ),
              title: Text(
                _hosts[i]['name'],
                    style: TextStyle(fontSize: 20),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline,color: Colors.amber,),
                tooltip: 'More Info',
                onPressed: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => HostInfoPage(info: _hosts[i])));
                },
              ),
            ),
          );
        }
      )
    );
  }
  Widget buildCustomBar(Size size, String text){
    return Container(
    height: size.height * 0.04,
    width: double.infinity,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0,-5),
          color:Colors.grey,
          blurRadius: 15,
          spreadRadius: 5
        )
      ]
    ),
    child: Center(
      child: Text(
        text, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black54, fontSize:25),
      ),
    ),
    );
  }
}
