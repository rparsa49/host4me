import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_application/Recommendation.dart';



class SmartPage extends StatefulWidget {
  const SmartPage({Key? key}) : super(key: key);

  @override
  State<SmartPage> createState() => _SmartPageState();
}

class _SmartPageState extends State<SmartPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  Map transportMap = {
    'Bus':false,
    'Trolley':false,
    'Metro/Subway':false,
    'Train':false,
  };
  @override
  void initState(){
    super.initState();
  }
  Map _getData(){
    Map<String, dynamic> data = {
      'address': addressController.text.trim(),
      'nationality': nationalityController.text.trim(),
      'bus': transportMap['Bus']? 1:0,
      'train': transportMap['Train']? 1:0,
      'trolley': transportMap['Trolley']? 1:0,
      'metro': transportMap['Metro/Subway']? 1:0,
      'distance': double.parse(distanceController.text.trim())

    };
    return data;
  }
  void reset(){
    addressController.text = '';
    nationalityController.text = '';
    transportMap = {
      'Bus':false,
      'Trolley':false,
      'Metro/Subway':false,
      'Train':false,
    };
    distanceController.text = '';
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Recommendation'),
      ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller:addressController,
                  decoration:InputDecoration(
                    labelText: 'School Address(Example: 300 Amherst Rd Belchertown, MA 01007)',
                  ),
                ),
                TextField(
                  controller: nationalityController,
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                  ),
                ),
                TextField(
              controller: distanceController,
              decoration: InputDecoration(
                labelText: 'Preferred Distance from the Address(miles)',
              ),
            ),
                SizedBox(height: 10),
                const Text(
                  'Transportation', style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10,),
                ListView.builder(
                  primary: false,
                    shrinkWrap: true,
                    itemCount: transportMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = transportMap.keys.elementAt(index);
                      return CheckboxListTile(
                        title: Text(key),
                          value: transportMap[key],
                          onChanged: (bool?value){
                          setState(() {
                            transportMap[key] = value;
                          });
                          });
                }),
                SizedBox(height: 20,),
                ElevatedButton(
                  child: Text('Get Recommendation'),
                    onPressed:(){
                    var data = _getData();
                    reset();
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => RecommendationPage(data:data,)));})
                  ],
            ),
          ),
        ),
    );
  }
}
