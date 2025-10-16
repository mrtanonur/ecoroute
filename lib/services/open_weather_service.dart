import 'package:dio/dio.dart';
import 'package:ecoroute/dependency_injection.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenWeatherService {
  final Dio dio = sl.get<Dio>();

  Future<Either<String, int>> getAirPollutionData(
    double latitude,
    double longitude,
  ) async {
    try {
      final airPollutionApiKey = dotenv.env["AIR_POLLUTION"];
      String baseUrl =
          "http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$airPollutionApiKey";
      final response = await dio.get(baseUrl);
      return Right(response.data["list"][0]["main"]["aqi"]);
    } on DioException catch (exception) {
      return Left(exception.message!);
    }
  }
}
