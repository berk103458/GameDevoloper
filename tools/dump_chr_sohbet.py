# -*- coding: utf-8 -*-
import csv, json

with open('data/metin/metinler.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)
    rows = list(reader)

chr_dict = {r[0]: r[1] for r in rows if r and r[0].startswith('sohbet.chr_')}

with open('tools/chr_sohbet_dump.json', 'w', encoding='utf-8') as out:
    json.dump(chr_dict, out, ensure_ascii=False, indent=2)

print(f'Wrote {len(chr_dict)} items to tools/chr_sohbet_dump.json')
