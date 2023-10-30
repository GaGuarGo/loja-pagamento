class CepAddress {
  final double? altitude;
  final String? cep;
  final double? latitude;
  final double? longitude;
  final String? logradouro;
  final String? bairro;
  final Cidade? cidade;
  final Estado? estado;

  CepAddress.fromJson(Map<String, dynamic> cep)
      : altitude = cep['altitude'] as double,
        cep = cep['cep'] as String,
        latitude = double.tryParse(cep['latitude'] as String),
        longitude = double.tryParse(cep['longitude'] as String),
        logradouro = cep['logradouro'] as String,
        bairro = cep['bairro'] as String,
        cidade = Cidade.fromMap(cep['cidade'] as Map<String, dynamic>),
        estado = Estado.fromMap(cep['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAddress{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade {
  final int? ddd;
  final String? ibge;
  final String? nome;

  Cidade.fromMap(Map<String, dynamic> map)
      : ddd = map['ddd'] as int,
        ibge = map['ibge'] as String,
        nome = map['nome'] as String;

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }
}

class Estado {
  final String? sigla;

  Estado.fromMap(Map<String, dynamic> map) : sigla = map['sigla'] as String;

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }
}
