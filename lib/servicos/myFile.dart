import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyFile{

  Future<File> _getFile() async{
    final filePath = await getApplicationDocumentsDirectory();
    return File("${filePath.path}/data.json");
  }

  Future<File> saveData(List listaTarefas) async{
    String data = json.encode(listaTarefas);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    } catch(e){
      return null;
    }

  }

}