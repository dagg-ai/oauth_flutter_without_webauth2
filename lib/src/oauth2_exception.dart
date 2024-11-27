/// Exception to present all oauth2 exceptions
class OAuth2Exception implements Exception {
  /// The OAuth2 fault
  final String fault;

  /// The callback URI retrieved
  final String? fullUri;

  /// The error from fullUri.
  ///
  /// a single ASCII error code from the following list:
  /// - invalid_request - the request is missing a parameter, contains an invalid parameter, includes a parameter more than once, or is otherwise invalid.
  /// - access_denied - the user or authorization server denied the request
  /// - unauthorized_client - the client is not allowed to request an authorization code using this method, for example if a confidential client attempts to use the implicit grant type.
  /// - unsupported_response_type - the server does not support obtaining an authorization code using this method, for example if the authorization server never implemented the implicit grant type.
  /// - invalid_scope - the requested scope is invalid or unknown.
  /// - server_error - instead of displaying a 500 Internal Server Error page to the user, the server can redirect with this error code.
  /// - temporarily_unavailable - if the server is undergoing maintenance, or is otherwise unavailable, this error code can be returned instead of responding with a 503 Service Unavailable status code.
  /// Source: https://www.oauth.com/oauth2-servers/authorization/the-authorization-response/
  late final String? error;

  /// Human readable version or error
  late final String? errorDescription;

  /// Url to describe error to developer
  late final String? errorUri;

  /// Construct a new OAuth2 exception
  OAuth2Exception(this.fault, {this.fullUri}) {
    final (String? error, String? errorDescription, String? errorUri) = _decodeUri(fullUri);
    this.error = error;
    this.errorDescription = errorDescription;
    this.errorUri = errorUri;
  }

  /// Get a string reprenstation that is more user friendly
  String toStringWithoutUrls() {
    var msg = 'OAuth2Exception [$fault]:';
    if (error != null) msg += ' $error';
    if (errorDescription != null) msg += '\n$errorDescription';
    return msg;
  }

  @override
  String toString() {
    var msg = toStringWithoutUrls();
    if (errorUri != null) msg += '\n$errorUri';
    if (fullUri != null) msg += '\n\nFull uri$fullUri';
    return msg;
  }
}

(String?, String?, String?) _decodeUri(String? url) {
  final parameters = url != null ? Uri.parse(url).queryParameters : null;
  return (
    parameters?['error'],
    parameters?['error_description'],
    parameters?['error_uri'],
  );
}
