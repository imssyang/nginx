from wsgiref.simple_server import make_server


def header_name(key):
    parts = key.split("_")[1:]
    parts = [part.lower() for part in parts]
    return "-".join(parts)


def app(environ, start_response):
    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)

    for key, value in environ.items():
        if key.startswith("HTTP_"):
            name = header_name(key)
            yield ("%s: %s\n" % (name, value)).encode()


with make_server('', 8000, app) as httpd:
    print("listening on port 8000...")
    httpd.serve_forever()
