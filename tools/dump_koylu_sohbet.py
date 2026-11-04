# -*- coding: utf-8 -*-
import csv, json

with open('data/metin/metinler.csv', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)
    rows = list(reader)

koylu_names = {'aydogdu', 'ayse_baci', 'hasan_celebi', 'karaca_usta', 'miraen', 'nogay', 'saruca_hatun', 'sorhan', 'thessra', 'yusuf'}
koylu_dict = {r[0]: r[1] for r in rows if r and r[0].startswith('sohbet.') and r[0].split('.')[1] in koylu_names}

with open('tools/koylu_sohbet_dump.json', 'w', encoding='utf-8') as out:
    json.dump(koylu_dict, out, ensure_ascii=False, indent=2)

print(f'Wrote {len(koylu_dict)} items to tools/koylu_sohbet_dump.json')
