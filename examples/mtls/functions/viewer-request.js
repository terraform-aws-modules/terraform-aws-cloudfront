function handler(event) {
    var response = event.response;
    var headers = response.headers;

    // Set security headers
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };
    headers['x-content-type-options'] = { value: 'nosniff' };
    headers['x-frame-options'] = { value: 'DENY' };
    headers['x-xss-protection'] = { value: '1; mode=block' };
    headers['content-security-policy'] = { value: "default-src 'self'" };

    return response;
}
