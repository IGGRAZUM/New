void Parsing(String message){
 StaticJsonBuffer<200> jsonBuffer;
JsonObject& root = jsonBuffer.parseObject(message);
      long id = root["id"];
      long command_string = root["command_string"];
      //const char* command_string = root["command_string"];
      long position = root["position"];
     Id[position]= id;
     Command_string[position]=command_string;
      /*
      Serial.print("id= ");
      Serial.println(id);
      Serial.print("command_string= ");
  Serial.println(command_string);
  Serial.print("position= ");
  Serial.println(position);
  */
  return;
  }
