# Oyunu çalıştırma

1. Godot **4.7.2**'yi aç → Proje Yöneticisi → **İçe Aktar** → bu klasördeki `project.godot`.
2. İlk açılışta içe aktarma birkaç saniye sürer.
3. **F5** — oyun ana menüden başlar.

## Kontroller
- Fare ya da ok tuşları + **Enter**.
- Kararda **1–4** bir kararı seçer; **aynı karara tekrar basmak onaylar**; **Esc** seçimi bırakır.
- Seçim yokken **Esc** ya da **P**: duraklatma menüsü.

## Neler var (dikey dilim 2)
- **Kapı:** gelen kişi kadraja yürür; en çok iki soru, sonra karar (kabul / ret / rüşvet al / kışlaya yaz). 10 adlı karakter, her biri kendi dönüş kuralıyla; araya adsız figürler.
- **Üst şerit:** dört bar (Halk, Soylular, Tüccarlar, Ordu), akçe ve ambar, üç rüşvet kesesi, gece sayacı.
- **Ekonomi:** çiftçi ambarı doldurur, herkes yer; esnaf ve pazar akçe getirir; rüşvet kesene akçe koyar. Ambar boşalırsa Halk düşer.
- **Köy (gece sonu):** içeri aldıkların köye yürür; meşaleler nüfusla artar. Akçeyle **pazar** ve **kervansaray** kurup büyütürsün, boşalan rüşvet kesesini yeniden doldurursun.
- **Gece olayları (24):** kararlarının bedeli sonradan gelir — Miraen'i arayan çavuş, Thessra'nın eksik şişesi, Aydoğdu'nun obası, Ahi ocağı, tahsildar, salgın, kervanlar, Tekfur'un elçisi, Ertuğrul'dan haber…
- **İkinci perde:** nüfus 18'e varınca köy oturur, ağa olursun. Tekfur'un adamları her gece saldırır: güç gecelerle artar, savunma = asker + **sur** (akçeyle kurulur).
- **Sonlar:** dört kırılma sonu (her bar ayrı) ve ikinci perdenin sonunda köyün durumuna göre beş son: Ertuğrul'un obası, Ahi kasabası, Tekfur'un haraççısı, beyin uç köyü, uç tutundu.
- **Ses:** gece müziği (ney, Hicaz), meşale ortamı, adım, kapı, kese, çatlak, inşaat, saldırı sesleri.
- Gece sonunda otomatik kayıt; menüde **Devam**. Ayarlar: ses, ekran, metin büyüklüğü, beliriş hızı.

## Geliştirici notları
- İçerik metni ve değerleri: `tools/icerik/icerik_uret.py` → `python3 tools/icerik/icerik_uret.py` (üretir: `data/`).
- Yer tutucu sanat: `tools/art/uret_yer_tutucu.py` → `assets/art/`. Aynı dosya adıyla elle çizilmiş sanat koyulunca oyun onu kullanır.
- **Gerçek sanat (Gemini):** `tools/art/BENIOKU.md`. Pro abonelikle: `tools/art/istemler.md`'deki istemleri gemini.google.com'a yapıştır, görselleri `tools/art/gelen/`e koy, `python3 tools/art/gemini_uret.py --el-ile --yedek`. API faturalandırması açıksa: `python3 tools/art/gemini_uret.py`.
- Ses: `python3 tools/ses/ses_uret.py` → `assets/ses/`.
- Duman testi (otomatik oynatıcı): `godot --path . tests/oto/otomatik_oyuncu.tscn`.
