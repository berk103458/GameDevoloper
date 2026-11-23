# Antigravity (Alpha) Durum Tablosu

- **Güncelleme:** 24 Kasım 2026
- **Dal:** `claude/festive-volta-li1sfm`
- **Yerel `HEAD`:** `99ab8127` | **Uzak `origin/claude/festive-volta-li1sfm`:** `99ab8127` (senkron)

## Durum Özeti

| Durum | Kalem | Ayrıntı |
|---|---|---|
| **Bitti** | Parti 3b + B1 Evrak Animasyonu (`f10860d2`) | `src/arayuz/chr_inceleme_paneli.gd` içinde 60 `icon_clue_*` ikonu, Kalfa `226673af` birleştirmesi ve `await EvrakAnimasyonu.oynat(...)` eklendi; `b_grubu_animasyonlari_test.gd`, `chr_kapi_kontrol.tscn`, `chr_kadro_karar_kontrol.tscn` `RC=0`. |
| **Bitti** | Animasyonlar `A1–A6`, `B1–B10`, `C1–C6` | 22 animasyonun `src/` kancaları ve 8 birim testi (`RC=0`) doğrulandı. |
| **Bitti** | Harita Doğrulama + `MogolOncusu` / `GozcuKulesi` `_ayar()` (`484c042f`, `99ab8127`) | `-s` derleme sırası hatası kök nedeninden çözüldü; tüm harita testleri (`RC=0`) ve 4 pencereli canlı akış ekran görüntüsü doğrulandı. |
| **Bitti** | Kalan Gemini 2D İkon Bağlantıları (`99ab8127`) | 5 stok, 13 yapı, 8 hayvan, 4 geçmiş, 3 oda eşyası, yozlaşma, marangoz defteri, 4 durum/söylenti ve 4 zar yaklaşımı ikonu ilgili ekranlara bağlandı (`grv_tema_baglari_kontrol.tscn` `RC=0`). |
| **Kapsam Dışı / Kalan** | `E43`, `E105`, `E135` + 3 mevcut test | Kusurlu 3 görsele dokunulmadı; `acilis_menu_kontrol.tscn`, `hayvan_takas_kontrol.tscn`, `soylenti_meclis_kontrol.tscn` mevcut kod farklarından (`C5` animasyon beklemesi, `CobanSurusu`, `HafizaDefteri`) dolayı hata veriyor. |
