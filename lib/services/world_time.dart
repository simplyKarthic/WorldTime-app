import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{
  String location; //UI location name
  String time = " "; // time in that location
  String flag; // flag icon
  String url; // location url for api endpoint
  bool? isDaytime ; //day or night

  WorldTime({required this.location,required this.flag,required this.url});

  Future<void> getTime() async {

    try{
      Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      //get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);
      String sec_offset = data['utc_offset'].substring(4,6);
      String sign = data['utc_offset'].substring(0,1);
      //create datetime object
      DateTime now = DateTime.parse(datetime);
      if (sign == '+'){
        now = now.add(Duration(hours: int.parse(offset),minutes: int.parse(sec_offset)));
      }else{
        now = now.subtract(Duration(hours: int.parse(offset),minutes: int.parse(sec_offset)));
      }

      isDaytime = now.hour> 6 && now.hour < 18 ? true : false;

      time = DateFormat.jm().format(now);
      
    }catch(e){
  print('caught error: $e');
  time ="could not get data";
    }


  }

}

