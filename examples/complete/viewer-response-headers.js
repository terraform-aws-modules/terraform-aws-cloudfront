function handler(event) {
  // Viewer response function to add security and performance headers
  // This function runs after CloudFront receives the response from origin

  var response = event.response;
  var headers = response.headers;

  // Add security headers
  headers['strict-transport-security'] = {
    value: 'max-age=63072000; includeSubdomains; preload'
  };

  headers['x-content-type-options'] = {
    value: 'nosniff'
  };

  headers['x-frame-options'] = {
    value: 'DENY'
  };

  headers['x-xss-protection'] = {
    value: '1; mode=block'
  };

  headers['referrer-policy'] = {
    value: 'strict-origin-when-cross-origin'
  };

  // Add cache control for static assets
  if (event.request.uri.match(/\.(jpg|jpeg|png|gif|ico|css|js|woff|woff2)$/)) {
    headers['cache-control'] = {
      value: 'public, max-age=31536000, immutable'
    };
  }

  // Add custom header to identify CloudFront Functions processing
  headers['x-cloudfront-function'] = {
    value: 'viewer-response-headers'
  };

  return response;
}
