import 'package:http/http.dart' as http;

class ApiClient extends http.BaseClient {
  final _client = http.Client();
  final List<String> _apiKeys = [
    '5ae1957f24msh7480fa812cb6d31p1a25dfjsnd656442a125e',
    'bc58866f9amsh9ad9a6c23dab0a8p1e35a0jsn983f5dde951c',
    '617b9cb92amsh47805f07b4273b4p184d3fjsn98a9ad735986',
    '8425a8bfe6mshd01d9504d2c7feep16d95ejsn3bf87ebd51c8',
  ];
  int _currentKeyIndex = 0;

  Map<String, String> _getHeaders() {
    return {
      'X-RapidAPI-Key': _apiKeys[_currentKeyIndex],
      'X-RapidAPI-Host': 'free-api-live-football-data.p.rapidapi.com',
    };
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    int initialKeyIndex = _currentKeyIndex;
    int attempts = 0;

    while (attempts < _apiKeys.length) {
      // Create a new request for each attempt because headers cannot be modified after sending
      final newRequest = _copyRequest(request);
      newRequest.headers.addAll(_getHeaders());

      final response = await _client.send(newRequest);

      if (response.statusCode == 429) {
        print(
          'API key ${_apiKeys[_currentKeyIndex]} hit rate limit. Rotating key.',
        );
        _currentKeyIndex = (_currentKeyIndex + 1) % _apiKeys.length;
        attempts++;
        if (_currentKeyIndex == initialKeyIndex && attempts > 0) {
          print('All API keys have hit rate limits.');
          return response; // Return the last 429 response
        }
        continue;
      }
      return response;
    }

    print('All API keys failed. Returning last 429 response.');
    final finalRequest = _copyRequest(request);
    finalRequest.headers.addAll(_getHeaders());
    return _client.send(finalRequest);
  }

  // Helper to copy the original request as it might have already been sent or prepared
  http.BaseRequest _copyRequest(http.BaseRequest original) {
    final http.BaseRequest requestCopy;

    if (original is http.Request) {
      requestCopy =
          http.Request(original.method, original.url)
            ..bodyBytes = original.bodyBytes
            ..encoding = original.encoding
            ..followRedirects = original.followRedirects
            ..headers.addAll(original.headers) // Copy original headers first
            ..maxRedirects = original.maxRedirects
            ..persistentConnection = original.persistentConnection;
    } else if (original is http.MultipartRequest) {
      requestCopy =
          http.MultipartRequest(original.method, original.url)
            ..fields.addAll(original.fields)
            ..files.addAll(original.files)
            ..headers.addAll(original.headers) // Copy original headers first
            ..followRedirects = original.followRedirects
            ..maxRedirects = original.maxRedirects
            ..persistentConnection = original.persistentConnection;
    } else if (original is http.StreamedRequest) {
      throw UnimplementedError(
        'Cloning StreamedRequest is not straightforwardly supported in this example. Consider using http.Request for simplicity if possible.',
      );
    } else {
      throw UnimplementedError(
        'Request type ${original.runtimeType} not supported for copying in this example.',
      );
    }
    return requestCopy;
  }
}
