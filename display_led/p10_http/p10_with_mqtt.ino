//============================================WIFI============================================
#include <ESP8266WiFi.h>
const char *ssid = "Dim Dim 2809";
const char *password = "123452828";
WiFiClient espClient;
//============================================END WIFI============================================

//============================================MDNS============================================
#include <ESP8266mDNS.h>
MDNSResponder mdns;
//============================================END MDNS============================================

//============================================MQTT============================================
#include <PubSubClient.h>
PubSubClient client(espClient);
const char *mqtt_broker = "8.tcp.ngrok.io";
const int mqtt_port = 10351;  
const char *topic = "QUEUE_SYSTEM";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
String client_id = "display-loket-1";
//============================================END MQTT============================================

//============================================P10 LED============================================
#include <SPI.h>
#include <DMD2.h>
#include <fonts/Arial_Black_16.h>
#include <fonts/Arial14.h>
#define pin_A 16
#define pin_B 12
#define pin_sclk 0
#define pin_clk 14
#define pin_r 13
#define pin_noe 15
#define DISPLAYS_WIDE 1
#define DISPLAYS_HIGH 1
SPIDMD dmd(DISPLAYS_WIDE, DISPLAYS_HIGH, pin_noe, pin_A, pin_B, pin_sclk);
const byte PanelWidth = 32;
const byte MaxStringLength = 5;
char CharBuf[MaxStringLength + 1];
//============================================END P10 LED============================================

//============================================ARDUINO JSON============================================
#include <ArduinoJson.h>
DynamicJsonDocument doc(1024);
//============================================END ARDUINO JSON============================================

//============================================OLD will be removed============================================
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WebServer.h>

bool OLD_VERSION = false;
bool status;
String HOST = "192.168.0.2";
String ID = "1";

String BASE_URL = "http://" + HOST + "/ANTRIAN/smart/service/";
String GET_LAST_QUEUE_URL = BASE_URL + "/esp/antrian_akhir_display_simple/";
String UPDATE_IP_ADDRESS_URL = BASE_URL + "/display_loket/update/";
String txt_display= "Starting";
ESP8266WebServer server(80);
HTTPClient http;
//============================================OLD will be removed============================================

//Declare methods
void request(String, bool);
void draw_status(String source, int sts, int);

void setup() {
  Serial.begin(115200);  
  dmd.setBrightness(255);  
  dmd.begin(); 
  draw_status("START", 0, 3000);

  // connect_to_wifi();
  // start_mdns();

  // if(OLD_VERSION){
  //   update_ip_address();
  //   get_last_queue_number();
  //   receive_request();
  // }
  // else{
  //   connect_to_mqtt_broker();
  // }
}

void loop() {
  // server.handleClient();   
  // client.loop(); 
  delay(3000);
}

void connect_to_wifi(){  
  WiFi.begin(ssid, password);  
  draw_status("WIFI", 0, 3000);  

  while (WiFi.status() != WL_CONNECTED) {   
    draw_status("WIFI", 1, 500);
  }

  draw_status("WIFI", 2, 3000);
}

void start_mdns(){
  if (mdns.begin("esp8266", WiFi.localIP())){
    draw_status("MDNS", 2, 3000);
  }
}

void receive_request(){
  server.on("/", []() { 
    const String param = server.arg("txt");
    server.send(200, "text/plain", "{" + param + "}");
    draw_center(param);
  });
}

void update_ip_address(){  
  const String ip_address= WiFi.localIP().toString();
  const String url = UPDATE_IP_ADDRESS_URL + "?ID="+ID+"&ip_address=" + ip_address;
  Serial.println("Update IP Address");
  request(url, true);    
}

void get_last_queue_number(){  
  const String url = GET_LAST_QUEUE_URL + "?display_loket_ID=" + ID;
  Serial.println("Get last queue number");
  request(url, false);  
}

void connect_to_mqtt_broker(){
  String status = "connected";
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  draw_status("MQTT", 0, 3000);

  while (!client.connected()) {     
    client_id += String(WiFi.macAddress());

    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());

    if (!client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {                
      draw_center("MQTT:ERR");
      Serial.print("MQTT: STATE FAILED");
      Serial.print(" = ");
      Serial.print(client.state());
      status = "failed";        
    }

    draw_status("MQTT", 1, 500);
  }

  client.subscribe(topic);
  draw_status("MQTT", 2, 3000);
}

void callback(char *topic, byte *payload, unsigned int length) {
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message:");
  for (int i = 0; i < length; i++) {
    Serial.print((char) payload[i]);
  }
  Serial.println();
  Serial.println("-----------------------");

  const String data = String((char*)payload);
  draw_queue_number(data);
}

void draw_queue_number(String json){
  if(!deserializeJson(doc, json)) {
    Serial.println("parseObject() failed");    
  }
  else{
    const String from = doc["from"];
    const String action = doc["action"];
    const String client_display_ip_address = doc["client_display_ip_address"];
    const String queue_number = doc["current_queue_in_counter_text"];
    const String ip_address =  WiFi.localIP().toString();

    if(from == "server" && (action == "call" || action == "recall")){    
      draw_center(queue_number);
    }
  }
}

void request(String address, bool must_draw_text){  
  http.begin(espClient, address);
  status = (http.GET() == HTTP_CODE_OK);
  const String response = http.getString();
  
  if(must_draw_text) draw_center(response);
  
  Serial.print("REQUEST TO ");
  Serial.print(address);
  Serial.print("->");
  Serial.print(response);
  http.end();
}

void draw_status(String source, int sts, int delayed){
  String status[] = {"INITIALIZE", "CONNECTING", "CONNECTED", "FAILED"};
  draw_center(source +":"+ String(sts));
  Serial.println(source + ":" + String(sts));
  delay(delayed);
}

void draw_center(String input_Str) {
  byte charCount, total_charWidth, x_position,tinggi;
  input_Str.toCharArray(CharBuf, MaxStringLength + 1); //string to char array
  
  charCount=  input_Str.length();
  if (charCount==0) exit;
  else if(charCount<=3){dmd.selectFont(Arial_Black_16);tinggi=1;}
  else if(charCount==4){dmd.selectFont(Arial14);tinggi=2;}
  else if (charCount > 4) exit;
  
 
  total_charWidth= 0;
  for (byte thisChar = 0; thisChar <charCount; thisChar++) {
    total_charWidth= total_charWidth + dmd.charWidth(CharBuf[thisChar]) +1; //add 1 pixel for space
  }  
 
  total_charWidth= total_charWidth -1; //no space for last letter
  x_position= (PanelWidth - total_charWidth) /2; //position(x) of first letter
  dmd.clearScreen();
 
  for (byte thisChar = 0; thisChar <charCount; thisChar++) {
    //dmd.drawChar(x, y,‘@', GRAPHICS_NORMAL)
    dmd.drawChar( x_position,  tinggi, CharBuf[thisChar] );
    x_position= x_position + dmd.charWidth(CharBuf[thisChar]) + 1; //position for next letter
  }  
}