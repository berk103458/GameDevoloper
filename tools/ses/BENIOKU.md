# tools/ses — prosedürel yer tutucu sesler

`ses_uret.py`, oyundaki tüm müzik, ortam ve efekt seslerini **yalnızca koddan**
sentezler. Ses kütüphanesi ya da ağ kaynağı kullanılmaz. Çıktı `assets/ses/`
altına 16-bit, 44.1 kHz, mono WAV olarak yazılır.

```
python3 tools/ses/ses_uret.py              # hepsi
python3 tools/ses/ses_uret.py sfx_kese     # yalnızca seçilenler
```

- **Yalnızca standart kütüphane** (numpy gerekmez). Tohumlar sabittir, bu yüzden
  aynı Python sürümünde çıktı her çalıştırmada bayt bayt aynıdır. Saf Python olduğu
  için bütün set 1-3 dakika sürer.
- **Seviyeler:** müzik ve ortam döngüleri tepe −12 dBFS'tir. SFX tepe −3 dBFS'tir,
  tıklama olmaması için kısa giriş ve çıkış solmaları uygulanır.
- **Döngüler** (`muzik_gece_dongu`, 75 s; `ortam_mesale_dongu`, 20 s) dikişsizdir.
  Sürekli katmanlar çapraz geçişle, olay kuyrukları dairesel olarak başa katlanır.
  Godot'da döngü, içe aktarma ayarında açılmalıdır (Loop Mode). Bu ayar ses
  programcısının işidir.

## Yer tutucu uyarısı

Bu dosyaların hepsi **geçici**dir. Gerçek kayıt ya da tasarım ses, **aynı dosya
adıyla** `assets/ses/` altına konduğunda oyunda hiçbir şeyin değişmesi gerekmez.
Gerçek sesler gelince bu betik yeniden çalıştırılmamalıdır, yoksa onların üzerine
yazar.
