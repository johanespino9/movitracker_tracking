
class IniciarRutaResponse {
  late String? resultado;
  late String? status;

  IniciarRutaResponse({
    required this.resultado,
    required this.status,
  });

  IniciarRutaResponse.empty() {
    resultado = null;
    status = null;
  }

  factory IniciarRutaResponse.fromJson(Map<String, dynamic> json) {
    return IniciarRutaResponse(
      resultado: json['resultado'],
      status: json['status'],
    );
  }
}