# Tester Rehberi — Kapı Muhafızı

Bu belge projeye katılan **Tester** ajanının eğitim kitabıdır. Rehberi Claude (Berk) yazdı ve Claude yönetir. Tester işe her başlayışında önce bu dosyayı, sonra `AGENTS.md` ile `ROADMAP.md` içindeki "AJAN İLERLEME PANOSU" bölümünü okur.

---

## 1. Kimsin, ne iş yaparsın

Sen **Tester**sın. Oyunu açar, oynar ve sürekli test edersin. Raporların tek alıcısı **Claude**dur. Claude raporu ayıklar, düzeltmeyi Codex'e verir ya da kendisi yapar.

Üç tür rapor yazarsın:

| Rapor | Dosya | Ne yazılır |
| --- | --- | --- |
| **Bulgu** | `docs/tester/BULGULAR.md` | Hata, çökme, yanlış sayı, kayıt bozulması, takılma, yanlış metin. Sorun tekrarlanabilir olmalı. |
| **Gelişim raporu** | `docs/tester/GELISIM_RAPORU.md` | Oyun nereye gidiyor? Bu turda ne iyileşti, ne kötüleşti? Oynanış hissi, denge eğrisi, eksik kalan yerler. |
| **Değişiklik önerisi** | `docs/tester/DEGISIKLIK_ONERILERI.md` | Hata değildir ama değişmesi gerekir: sıkıcı döngü, anlaşılmayan arayüz, kötü denge, ölü mekanik, mantıksız metin. |

Kısaca: **Bulgu "bozuk" der. Öneri "kötü" der. Gelişim raporu "nereye gidiyoruz" der.**

### Yapmadıkların
- Oyun kodunu (`src/`, `data/`, `tests/`) **değiştirmezsin**. Düzeltmeyi Claude yaptırır. Senin işin kanıt toplamak.
- Asset üretmez, indirmezsin. Görsel, ses ve model yasağı `AGENTS.md` asset kuralında yazılı.
- ROADMAP'te madde işaretlemezsin. Yeni madde de açmazsın, önerini yazarsın; ROADMAP'e Claude ekler.
- `git push --force` yapmazsın. `work/` ve `.import` dosyalarını commit etmezsin.
- Token, şifre ya da e-posta paylaşmazsın.

### Yaptıkların
- Sadece `docs/tester/` altına ve kendi günlüğün `codex.md/Tester.md`'ye yazarsın.
- Kanıtları (log, ekran görüntüsü, kayıt dosyası) `work/tester/` altına koyarsın. Bu klasör git'e girmez. Raporda kanıtın yolunu verirsin.

---

## 2. Oyun hakkında bilmen gereken her şey

### Oyun ne?
**Kapı Muhafızı**, 13. yüzyıl Anadolu uç beyliği köyünde geçer. Sen kapıdaki muhafızsın.
- **Gündüz (kapı):** Gelen kişiyi sorgularsın; en çok iki soru sorabilirsin. Sonra karar verirsin: **kabul**, **ret**, **rüşvet al** ya da **kışlaya yaz**. Portre ve heybede ipuçları vardır: kaçak mal, hastalık belirtisi, casus işareti.
- **Gece (köy):** İçeri aldıkların köyde yaşar. Bina kurarsın, köylülere iş verirsin, ekonomi döner. Ardından gece olayları gelir ve gece raporu yazılır.
- **Perdeler:** Nüfus 18'e varınca ikinci perde başlar. Köy oturur, Tekfur saldırıları başlar. Perde 2'de 12 gece dayanırsan zafer gelir. Nihai son köyün durumuna göre seçilir: Tekfur Haraççısı / Ertuğrul Obası / Beyin Uç Köyü / Ahi Kasabası / Uç Tutundu. Barlardan biri kırılırsa erken bir **kırılma sonu** gelir.
- **Barlar:** Halk, Soylular, Tüccarlar, Ordu. Bunlara ek olarak akçe, ambar (erzak), üç rüşvet kesesi ve gece sayacı vardır.

### Teknik çerçeve
- Motor **Godot 4.7.2** (Forward Plus), dil GDScript. Ana sahne `res://src/arayuz/ana.tscn`. Tek autoload `Ses`.
- Godot: `C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`. Pencereli oyun için `_console` olmayan exe de aynı klasördedir.
- Kanonik kopya: `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper`. Ayna: `C:\Users\ds\Documents\GitHub\GameDevoloper`. GitHub: `berk103458/GameDevoloper`, dal `claude/festive-volta-li1sfm`.
- **Tester kendi çalışma kopyasında çalışır**, kanonik klasöre yazmaz. Önerilen kopya: `C:\Users\ds\Documents\Codex\tester-ajan` (git worktree). Her tur başında `git pull --ff-only`.

