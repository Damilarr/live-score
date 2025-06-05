import 'package:http/http.dart' as http;

class ApiClient extends http.BaseClient {
  final _client = http.Client();
  final Map<String, String> _defaultHeaders = {
    // 'X-RapidAPI-Key': "5ae1957f24msh7480fa812cb6d31p1a25dfjsnd656442a125e",
    // 'X-RapidAPI-Key': "bc58866f9amsh9ad9a6c23dab0a8p1e35a0jsn983f5dde951c",
    'X-RapidAPI-Key': '617b9cb92amsh47805f07b4273b4p184d3fjsn98a9ad735986',
    // 'X-RapidAPI-Key': '8425a8bfe6mshd01d9504d2c7feep16d95ejsn3bf87ebd51c8',
    'X-RapidAPI-Host': 'free-api-live-football-data.p.rapidapi.com',
  };
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_defaultHeaders);
    return _client.send(request);
  }
}
