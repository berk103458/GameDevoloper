# -*- coding: utf-8 -*-
import csv, json

with open('data/metin/metinler.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)
    koy_dict = {r[0]: r[1] for r in reader if r and r[0].startswith('koy.')}

with open('tools/koy_dump.json', 'w', encoding='utf-8') as out:
    json.dump(koy_dict, out, ensure_ascii=False, indent=2)

print(f'Wrote {len(koy_dict)} items to tools/koy_dump.json')

subcats = {}
for k in koy_dict:
    sc = k.split('.')[1]
    subcats[sc] = subcats.get(sc, 0) + 1

for sc, count in sorted(subcats.items(), key=lambda x: -x[1]):
    print(f"{sc:20s}: {count:3d} keys")