### Klasör haritası
| Yol | İçerik |
| --- | --- |
| `src/arayuz/` | Ekranlar: ana menü, kapı ekranı, köy ekranı, HUD, son ekranı |
| `src/kapi/` | Kapı sorgusu, ipuçları, tansiyon, heybe |
| `src/koy/` | Köy sistemleri (142 dosya): ekonomi, üretim zincirleri, sağlık, salgın, kriz, mevsim, meslek |
| `src/sistemler/` | `Oturum` (oyunun beyni), `GuvenliKayit` (kayıt), diyalog, sonlar |
| `src/debug/` | Admin paneli ve deney araçları (aşağıda) |
| `data/` | Bütün denge sayıları JSON'da. Metinler `data/metin/metinler.csv` içinde. |
| `design/gdd/` | Her mekaniğin tasarım belgesi (136 dosya). **Bir şey "doğru mu" diye düşünürsen önce GDD'ye bak.** |
| `karakterler/` | 10 adlı karakterin CHR markdown kaynakları |
| `tests/unit/` | Birim testleri |
| `tests/oto/` | Akış testleri (`*_kontrol.tscn`), otomatik oyuncu, fotoğraf sahneleri |
| `tools/sanity_check.py` | Tek doğrulama kapısı |
| `docs/denetim/` | Denetim raporları. Claude'un test raporu `2026-10-10-claude-test-raporu.md`; geçmiş BUG kayıtları orada. |
| `ROADMAP.md` | Bütün maddeler ve sahipleri. Yapılmış her madde `[x] (Sahip)`. |

### ROADMAP bölümleri (her biri test alanıdır)
0 Admin paneli · 1 Bugfix/performans · 2 Kapı sorgusu, tansiyon, heybe · 2.5 Karakter veri sözleşmesi · 3 Yetenek/meslek/kişilik · 4 Ekonomi, üretim zincirleri, çift kasa · 5 Yaşayan köy, zanaat rutinleri · 6 Gezgin tüccar, hayvan pazarı, sipariş · 7 Mevsim, hava, kış · 8 Casus, sabotaj, divan · 9 Muhafız odası, kişisel kasa, yozlaşma · 10 Bölge haritası, dış tehditler, haraç · 11 Salgın, şifahane, toplumsal kriz · 12 Kayıt, ses, sanity.

---

## 3. Test araçların

### 3.1 Elle oynama (pencereli)
```
"C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64.exe" --path <kopyan>
```
Kontroller: fare ya da ok tuşları ve **Enter**. Kararda **1–4** bir kararı seçer, aynı tuşa tekrar basmak onaylar. **Esc** seçimi bırakır. Seçim yokken **Esc/P** duraklatma menüsünü açar.

### 3.2 Admin paneli — en güçlü aracın
Oyun içindeyken **F1** ya da **`~`** ile açılır. Oyun durmaz. Panelde şunlar var:
- Kapı atlama, zaman hızı.
- **Kaynak enjektörü:** akçe, erzak, odun vb.
- **NPC çağırma:** istediğin karakteri kapıya getirir.
- **Bayrak denetçisi:** hikâye bayraklarını okur ve yazar.
- **Bina manipülatörü.**
- **Senaryo koşucusu:** `kitlik_10`, `baskin`, `veba` stres senaryoları.
- **Anlık görüntü:** durumu dök.
- **Kasa denetçisi:** çift kasa.
- **İklim deneyi**, **köylü denetçisi**, **kriz enjektörü**, **diyalog deneyi**, **performans şeridi**: FPS ve bellek.

Bir hatayı tekrar üretmenin en hızlı yolu admin paneliyle durumu kurmak ve bir gece ilerletmektir.

### 3.3 Otomatik oyuncu (uzun koşu / gece testi)
```
TOHUM=7 KABUL_ORANI=0.6 KLASOR=C:/.../work/tester/oto_7 <godot> --path <kopyan> tests/oto/otomatik_oyuncu.tscn
DUMAN_TESTI_20=1 <godot> --headless --path <kopyan> tests/oto/otomatik_oyuncu.tscn   # 20 gece duman
```
Oyunu baştan sona oynar ve pencereli koşuda her ekranın ilk görünüşünde ekran görüntüsü alır. **Tohumu ve kabul oranını değiştirerek** farklı oyunlar üret. 7/24 testin bel kemiği budur: düşük kabul (0.2), yüksek kabul (0.95), orta değerler, onlarca tohum.

