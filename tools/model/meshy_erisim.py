"""Meshy erişimini kredi harcamadan doğrular; anahtarı veya görev içeriğini yazdırmaz."""
import argparse
import json
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen
import os


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--anahtar', type=Path, default=Path(__file__).resolve().parents[2] / '.meshy-api-key')
    args = parser.parse_args()
    key = os.environ.get('MESHY_API_KEY', '').strip()
    if not key and args.anahtar.is_file():
        key = args.anahtar.read_text(encoding='utf-8-sig').strip()
    if not key:
        print('Meshy anahtarı bulunamadı. MESHY_API_KEY veya --anahtar DOSYA kullanın.')
        return 1
    result = {}
    failed = False
    for name, path in [('balance', '/v1/balance'), ('text_tasks', '/v2/text-to-3d?page_size=1')]:
        req = Request('https://api.meshy.ai/openapi' + path, headers={'Authorization': 'Bearer ' + key})
        try:
            with urlopen(req, timeout=30) as response:
                data = json.load(response)
                result[name] = {'status': response.status}
                if name == 'balance':
                    result[name]['credits'] = data.get('balance')
        except HTTPError as error:
            result[name] = {'status': error.code}
            failed = True
        except (URLError, TimeoutError):
            result[name] = {'status': 'connection_failed'}
            failed = True
    print(json.dumps(result, ensure_ascii=False))
    return 1 if failed else 0


if __name__ == '__main__':
    raise SystemExit(main())
