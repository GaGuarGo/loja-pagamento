class CepAddress {
  final String? cep;
  final String? logradouro;
  final String? bairro;
  final String? cidade;
  final String? estado;

  CepAddress.fromJson(Map<String, dynamic> cep)
      : cep = cep['cep'] as String,
        logradouro = cep['logradouro'] as String,
        bairro = cep['bairro'] as String,
        cidade = cep['localidade'],
        estado = cep['uf'];

  @override
  String toString() {
    return 'CepAddress logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}