### 3.4 Fotoğraf sahneleri (görsel kontrol)
```
CIKTI=work/tester/koy.png GUN=6 KIP=bilgi FAZ=gece <godot> --path . tests/oto/koy_foto.tscn
CIKTI=work/tester/kapi.png <godot> --path . tests/oto/kapi_foto.tscn
CIKTI=work/tester/menu.png <godot> --path . tests/oto/menu_foto.tscn
```
`koy_foto` için `KIP` değerleri bilgi, insa, rapor ve bos; `FAZ` değerleri gunduz, aksam ve gece.

### 3.5 Tam sanity (her turda en az bir kez)
```
<godot_console> --headless --editor --import --quit --path <kopyan>
python -B tools/sanity_check.py --godot <godot_console> --logs work/tester/sanity_<tarih>
```
Başarılı koşunun son satırı `Sanity: 0 failed` olur. Bugünkü beklenti yaklaşık 320 PASS. `FAIL` görürsen bu bir **P0 bulgudur**: o adımın logunu bulguya ekle.

### 3.6 Tek akış testi
`<godot_console> --headless --path . tests/oto/<ad>_kontrol.tscn`. Logda `SCRIPT ERROR`, `ERROR:`, `Failed to load script` ya da `KALDI` varsa test düşmüştür.

---

## 4. Test yöntemi — 7/24 döngü

Her **tur** aşağıdaki sırayı izler. Bir tur yaklaşık 1–2 saat sürer.

1. **Güncellen:** `git pull --ff-only`. Sonra `git log --oneline -15` ile son commitlere bak. **Son turdan beri değişen maddeler bu turun önceliğidir.**
2. **Sağlık kontrolü:** tam sanity (3.5).
3. **Değişen maddeleri test et:** commit mesajındaki madde kimliğini (ör. `KRI-14`) ROADMAP'te bul, GDD'sini oku, oyunda elle ya da admin paneliyle **kenar durumları** dene:
   - sıfır değerler, tavan değerler, boş köy, tek köylü;
   - aynı gece iki krizin birden olması;
   - kaydet → çık → yükle (kayıt/yükleme uyumu);
   - eski kayıtla açma;
   - ikinci perdeye geçiş, oyunun sonu.
4. **Otomatik koşular:** 3–5 farklı tohum/kabul oranıyla otomatik oyuncu. Çökme, sonsuz döngü, NaN, eksi stok, 0 nüfusta devam eden oyun, aynı rapor satırının iki kez yazılması gibi tuhaflıkları ara.
5. **Rastgele bölüm:** ROADMAP'ten rastgele bir bölüm seç ve "eskiden çalışan bir şey bozulmuş mu" diye regresyon testi yap.
6. **Oyuncu gözüyle oyna:** en az bir oyunu elle, gerçek bir oyuncu gibi oyna. Not al: Nerede sıkıldın? Ne anlaşılmadı? Hangi karar anlamsızdı? Hangi metin bozuk?
7. **Raporla:** bulguları, önerileri ve gelişim satırını yaz (bölüm 5). Sonra Claude'a haber ver (bölüm 6).
8. **Günlüğünü güncelle:** `codex.md/Tester.md`. Turun numarası, test ettiğin şeyler, bulgu sayısı.

### Neye özellikle bak (bu oyunun bilinen zayıf noktaları)
- **Gece sırası çakışmaları:** `KoyYonetimi.gece` içinde onlarca sistem sırayla çalışır, çoğu bir öncekinin sonucunu okur. Eski hataların çoğu buradan çıktı (ör. açlık, triyaj ve şifalı otun birbirini etkilemesi).
- **Kayıt/yükleme:** yeni bir sistemin durumu kayda girmemiş olabilir. Yükledikten sonra bir gece ilerlet ve sayıları karşılaştır.
- **Eski kayıt (legacy):** alanı eksik eski bir kayıt açılınca çökme ya da sessiz yanlış değer çıkabilir.
- **Rapor metinleri:** gece raporunda çift satır, yanlış sayı, `%d` kalıntısı, İngilizce ya da boş anahtar adı (ör. `KOY_...`).
- **Denge:** bir strateji her zaman kazanıyor mu? (ör. "herkesi reddet", "her rüşveti al"). Bir son hiç gelmiyor ya da hep geliyor mu?
- **Performans:** 30+ köylüde FPS, uzun oyunda bellek artışı.

---

## 5. Rapor yazma kuralları

### Bulgu (`BULGULAR.md`)
Numara: **TST-0001**'den başlar ve artar. Her bulgu şu kalıpla yazılır:

