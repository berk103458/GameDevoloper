# Antigravity (Alpha) Durum Tablosu

- **Güncelleme:** 24 Kasım 2026
- **Dal:** `claude/festive-volta-li1sfm`
- **Yerel `HEAD`:** `f1e7009a` sonrası (Tur 8) | **Uzak `origin/claude/festive-volta-li1sfm`:** senkron

## Durum Özeti

| Durum | Kalem | Ayrıntı |
|---|---|---|
| **Bitti** | Kırık 3 test düzeltildi | `acilis_menu_kontrol.tscn`, `hayvan_takas_kontrol.tscn`, `soylenti_meclis_kontrol.tscn` tamamı `RC=0` ile geçti. |
| **Bitti** | Harita pinleri & sağ bilgi kartı | `data/cevre_haritasi.json` 9 bölge + köprü/rotalar çerçeve içine ve coğrafyaya oturtuldu; `src/arayuz/harita_ekrani.gd` sağ kart seçimsiz ve seçili durumlarda dolduruldu; tüm harita testleri (`RC=0`) ve pencereli ekran görüntüleri doğrulandı. |
| **Bitti** | Parti 3b + B1, Animasyonlar, Kalan 2D İkonlar (`f10860d2`, `484c042f`, `99ab8127`, `f1e7009a`) | Önceki turda doğrulandı ve pushlandı. |
| **Kapsam Dışı / Kalan** | `E43`, `E105`, `E135` | Kusurlu 3 görsele dokunulmadı. |
