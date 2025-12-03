class AppConfig {
  // Web (Chrome/Edge) → Use 127.0.0.1 (localhost não funciona bem com Flutter web)
  static const String baseUrl = "http://127.0.0.1:8080/api";
  
  // Para Android Emulador, descomentar:
  // static const String baseUrl = "http://10.0.2.2:8080/api";
  
  // Para dispositivo físico na rede local:
  // static const String baseUrl = "http://SEU_IP_LOCAL:8080/api";
}