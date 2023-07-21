class IniciarRuta {
  final String resultado;
  final bool status;

  IniciarRuta(
    {
      required this.resultado,
      required this.status,
    }
  );

  factory IniciarRuta.fromJson(Map<String, dynamic> json) {
    return IniciarRuta(
      resultado: json['resultado'],
      status: json['status'],
    );
  }
}