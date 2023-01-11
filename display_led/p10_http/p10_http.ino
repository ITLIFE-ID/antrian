#include <ESP8266WiFi.h>
// As client
#include <ESP8266mDNS.h>
// As subscriber
#include <PubSubClient.h>
// P10 Library
#include <DMDESP.h>
#include <fonts/Arial_bold_14.h>
#include <fonts/ElektronMart6x8.h>

#include <ArduinoJson.h>
// WiFi
const char *ssid = "Dim Dim 2809"; // Enter your WiFi name
const char *password = "123452828";  // Enter WiFi password

// MQTT Broker
const char *mqtt_broker = "8.tcp.ngrok.io";
const int mqtt_port = 10351;  
const char *topic = "QUEUE_SYSTEM";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
String client_id = "display-loket-1";

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

MDNSResponder mdns;
WiFiClient espClient;
PubSubClient client(espClient);
#define DISPLAYS_WIDE 1 // Kolom Panel
#define DISPLAYS_HIGH 1 // Baris Panel
DMDESP Disp(DISPLAYS_WIDE, DISPLAYS_HIGH);  // Jumlah Panel P10 yang digunakan (KOLOM,BARIS)
DynamicJsonDocument doc(1024);

//Declare methods
void draw_text(String, unsigned int, unsigned int, String);
void draw_text_two_column(String, String);
void request(String, bool);
void draw_queue_number(String);

void setup() {
  Serial.begin(115200);
  Disp.start(); // Jalankan library DMDESP
  Disp.setBrightness(255); // 0-255    
  connect_to_wifi();
  start_mdns();

  if(OLD_VERSION){
    update_ip_address();
    get_last_queue_number();
    receive_request();
  }
  else{
    connect_to_mqtt_broker();
  }
}

void loop() {
  Disp.loop();
  server.handleClient();   
  client.loop(); 
}

void connect_to_wifi(){
  WiFi.begin(ssid, password);  

  while (WiFi.status() != WL_CONNECTED) {   
    Serial.println("WIFI: CONNECTING");        
    delay(500);   
  }

  Serial.println("WIFI: CONNECTED");
}

void start_mdns(){
  if (mdns.begin("esp8266", WiFi.localIP())) Serial.println("MDNS: Success");
}

void receive_request(){
  server.on("/", []() { 
    const String param = server.arg("txt");
    server.send(200, "text/plain", "{" + param + "}");
    draw_text(param, 0, 0, "big");
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

  while (!client.connected()) {                
    client_id += String(WiFi.macAddress());

    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());

    if (!client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {                
      Serial.print("MQTT: STATE FAILED");
      Serial.print(" = ");
      Serial.print(client.state());
      status = "failed";        
    }

    delay(500);
  }

  draw_text_two_column("MQTT", "READY");    
  Serial.println("MQTT: CONNECTED");
  // publish and subscribe    
  client.subscribe(topic);  
  delay(5000);
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
      draw_text(queue_number, 0, 0, "big");
    }
  }
}

void request(String address, bool must_draw_text){  
  http.begin(espClient, address);
  status = (http.GET() == HTTP_CODE_OK);
  const String response = http.getString();
  
  if(must_draw_text) draw_text(response, 0, 0, "big");
  
  Serial.print("REQUEST TO ");
  Serial.print(address);
  Serial.print("->");
  Serial.print(response);
  http.end();
}

void draw_text(String message, unsigned int x=0, unsigned int y=0, String size="small"){
  if(size == "big") Disp.setFont(Arial_bold_14);  
  else Disp.setFont(ElektronMart6x8);
  
  Disp.drawText(x, y, message);
  Serial.print("DrawText: ");
  Serial.println(message);
}

void draw_text_two_column(String message1, String message2){
  draw_text(message1, 0 ,0);
  draw_text(message2, 0, 8);
}
