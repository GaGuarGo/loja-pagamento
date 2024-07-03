import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cep_address.dart';

const token = '98a1f7082f95f7685dcbb404a2e3d180';

class CepAbertoService {
  Future<CepAddress?> getAddressFromCep(String cep) async {
    final cleanCEP = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCEP";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = "Token token=$token";

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data!.isEmpty) {
        return Future.error("CEP INVÁLIDO");
      }

      final address = CepAddress.fromJson(response.data!);

      return address;
    } on DioException catch (e) {
      return Future.error("ERRO AO BUSCAR CEP ${e.message.toString()}");
    }
  }
}
