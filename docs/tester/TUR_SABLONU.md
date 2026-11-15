# TUR-NNN — Kapı Muhafızı Tester Raporu Şablonu

- **Tarih:** YYYY-AA-GG
- **Test edilen commit:** `<kısa-hash>`
- **Durum:** BİTTİ / SÜRÜYOR

## Söz kapısı özeti (KLT-18 / KLT-57)

Komut: `python -B tools/soz_kapi.py --paket <paket.json> --tur-ozet`

soz_kapi: ihlal=0, kota=sir:0/0|dinleyici:0, eksik_anahtar=0

> **Kural (KLT-57):** Hikâye personası dal gezmez diye öznel kalite puanı veya `Kanaat:` satırı yazılmaz. Kalite ölçütü yalnız yukarıdaki `soz_kapi` kapı sayısıdır.

## Persona koşuları

- `hikaye_odakli` (KLT-18): `python -B tools/tester_oyuncu.py --politika hikaye_odakli --tohum 11 --gece 10 --cikti work/tester/turNNN/hikaye_11.jsonl` → diyalog dalı ve inceleme eylemleri kaplandı mı, softlock var mı.
- `temkinli` / `rastgele` / `rusvetci`: koşulan tohumlar ve sonuçlar.

## Test edilenler

- Sanity / hedefli testler: `<komut>` → `<GEÇTİ / KALDI>`
- Kanıt dosyaları: `work/tester/turNNN/...`

## Özet

- **Tur N · commit `<hash>` · yeni bulgu: … · öneri: … · sonraki odak: …**
