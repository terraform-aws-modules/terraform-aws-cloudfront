function handler(event) {
  // A/B testing function using CloudFront Functions
  // Assigns users to test groups and routes to different origin paths

  var request = event.request;
  var headers = request.headers;
  var cookies = request.cookies;

  // Check if user already has an A/B test cookie
  var abTestGroup = null;

  if (cookies['ab-test-group']) {
    abTestGroup = cookies['ab-test-group'].value;
  } else {
    // Assign new users to a test group (50/50 split)
    // Use CloudFront viewer ID for consistent assignment
    var viewerId = event.viewer.address;
    var hash = 0;

    for (var i = 0; i < viewerId.length; i++) {
      hash = ((hash << 5) - hash) + viewerId.charCodeAt(i);
      hash = hash & hash; // Convert to 32bit integer
    }

    abTestGroup = (Math.abs(hash) % 2 === 0) ? 'A' : 'B';

    // Note: CloudFront Functions cannot set cookies
    // You would set this cookie in the response (using viewer-response function)
    // or via JavaScript on the client side
  }

  // Route to different paths based on test group
  var uri = request.uri;

  if (abTestGroup === 'B' && !uri.startsWith('/variant-b/')) {
    // Rewrite path for variant B users
    request.uri = '/variant-b' + uri;
  }

  // Add header for origin to know which variant was served
  headers['x-ab-test-group'] = {
    value: abTestGroup
  };

  return request;
}
