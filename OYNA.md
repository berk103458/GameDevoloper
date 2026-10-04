# Oyunu çalıştırma

1. Godot **4.7.2**'yi aç → Proje Yöneticisi → **İçe Aktar** → bu klasördeki `project.godot`.
2. İlk açılışta içe aktarma birkaç saniye sürer.
3. **F5** — oyun ana menüden başlar.

## Kontroller
- Fare ya da ok tuşları + **Enter**.
- Kararda **1–4** bir kararı seçer; **aynı karara tekrar basmak onaylar**; **Esc** seçimi bırakır.
- Seçim yokken **Esc** ya da **P**: duraklatma menüsü.

## Neler var (1. dikey dilim)
- Kapı: gelen kişi kadraja yürür, en çok iki soru, sonra karar (kabul / ret / rüşvet al / kışlaya yaz).
- Üst şerit: dört bar (Halk, Soylular, Tüccarlar, Ordu), üç rüşvet kesesi, gece sayacı.
- Gece sonu: köy görünümü — içeri aldıkların köye yürür, nüfus arttıkça meşale artar.
- Nüfus 12'ye varınca köy oturur, ağa olursun; ikinci perdede Tekfur'un adamları yaklaşır.
- Bir bar kırılırsa (ve rüşvet kesesi kalmadıysa) oyun biter; skor = hayatta kalınan gün.
- Gece sonunda otomatik kayıt; menüde **Devam**.

## Geliştirici notları
- İçerik metni ve değerleri: `tools/icerik/icerik_uret.py` → `python3 tools/icerik/icerik_uret.py` (üretir: `data/`).
- Yer tutucu sanat: `tools/art/uret_yer_tutucu.py` → `assets/art/`. Aynı dosya adıyla elle çizilmiş sanat koyulunca oyun onu kullanır.
- Duman testi (otomatik oynatıcı): `godot --path . tests/oto/otomatik_oyuncu.tscn`.
