"""In-memory lab API. Dummy auth/data only. Never deploy to production."""
import argparse
import json
import threading
import time
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse

TOKEN = 'training-demo-token'

def serve(args):
    records = [] if args.empty else [
        {'id':str(i), 'assetCode':f'PMP-{i:03}', 'location':'Workshop A',
         'condition':'needs_action' if i == 2 else 'good',
         'note':'Getaran motor perlu diperiksa' if i == 2 else '',
         'createdAt':f'2026-10-03T01:0{i}:00Z'} for i in range(1, 4)]
    guard = threading.Lock()
    next_id = [4]

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, fmt, *parts):
            # Do not log Authorization, request bodies, passwords or query data.
            print(f'{self.command} {urlparse(self.path).path}', flush=True)
        def send(self, status, body):
            payload = json.dumps(body, ensure_ascii=False).encode()
            self.send_response(status)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Content-Length', str(len(payload)))
            self.end_headers()
            try: self.wfile.write(payload)
            except (BrokenPipeError, ConnectionResetError): pass
        def error(self, status, message): self.send(status, {'message':message})
        def body(self):
            try:
                length = int(self.headers.get('Content-Length', '0'))
                if not 0 < length <= 65536: raise ValueError()
                body = json.loads(self.rfile.read(length))
                if not isinstance(body, dict): raise ValueError()
                return body
            except (ValueError, UnicodeDecodeError):
                self.error(400, 'JSON request tidak valid')
                return None
        def authorized(self):
            if self.headers.get('Authorization') != f'Bearer {TOKEN}':
                self.error(401, 'Session tidak valid. Silakan login.')
                return False
            return True
        def do_GET(self):
            parsed = urlparse(self.path)
            if parsed.path == '/health':
                self.send(200, {'status':'ok'}); return
            if parsed.path != '/inspections':
                self.error(404, 'Endpoint tidak ditemukan'); return
            if not self.authorized(): return
            if args.delay: time.sleep(args.delay)
            if args.fail_list:
                self.error(500, 'Simulasi server gagal'); return
            query = parse_qs(parsed.query)
            try:
                page = int(query.get('page', ['1'])[0])
                per_page = int(query.get('per_page', ['50'])[0])
                if page < 1 or not 1 <= per_page <= 100: raise ValueError()
            except ValueError:
                self.error(400, 'page/per_page tidak valid'); return
            text = query.get('q', [''])[0].lower().strip()
            condition = query.get('condition', [''])[0]
            if condition not in ('', 'good', 'needs_action'):
                self.error(400, 'Filter kondisi tidak valid'); return
            with guard:
                selected = [r.copy() for r in records if
                    (not condition or r['condition'] == condition) and
                    (text in r['assetCode'].lower() or text in r['location'].lower())]
            start = (page - 1) * per_page
            self.send(200, {'items':selected[start:start + per_page],
                'page':page, 'per_page':per_page, 'total':len(selected)})
        def do_POST(self):
            path = urlparse(self.path).path
            if path not in ('/auth/login', '/inspections'):
                self.error(404, 'Endpoint tidak ditemukan'); return
            if path == '/inspections' and not self.authorized(): return
            body = self.body()
            if body is None: return
            if args.delay: time.sleep(args.delay)
            if path == '/auth/login':
                if body.get('username') == 'trainer' and body.get('password') == 'training123':
                    self.send(200, {'token':TOKEN, 'user':{'id':'u1', 'name':'Trainer'}})
                else: self.error(401, 'Username atau password salah')
                return
            if args.fail_create:
                self.error(500, 'Simulasi create gagal'); return
            keys = ('assetCode', 'location', 'condition', 'note')
            if any(not isinstance(body.get(k), str) for k in keys):
                self.error(422, 'Field wajib bertipe string'); return
            asset, location, condition, note = (body[k].strip() for k in keys)
            if not asset or len(asset) > 30 or not location or len(location) > 80:
                self.error(422, 'Kode aset/lokasi wajib dan tidak boleh terlalu panjang'); return
            if condition not in ('good', 'needs_action') or len(note) > 500:
                self.error(422, 'Kondisi/catatan tidak valid'); return
            if condition == 'needs_action' and len(note) < 10:
                self.error(422, 'Temuan membutuhkan catatan minimal 10 karakter'); return
            with guard:
                record = {'id':str(next_id[0]), 'assetCode':asset, 'location':location,
                    'condition':condition, 'note':note,
                    'createdAt':datetime.now(timezone.utc).isoformat().replace('+00:00', 'Z')}
                next_id[0] += 1
                records.insert(0, record)
            self.send(201, record)

    server = ThreadingHTTPServer((args.host, args.port), Handler)
    print(f'Lab API listening on {args.host}:{server.server_port}. Ctrl+C stops it.', flush=True)
    try: server.serve_forever()
    except KeyboardInterrupt: pass
    finally: server.server_close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--host', default='127.0.0.1')
    parser.add_argument('--port', type=int, default=8000)
    parser.add_argument('--delay', type=float, default=0, help='Seconds before API responses')
    parser.add_argument('--fail-list', action='store_true')
    parser.add_argument('--fail-create', action='store_true')
    parser.add_argument('--empty', action='store_true')
    args = parser.parse_args()
    if args.delay < 0 or not 0 <= args.port <= 65535: parser.error('Invalid delay/port')
    serve(args)
