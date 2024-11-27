import 'package:oauth_flutter/src/oauth2_exception.dart';

/// OAuth2 authorization
class OAuthAuthorization {
  /// The authorization code
  final String code;

  /// The code verifier
  final String codeVerifier;

  /// The state
  final String state;

  /// The raw token nonce before SHA256 hashing
  final String rawNonce;

  /// Constructor
  OAuthAuthorization({
    required this.code,
    required this.codeVerifier,
    required this.state,
    required this.rawNonce,
  });

  /// Parse from url
  factory OAuthAuthorization.fromUrl({
    required String url,
    required String codeVerifier,
    required String state,
    required String rawNonce,
  }) {
    final parameters = Uri.parse(url).queryParameters;
    final code = parameters['code'];
    final responseState = parameters['state'];
    if (code == null) {
      throw OAuth2Exception('No code found', fullUri: url);
    } else if (responseState != state) {
      throw OAuth2Exception('State mismatch', fullUri: url);
    }
    return OAuthAuthorization(
      code: code,
      codeVerifier: codeVerifier,
      state: state,
      rawNonce: rawNonce,
    );
  }
}
