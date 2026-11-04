# -*- coding: utf-8 -*-
import csv, json

with open('data/metin/metinler.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)
    olay_dict = {r[0]: r[1] for r in reader if r and r[0].startswith('olay.')}

with open('tools/olay_dump.json', 'w', encoding='utf-8') as out:
    json.dump(olay_dict, out, ensure_ascii=False, indent=2)

print(f'Wrote {len(olay_dict)} items to tools/olay_dump.json')
