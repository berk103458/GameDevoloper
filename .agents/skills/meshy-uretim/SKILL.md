---
name: meshy-uretim
description: >
  Kapı Muhafızı 3D asset üretimi Meshy ile: istem → Meshy görevi → indirme → doğrulama → Godot'a
  yerleştirme. Tek giriş tools/meshy/meshy_hat.py, tek kayıt assets/meshy_manifest.json. Bir 3D model,
  karakter, yapı, hayvan, el eşyası ya da animasyon klibi üretilecek, Meshy kredisi tahmin edilecek,
  Meshy görevi aranacak ya da Meshy çıktısı oyuna alınacaksa kullan. Aynı asset'in iki kez üretilmesini
  (kredi kaybı) engelleyen kurallar buradadır.
---

# Meshy üretim hattı (Kapı Muhafızı)

Ayrıntılı belge: `docs/MESHY_URETIM_SISTEMI.md`. Bu skill çalışma sırasını ve yasakları verir.

## Değişmez kurallar

1. **Tek giriş:** Meshy'de görev yalnız `python3 tools/meshy/meshy_hat.py uret --gercek ...` ile açılır.
   Meshy web arayüzü, MCP `meshy_text_to_3d`/`meshy_rig`/`meshy_animate`, Meshy CLI `meshy make`,
   Blender/Godot eklentileri ile **üretim yapma** — bunlar manifeste yazmaz, tekrar üretimi önleyemez.
   MCP ve CLI yalnız salt okunur işler için: bakiye, görev listesi, animasyon kitaplığı araması.
2. **Varsayılan kuru:** komutsuz ya da `kuru` çalıştırma hiçbir görev açmaz, anahtar istemez.
3. **Kilitli durumlar:** `mevcut`, `uretiliyor`, `uretildi`, `onaylandi` satırı yeniden gönderilmez.
   `reddedildi` yalnız `uret --gercek --yeniden <id>` ile (açık insan kararı) yeniden üretilir.
4. **Belirsiz gönderim:** POST zaman aşımı/5xx/bağlantı kopması sonrası **asla tekrar gönderme**. Hat
   satıra `BELIRSIZ@zaman` yazar; `gecmis --esle` ile Meshy geçmişinde görevi bul. Gerçekten yoksa
   `uret --gercek --belirsizi-sifirla <id>`.
5. **Manifest commit'i:** her gerçek üretimden hemen sonra `assets/meshy_manifest.json` ve `.csv`
   commit/push edilir; başka ajan/makine aynı asset'i bu dosyadan "üretildi" görür.
6. **Anahtar:** `MESHY_API_KEY` ortam değişkeni ya da repo kökünde git'e girmeyen `.meshy-api-key`.
   Anahtarı yazdırma, loglama, commit etme, rapora/issue'ya yazma.
7. **Kredi onayı:** gerçek üretimde `--onay-kredi N` tahmini toplama eşit olmalı (ya da etkileşimli
   yazılır); `ayarlar.json` `hesap_plani` `ucretli`/`ucretsiz` olmadan gerçek üretim reddedilir.
8. Asset kuralı (AGENTS.md) geçerli: Meshy üretimi Ahmet'in açık kararıyla ve bu hatla yapılır;
   mekanik yine yer tutucuyla bitirilir, asset beklenmez.

## Sıra

```bash
# 0) Planı yenile ve incele (kredisiz)
python3 tools/meshy/meshy_hat.py manifest
python3 tools/meshy/meshy_hat.py kuru --oncelik yuksek        # ya da --sadece bey cavus
# 1) Hesap geçmişini eşle (ücretsiz GET; anahtar gerekir)
python3 tools/meshy/meshy_hat.py gecmis --esle
# 2) Gerçek üretim (kuru çıktıdaki toplamı --onay-kredi'ye yaz)
python3 tools/meshy/meshy_hat.py uret --gercek --sadece bey --onay-kredi 38
# 3) Yarıda kalırsa (zaman aşımı, kesinti) — görev kimliği manifestte, yeniden POST yok
python3 tools/meshy/meshy_hat.py devam --gercek --sadece bey --onay-kredi <kalan>
# 4) Ölç ve Godot'a yerleştir
python3 tools/meshy/meshy_hat.py dogrula bey
GODOT_BIN=godot python3 tools/meshy/meshy_hat.py yerlestir bey   # --import + klip_ayikla + godot_dogrula
# 5) Göz kontrolünden sonra
python3 tools/meshy/meshy_hat.py onayla bey --not "boy ve siluet uygun"
python3 tools/meshy/meshy_hat.py reddet bey --neden "zırh plakası var"
```

## Yeni asset ekleme

- Envanterde (`docs/EKSIK_ASSET_ENVANTERI.md`) yeni 3D kimlik açıldıysa `tools/meshy/plan_eki.json`
  `envanter` eşlemesine ekle (kanonik ada bağla; aynı nesne için ikinci ad açma). Kuru çalıştırma
  eşlemesiz kimliği uyarı olarak yazar; test (`tests/tools/test_meshy_hat.py`) eşlemesiz kimlikte düşer.
- İstem `plan_eki.json` `assetler.<ad>.prompt` alanına İngilizce yazılır; stil ve karakter öneki
  `ayarlar.json`'dan otomatik eklenir. Boy (m), poly, öncelik, ölçü alanlarını doldur.
- Önce topluluk adayına bak (`design/art/meshy/meshy-secim.json`, CC0, kredisiz indirme). Satırda
  `topluluk_adayi` varsa üretmeden önce o modeli dene.

## Godot'a alma

- Karakter: `assets/model/karakter/<ad>_yuru.glb` repoya girer; ham/iskelet/hareket GLB'leri girmez
  (`.gitignore`). Hareket klipleri `tools/model/klip_ayikla.gd` ile `assets/model/hareket/<ad>_<h>.res`
  olur; `KarakterModel` bunları `Dunya3B.hareket_yolu()` ile yükler.
- İçe aktarma ayarı mevcut `.import` dosyalarıyla aynı: `nodes/apply_root_scale=true`,
  `meshes/generate_lods=true`, `meshes/create_shadow_meshes=true`, `animation/fps=30`.
- Ölçek/pivot sorunu varsa iskeletsiz modelde `blender_hazirla.py` (Blender 4.2+), iskeletli modelde
  Meshy `height_meters` / Godot `root_scale` kullan; elle başka araçla ikinci üretim yapma.
- Lisans: `ayarlar.json` `hesap_plani` ücretsizse çıktı CC BY 4.0'dır, atıf
  `Model created with Meshy – CC BY 4.0 License` envantere ve oyun künyesine yazılır.
