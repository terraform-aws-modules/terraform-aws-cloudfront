function handler(event) {
  var request = event.request;
  var headers = request.headers;

  // Add custom header to demonstrate connection function
  headers['x-connection-function'] = {
    value: 'connection-function-processed'
  };

  return request;
}
