# -*- coding: utf-8 -*-
import csv, json

with open('data/metin/metinler.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)
    sablon_dict = {r[0]: r[1] for r in reader if r and r[0].startswith('sablon.')}

with open('tools/sablon_dump.json', 'w', encoding='utf-8') as out:
    json.dump(sablon_dict, out, ensure_ascii=False, indent=2)

print(f'Wrote {len(sablon_dict)} items to tools/sablon_dump.json')

subcats = {}
for k in sablon_dict:
    sc = k.split('.')[1]
    subcats[sc] = subcats.get(sc, 0) + 1

for sc, count in sorted(subcats.items(), key=lambda x: -x[1]):
    print(f"{sc:20s}: {count:3d} keys")
