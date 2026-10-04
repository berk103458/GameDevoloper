# Sanat üretim hattı (Gemini)

`gemini_uret.py`, `assets/art/` altındaki yer tutucu PNG'lerin **hepsini** (37 dosya)
Gemini ile üretilen sanatla değiştirir. Dosya adı ve piksel boyutu aynı kalır, bu yüzden
oyunda hiçbir şey değişmez. Yer tutucular gerekirse `uret_yer_tutucu.py` ile yeniden üretilir.

Her görsel aynı son işlemden geçer: macenta (#FF00FF) arka plan silinir, tam boyuta
kırpılır, art bible'daki 7 renklik palete oturtulur, alfa ikili yapılır (yarı saydamlık yok).

## Yol A — API (faturalandırma gerekir)

Ücretsiz katmanda görsel modelinin kotası **sıfırdır** (HTTP 429, `limit: 0`).

1. https://aistudio.google.com → **Get API key** → anahtarın projesini seçin.
2. Aynı yerde **Set up billing** (Settings → Billing) ile faturalandırmayı açın; birkaç dakika bekleyin.
3. Anahtarı verin: `export GEMINI_API_KEY=...` ya da bir dosyaya yazıp `--anahtar DOSYA`.
4. Depo kökünden:

```bash
python3 tools/art/gemini_uret.py --kuru                       # istemler ve boyutlar, ağ yok
python3 tools/art/gemini_uret.py --yedek                      # hepsi
python3 tools/art/gemini_uret.py --sadece 'char_miraen*' --yedek
```

`--model` ile model adı değiştirilir (varsayılan `gemini-3.1-flash-image`; 404 alırsanız
AI Studio'daki güncel adı verin). Ham çıktılar `tools/art/ham/`, eski yer tutucular
(`--yedek`) `tools/art/yedek/AD.yer_tutucu.png` olarak saklanır.

## Yol B — El ile (Gemini uygulaması / Pro aboneliği)

Gemini Pro aboneliği API kotası **vermez**; görseller uygulamada el ile üretilir.

1. `tools/art/istemler.md` dosyasını açın: her hedef için dosya adı, boyut, oran ve
   kopyalanacak istem orada.
2. https://gemini.google.com'da istemi yapıştırın, görseli indirin.
3. Bölümde yazan adla yeniden adlandırıp `tools/art/gelen/` klasörüne koyun
   (`.png`, `.jpg`, `.webp` olur).
4. Çalıştırın: `python3 tools/art/gemini_uret.py --el-ile --yedek`
   Betik eşleşmeyen ve eksik dosyaları listeler; eksikler için adımları tekrarlayın.

İstemleri değiştirmek için betikteki tabloyu düzenleyip `--istemler-md` ile
`istemler.md`'yi yeniden üretin.

## Ağsız sınama

```bash
python3 tools/art/gemini_uret.py --sinama GORSEL.png char_miraen_neutral_card
```

Çıktı `tools/art/sinama/` altına yazılır; boyut, palet dışı piksel ve yarı alfa raporlanır.

## Oyuna geçiş

Ek iş yok: oyun dosyaları aynı adla `res://assets/art/...` yolundan yükler. Godot
düzenleyicisini açtığınızda (ya da pencereye döndüğünüzde) değişen PNG'ler kendiliğinden
yeniden içe aktarılır; `.import` dosyalarına dokunmayın. Görsel değişiklik olduğu için
kontrol ekran görüntüsünü `production/qa/evidence/` altına koymayı unutmayın.
