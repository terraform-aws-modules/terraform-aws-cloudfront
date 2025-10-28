function handler(event) {
  // Viewer request function to add security headers and normalize cache keys
  // This function runs before CloudFront checks the cache

  var request = event.request;
  var headers = request.headers;

  // Normalize Host header for consistent caching
  if (headers.host) {
    headers.host.value = headers.host.value.toLowerCase();
  }

  // Remove query parameters that don't affect content (for better cache hit ratio)
  var uri = request.uri;
  var querystring = request.querystring;

  // Example: Remove tracking parameters but keep content-affecting ones
  var allowedParams = ['id', 'page', 'category'];
  var newQuerystring = {};

  for (var param in querystring) {
    if (allowedParams.includes(param)) {
      newQuerystring[param] = querystring[param];
    }
  }

  request.querystring = newQuerystring;

  // Add custom header for logging/debugging
  headers['x-viewer-country'] = {
    value: event.viewer.country || 'unknown'
  };

  return request;
}
