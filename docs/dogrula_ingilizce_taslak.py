#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Kapı Muhafızı - İngilizce Taslak İkinci Okuma ve Bütünlük Doğrulayıcı
(Antigravity - Görev 12)
"""

import csv
import json
import glob
import os
import re
import sys

def check_csv(csv_path, forbidden_words):
    print("\n[1/3] CSV Dosyası Kontrol Ediliyor:", csv_path)
    if not os.path.exists(csv_path):
        return [f"HATA: {csv_path} bulunamadı!"], []
        
    errors = []
    warnings = []
    csv_count = 0
    with open(csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.reader(f)
        header = next(reader)
        if header != ["anahtar", "tr", "en", "not"]:
            errors.append(f"CSV başlığı hatalı: {header}")
            
        for idx, row in enumerate(reader, start=2):
            csv_count += 1
            if len(row) != 4:
                errors.append(f"Satır {idx}: Sütun sayısı 4 değil ({len(row)}) -> {row[:1]}")
                continue
            key, tr_text, en_text, note = row[0], row[1], row[2], row[3]
            
            if not en_text.strip():
                errors.append(f"Satır {idx} ({key}): İngilizce metin boş!")
                
            # Yer tutucu kontrolü ({sayi}, {0}, {isim}, {kisi} vb.)
            tr_placeholders = set(re.findall(r'\{[^}]+\}', tr_text))
            en_placeholders = set(re.findall(r'\{[^}]+\}', en_text))
            if tr_placeholders != en_placeholders:
                errors.append(f"Satır {idx} ({key}): Yer tutucu uyuşmazlığı TR={tr_placeholders} EN={en_placeholders}")
                
            # Yasaklı / modern / stil dışı kelime kontrolü
            for word in forbidden_words:
                if re.search(r'\b' + re.escape(word) + r'\b', en_text, re.IGNORECASE):
                    warnings.append(f"Satır {idx} ({key}): Sözlük/Stil dışı kelime '{word}' -> {en_text}")

    print(f"  Toplam {csv_count} CSV satırı başarıyla okundu.")
    return errors, warnings


def check_json_files(diyalog_dir, forbidden_words, root):
    print("\n[2/3] JSON Dosyaları Kontrol Ediliyor:", diyalog_dir)
    json_files = glob.glob(os.path.join(diyalog_dir, "*.json"))
    errors = []
    warnings = []
    
    for jf in json_files:
        rel_jf = os.path.relpath(jf, root)
        try:
            with open(jf, mode="r", encoding="utf-8") as f:
                data = json.load(f)
            
            content_str = json.dumps(data, ensure_ascii=False)
            
            # JSON içindeki her string alanda stil taraması
            def scan_obj(obj, path=""):
                if isinstance(obj, dict):
                    for k, v in obj.items():
                        scan_obj(v, f"{path}.{k}")
                elif isinstance(obj, list):
                    for i, v in enumerate(obj):
                        scan_obj(v, f"{path}[{i}]")
                elif isinstance(obj, str):
                    for word in forbidden_words:
                        if re.search(r'\b' + re.escape(word) + r'\b', obj, re.IGNORECASE):
                            warnings.append(f"JSON {rel_jf} ({path}): '{word}' bulundu -> \"{obj}\"")
                            
            scan_obj(data)
            print(f"  OK: {rel_jf}")
        except Exception as e:
            errors.append(f"JSON Ayrıştırma Hatası ({rel_jf}): {e}")
            
    return errors, warnings


def check_parley_files(diyalog_dir, forbidden_words, root):
    print("\n[3/3] Parley (.ds) Dosyaları Kontrol Ediliyor...")
    parley_files = glob.glob(os.path.join(diyalog_dir, "koy", "*.ds"))
    errors = []
    warnings = []
    
    for pf in parley_files:
        rel_pf = os.path.relpath(pf, root)
        try:
            with open(pf, mode="r", encoding="utf-8") as f:
                data = json.load(f)
            
            if "nodes" not in data:
                errors.append(f"Parley {rel_pf}: 'nodes' anahtarı eksik!")
                
            nodes = data.get("nodes", [])
            for node in nodes:
                nid = node.get("id", "unknown")
                text = node.get("text", "")
                if text:
                    for word in forbidden_words:
                        if re.search(r'\b' + re.escape(word) + r'\b', text, re.IGNORECASE):
                            warnings.append(f"Parley {rel_pf} (düğüm {nid}): '{word}' bulundu -> \"{text}\"")
                            
            print(f"  OK: {rel_pf}")
        except Exception as e:
            errors.append(f"Parley Ayrıştırma Hatası ({rel_pf}): {e}")
            
    return errors, warnings


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    docs_dir = os.path.join(root, "docs")
    csv_path = os.path.join(docs_dir, "INGILIZCE_METIN_TASLAGI.csv")
    diyalog_dir = os.path.join(docs_dir, "ingilizce_diyalog")
    
    print("=== KAPI MUHAFIZI İNGİLİZCE TASLAK DOĞRULAYICI ===")
    
    forbidden_words = [
        "okay", "guys", "awesome", "dude", "boss", "police",
        "passport", "bureaucracy", "gun", "pistol", "bullet",
        "lord", "lady", "mayor"
    ]
    
    csv_err, csv_warn = check_csv(csv_path, forbidden_words)
    json_err, json_warn = check_json_files(diyalog_dir, forbidden_words, root)
    parley_err, parley_warn = check_parley_files(diyalog_dir, forbidden_words, root)
    
    all_errors = csv_err + json_err + parley_err
    all_warnings = csv_warn + json_warn + parley_warn
    
    print("\n=== ÖZET ===")
    print(f"Hata Sayısı (Errors)    : {len(all_errors)}")
    print(f"Uyarı Sayısı (Warnings) : {len(all_warnings)}")
    
    if all_errors:
        print("\nHATALAR (Düzeltilmesi Zorunlu):")
        for err in all_errors:
            print(f"  [!] {err}")
            
    if all_warnings:
        print("\nUYARILAR (Sözlük ve Üslup İncelemesi):")
        for w in all_warnings:
            print(f"  [*] {w}")
            
    return 1 if all_errors else 0

if __name__ == "__main__":
    sys.exit(main())
