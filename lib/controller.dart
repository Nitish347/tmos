import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tmos/utils.dart';

class Controller extends GetxController{
  RxInt part = 2.obs;
  RxList<Map<String, String>> bookPart = <Map<String,String>>[].obs;


  void onSelectPart(int index){
    if(index  == 0){
      bookPart.value = chapter1;
    }else{
      bookPart.value = chapter2;
    }
  }

}