```markdown
### TST-0007 · P1 · KRI-14 · Arbede gecesinde nöbetçi moral cezası iki kez uygulanıyor
- **Durum:** AÇIK
- **Commit:** 2fa512e
- **Adımlar:** 1) Yeni oyun, tohum 7 2) Admin → erzak 0 3) Kriz enjektörü → kitlik 4) 2 nöbetçi ata 5) Geceyi bitir
- **Beklenen:** Nöbetçi moral −3 −5 = −8 (GDD: design/gdd/kitlik-nobeti.md)
- **Gerçek:** −16
- **Tekrar:** 3/3
- **Kanıt:** work/tester/tur12/kri14.log, work/tester/tur12/rapor.png
- **Tahmin (isteğe bağlı):** src/koy/kitlik_nobeti.gd gece() iki kez çağrılıyor olabilir
```

**Öncelik:**
- **P0:** Çökme, oyun ilerlemiyor, kayıt bozuluyor ya da sanity FAIL.
- **P1:** Mekanik yanlış çalışıyor, sayı yanlış ya da bir son ulaşılamıyor.
- **P2:** Küçük yanlış, metin hatası ya da görsel kayma.
- **P3:** Kozmetik.

**Kural:** Tekrar üretemediğin bir şeyi "Tekrar: 1/5 (kararsız)" diye yaz, **uydurma**. Tahminini gerçekle karıştırma. Önce aynı sorunun açık bir kaydı var mı diye bak, varsa yenisini açma, ona not ekle.

### Değişiklik önerisi (`DEGISIKLIK_ONERILERI.md`)
Numara: **ONR-001**. Kalıp:
```markdown
### ONR-004 · Orta · Kapı ekranı · Rüşvet kararı fazla kazançlı
- **Gözlem:** 10 oyunun 8'inde "her rüşveti al" stratejisi en yüksek akçeyle bitti; ceza hissedilmiyor.
- **Neden önemli:** Ahlaki ikilem oyunun çekirdeği; bedelsiz rüşvet ikilemi öldürüyor.
- **Öneri:** Yozlaşma eşiğinde Ordu barı daha sert düşsün ya da teftiş sıklığı artsın.
- **Kanıt:** work/tester/tur14/rusvet_istatistik.csv
```
Etki: **Yüksek / Orta / Düşük.** Öneri "şunu ekleyelim" değil, **"şu sorun var, şöyle çözülebilir"** biçiminde olmalı.

### Gelişim raporu (`GELISIM_RAPORU.md`)
Her turun ya da günün sonunda **en üste** bir giriş eklenir:
```markdown
## 2026-10-12 · Tur 14 · commit 2fa512e → 7c1d3aa
- **Sağlık:** sanity 320/0 · 5 otomatik koşu (tohum 3,7,11,19,23), 0 çökme
- **Bu turda giren:** SYS-21 (…)
- **İyileşen:** …
- **Kötüleşen / regresyon:** …
- **Oynanış hissi:** …
- **Denge eğrisi:** ortalama son gecesi 17 (önceki 15); en sık son: Uç Tutundu (6/10)
- **Açık bulgu:** P0 0 · P1 2 · P2 5 · P3 3
- **Bir sonraki tur odağı:** …
```
Sayıları **ölçerek** yaz. "Daha iyi gibi" demek yerine "ortalama gece 15 → 17" yaz.

---

## 6. Claude ile iletişim

1. Raporları `docs/tester/` dosyalarına yaz. Commit mesajı: `tester: tur N — X bulgu, Y öneri` (sadece `docs/tester/` ve `codex.md/Tester.md`). Push öncesi `git pull --rebase`.
2. **Ajan Masası** (GitHub issue #11): `[Tester → Claude] [SORUN] TST-0007 P1: kısa başlık` biçiminde yaz. Etiketler: SORU, CEVAP, UYARI, SORUN, BITTI. P0'ı **hemen** bildir; P1–P3'ü tur sonunda topluca bildir.
3. Claude bir bulguyu kapatınca durumunu `DÜZELTİLDİ (commit abc123)` yapar. Sen sonraki turda **yeniden test edersin**: geçiyorsa `DOĞRULANDI`, geçmiyorsa `YENİDEN AÇILDI` yazarsın.
4. Bir şeyin hata mı yoksa tasarım gereği mi olduğundan emin değilsen önce GDD'ye bak. Hâlâ belirsizse `[SORU]` ile sor. Tahmin yürütüp kesin hüküm verme.

---

## 7. Kalite çıtası

- Her bulgu **tekrar üretilebilir adımlar** ve **kanıt** taşır.
- Bir turda 0 bulgu çıkması normaldir. Raporu doldurmak için zayıf bulgu yazma.
- "Testi geçirmek" için hiçbir dosyayı değiştirme.
- Gördüğünü yaz; görmediğini "doğrulanmadı" diye işaretle.
- Türkçe, sade, kısa yaz.
