# -*- coding: utf-8 -*-
import json

with open('tools/olay_dump.json', encoding='utf-8') as f:
    d = json.load(f)

events = {}
for k, v in d.items():
    ev = k.split('.')[1]
    sub = k.split('.', 2)[2]
    events.setdefault(ev, {})[sub] = v

for ev, fields in sorted(events.items()):
    baslik = fields.get('baslik', '')
    print(f"{ev:20s} | {len(fields):2d} keys | {baslik}")
