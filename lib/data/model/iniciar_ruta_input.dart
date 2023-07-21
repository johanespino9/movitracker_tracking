class IniciarRutaInput {
  final String solicitudID;
  final String usuarioID;
  final String latitude;
  final String longitude;

  IniciarRutaInput({required this.solicitudID, required this.usuarioID, required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'solicitud_id': solicitudID,
      'usuario_id': usuarioID,
      'latitud': latitude,
      'longitud': longitude,
    };
  }
}