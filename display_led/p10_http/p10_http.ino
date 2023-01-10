#include <ESP8266WiFi.h>
// As client
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>

//As Service
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>

// As subscriber
#include <PubSubClient.h>

// P10 Library
#include <DMDESP.h>
#include <fonts/Arial_bold_14.h>
#include <fonts/ElektronMart5x6.h>

// WiFi
const char *ssid = "Dim Dim 2809"; // Enter your WiFi name
const char *password = "123452828";  // Enter WiFi password

// MQTT Broker
const char *mqtt_broker = "4.tcp.ngrok.io";
const char *topic = "QUEUE_SYSTEM";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
const int mqtt_port = 14587;
String client_id = "display-loket-1";

//OLD will be removed
bool OLD_VERSION = false;
bool status;
String HOST = "192.168.0.2";
String ID = "1";

String BASE_URL = "http://" + HOST + "/ANTRIAN/smart/service/";
String GET_LAST_QUEUE_URL = BASE_URL + "/esp/antrian_akhir_display_simple/";
String UPDATE_IP_ADDRESS_URL = BASE_URL + "/display_loket/update/";
String txt_display= "Starting";

MDNSResponder mdns;
ESP8266WebServer server(80);
HTTPClient http;
// OLD will be removed

WiFiClient espClient;
PubSubClient client(espClient);
#define DISPLAYS_WIDE 1 // Kolom Panel
#define DISPLAYS_HIGH 1 // Baris Panel
DMDESP Disp(DISPLAYS_WIDE, DISPLAYS_HIGH);  // Jumlah Panel P10 yang digunakan (KOLOM,BARIS)

//Declare methods
void draw_text(String, unsigned int, unsigned int, String);
void draw_text_two_column(String, String);
bool request(String);

void setup() {
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
    // connect_to_mqtt_broker();
  }
}

void loop() {
  Disp.loop(); // Jalankan Disp loop untuk refresh LED
  server.handleClient();    
}

void connect_to_wifi(){
  WiFi.begin(ssid, password);  

  while (WiFi.status() != WL_CONNECTED) {            
    delay(500);   
  }

  Serial.println("WIFI: CONNECTED");
}

void start_mdns(){
  if (!mdns.begin(client_id)){
    Serial.println("MDNS: CREATED");
  }
}

void receive_request(){
  server.on("/", []() { 
    draw_text(server.arg("txt"), 0, 0, "big");
  });
}

void update_ip_address(){  
  request(UPDATE_IP_ADDRESS_URL + "?ID="+ID+"&ip_address=" + WiFi.localIP().toString());    
}

void get_last_queue_number(){  
  status = request(GET_LAST_QUEUE_URL + "?display_loket_ID=" + ID);
  if(status){
    draw_text()
  }
}

void connect_to_mqtt_broker(){
  String status = "connected";
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);

  while (!client.connected()) {            
    draw_text_two_column("mqtt", "connecting");
    delay(500);

    client_id += String(WiFi.macAddress());

    Serial.printf("The client %s connects to the public mqtt broker\n", client_id.c_str());

    if (!client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {                
      Serial.print("Mqtt failed state");
      Serial.print(" = ");
      Serial.print(client.state());
      status = "failed";        
    }
  }
  // publish and subscribe  
  client.subscribe(topic);
  client.publish(topic, "Hello mqtt");
  draw_text_two_column("mqtt", status);
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
}

void request(String address, bool draw_text){  
  http.begin(espClient, address);
  status = (http.GET() == HTTP_CODE_OK);
  const String response = http.getString();
  
  if(draw_text) draw_text(response, 0, 0, "big")
  
  Serial.print("REQUEST");
  Serial.print("Request to -> ");
  Serial.print(address);
  Serial.print("=");
  Serial.print(response);
  http.end();
}

void draw_text(String message, unsigned int x=0, unsigned int y=0, String size="small"){
  if(size == "big") Disp.setFont(Arial_bold_14);  
  else Disp.setFont(ElektronMart5x6);
  
  Disp.drawText(x, y, message);
  Serial.println(message);
}

void draw_text_two_column(String message1, String message2){
  draw_text(message1, 0 ,0);
  draw_text(message2, 0, 8);
}
