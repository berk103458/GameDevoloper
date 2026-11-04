# -*- coding: utf-8 -*-
"""
Görev 11 - Bölüm A: İngilizce Metin Taslağı Üretici (docs/INGILIZCE_METIN_TASLAGI.csv)
Tüm çeviriler 13. yüzyıl Anadolu Selçuklu / Uç Beyliği atmosferine uygun,
modern kalıplardan uzak, Türkçe özel isimleri koruyan dönem İngilizcesi ile hazırlanır.
"""

import csv
import sys

def load_metinler():
    with open('data/metin/metinler.csv', encoding='utf-8') as f:
        reader = csv.reader(f)
        header = next(reader)
        return {row[0]: row[1] if len(row) > 1 else '' for row in reader if row}

def load_existing_taslak():
    with open('docs/INGILIZCE_METIN_TASLAGI.csv', encoding='utf-8') as f:
        reader = csv.reader(f)
        header = next(reader)
        rows = list(reader)
        existing = {r[0]: r for r in rows if r}
        return header, rows, existing

def save_taslak(header, rows):
    with open('docs/INGILIZCE_METIN_TASLAGI.csv', 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)

def append_translations(translations, part_name=""):
    header, rows, existing = load_existing_taslak()
    metinler = load_metinler()
    
    added_count = 0
    for k, en in translations.items():
        if k in existing:
            continue
        tr = metinler.get(k, '')
        rows.append([k, tr, en, 'taslak_tam'])
        existing[k] = [k, tr, en, 'taslak_tam']
        added_count += 1
        
    save_taslak(header, rows)
    print(f"[{part_name}] Added {added_count} translations to docs/INGILIZCE_METIN_TASLAGI.csv")
    return added_count
