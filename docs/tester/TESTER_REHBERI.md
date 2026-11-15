# Tester Rehberi — Kapı Muhafızı (testx)

> **11 Ekim 2026:** Tester'ın adı artık **testx**. testx ROADMAP 2'de kod tarafına da geçti; kod işi için önce `docs/tester/TESTX_KOD_REHBERI.md`. Bu rehber testx'in oyun tarafı (test) kitabıdır ve aynen geçerlidir.

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
- Asset üretmezsin. **Asset kuralı (Berk, 11 Ekim 2026):** (1) Asset **üretilmez** (yapay zekâ ile görsel/ses/model/doku üretmek, script ile sentezlemek yok). (2) İnternette oyunumuza **uygun ve lisansı açık** bir asset bulunursa eklenebilir: yalnız CC0 / kamu malı ya da atıfla serbest (CC-BY) lisanslar; kaynak bağlantısı, yazar ve lisans `docs/EKSIK_ASSET_ENVANTERI.md`'deki ilgili satıra yazılır (atıf gerektiren lisansta atıf metni de). Ticari kullanımı yasak, belirsiz ya da "yalnız kişisel" lisanslı asset alınmaz; lisansı doğrulayamıyorsan alma. Dönem ve üsluba uymayan (modern, çizgi film, uyumsuz stil) asset alınmaz. (3) Uygun asset bulunamazsa yer tutucu kullanılır (3B: düz renk `BoxMesh`/`CapsuleMesh`; 2B: düz renk kutu) ve **oyunda kısa bir isim etiketiyle görünür**; gereken asset `docs/EKSIK_ASSET_ENVANTERI.md`'ye (madde, ad, tür, yer tutucu yolu, TR+EN arama kelimeleri, öncelik, ekleyen) yazılır. Yer tutucu tek yerden değiştirilebilir kurulur.
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

### Yerel klasörler ve repo — oyun nerede, kim nerede çalışır
| Yer | Ne | Kim yazar |
| --- | --- | --- |
| `https://github.com/berk103458/GameDevoloper` dal `claude/festive-volta-li1sfm` | **Tek doğruluk kaynağı.** Her şey sonunda buraya gelir. | Claude yayınlar |
| `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper` | **Kanonik kopya.** Codex ve Claude oyun kodunu burada geliştirir. | Codex (düzeltme), Claude (commit/push) |
| `C:\Users\ds\Documents\GitHub\GameDevoloper` | **Ayna.** Her push sonrası GitHub'dan eşitlenir. | Kimse elle yazmaz |
| `C:\Users\ds\Documents\Codex\tester-ajan` | **Senin kopyan.** Oyunu buradan açar, test eder, raporlarını buraya yazarsın. | **Tester** (yalnız `docs/tester/`, `codex.md/Tester.md`, `work/tester/`) |
| `C:\Users\ds\Documents\Codex\tester-wt` | Claude'un eski test worktree'si. | Dokunma |
| `C:\Users\ds\Desktop\Godot_v4.7.2-stable_win64.exe\` | Godot motoru (klasör adı `.exe` ile biter; içinde konsol ve pencereli exe). | — |

Akış: **Codex düzeltir (kanonik) → Claude test edip GitHub'a push eder → senin kopyan tur başında GitHub'dan çekilir → sen test edersin → raporların yayın betiğiyle GitHub'a gider → Claude okur, Codex'e düzeltme verir.** Her şey aynı repo ve aynı daldadır; bu yüzden her tur başında `git log --oneline -15` ile en son ne değiştiğini görürsün.

Nerede ne yapıldığını bulmak için:
- **ROADMAP.md** → her maddenin sahibi, dosyası, test sonucu (pano tablosu en üstte).
- **OYUN_RAPORU.md** → en yeni girişler üstte; her maddenin oyuna ne getirdiği.
- **docs/denetim/** → denetim ve hata (BUG-xxxx) raporları.
- **codex.md/Codex.md**, **CLAUDE.md** → ajanların günlükleri.
- `git log --stat -- <dosya>` → bir dosyayı kim, ne zaman değiştirdi.

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

## 6. Raporu repoya yükleme ve Claude ile iletişim

**Test ettiğin her şeyin raporu olur.** Her tur için [tur raporu şablonunu](TUR_SABLONU.md) esas alarak ayrı bir dosya açarsın: `docs/tester/turlar/TUR-NNN.md` (ör. `TUR-001.md`). İçinde:
- tarih, test ettiğin commit (`git log -1 --format=%h`), turun süresi;
- tek satırlık `soz_kapi` özeti (`soz_kapi: ihlal=..., kota=..., eksik_anahtar=...`; KLT-18) — diyalog kalitesi için öznel `Kanaat:` satırı yazılmaz, ölçü kapı sayısıdır (KLT-57);
- **test edilenler listesi**: her biri için ne denendi, nasıl (elle / admin / otomatik oyuncu / sanity / akış testi), sonuç (GEÇTİ / BULGU TST-xxxx / ÖLÇÜLMEDİ);
- kullanılan tohumlar ve komutlar;
- kanıt dosyalarının yolları (`work/tester/turNNN/...`);
- tur sonu özeti (SKILL.md'deki kalıp).
Bulgular ayrıca `BULGULAR.md`'ye, öneriler `DEGISIKLIK_ONERILERI.md`'ye, gidişat `GELISIM_RAPORU.md`'ye işlenir.

**Yükleme:** Senin ortamın git'e yazamaz; bu normaldir. Turun en son adımı olarak `work/tester/tur_hazir.json` dosyasını yaz:
```json
{"tur": 3, "commit": "3e23cd3", "rapor": "docs/tester/turlar/TUR-003.md", "yeni_bulgu": ["TST-0004"], "p0": false, "ozet": "tek satır"}
```
Claude'un yayın betiği bu dosyayı görünce yalnızca `docs/tester/` ve `codex.md/Tester.md` değişikliklerini `tester: tur N — X bulgu, Y öneri` mesajıyla commit eder, GitHub'a push eder ve kanonik kopya ile aynayı günceller. `tur_hazir.json` yoksa o turun raporu yüklenmez, bu yüzden yazmayı unutma. `p0: true` ise Claude hemen uyarılır.

1. Raporların tek kaynağı `docs/tester/` dosyalarıdır.
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

---

## 8. Sık sorulanlar (Tur 1'deki soruların cevapları)

- **Kopyam güncel değil, `git fetch` yapamıyorum.** Normal: ortamın ağa ve `.git`'e yazamaz. Tester döngüsü her turdan **önce** kopyanı GitHub'dan çeker (`git pull --ff-only`). Tur başında `git log -1` ile commit'i rapora yaz; bir dosya yoksa "bu commit'te yok" diye not düş, uydurma.
- **BUG ve TST nerede tutulur?** `BUG-xxxx` = Claude/Codex denetim kayıtları (`docs/denetim/`). `TST-xxxx` = **senin** bulguların (`docs/tester/BULGULAR.md`). Senin bulgun Claude tarafından denetime alınırsa yanına BUG numarası yazılır.
- **Koşusuz (eğitim/okuma) turunda sanity/commit alanı?** Zorunlu değil; "ölçülmedi" yaz. Commit alanına test ettiğin kopyanın `git log -1 --format=%h` değerini yine yaz.
- **`work/tester/` git'e girer mi?** Hayır, `.gitignore`'da `/work/tester/` var. Kanıtların orada kalır; rapora yolunu yazarsın.
- **Birden fazla tester olursa TST çakışması?** Şu an tek tester var. İkincisi gelirse önek alır (ör. `TST-B-0001`); karar Claude'undur.
- **Hangi skill'i kullanayım?** Senin Codex ortamında skill `kapi-tester` olarak kurulu (`$CODEX_HOME/skills/kapi-tester/SKILL.md`); içerik repodaki `.claude/skills/kapi-tester/SKILL.md` ile aynıdır. İkisi ayrışırsa repodaki geçerlidir.

---

## 9. Kurulu skill'lerin (`$CODEX_HOME/skills/`)

| Skill | Ne zaman |
| --- | --- |
| `kapi-tester` | Her tur. Ana iş akışın. |
| `bug-reproduction-brief` | Kararsız ya da tek seferlik bir hatayı en küçük, kanıtlı tekrar adımına indirmek için. TST yazmadan önce. |
| `soak-test` | Uzun oynanış turlarında (boş saatlik tur) yavaş sızıntı, bellek artışı, geç ortaya çıkan kenar durumu gözlemi. |
| `balance-check` | `data/` sayılarında aşırı uç, bozuk ilerleme, hep kazanan strateji. Sonuçlar **ONR** önerisi olur, kod değişmez. |
| `regression-suite` | Düzeltilmiş BUG/TST'lerin testi var mı, GDD kritik yolları kapsanıyor mu. Eksikler ONR olarak yazılır. |
| `test-gap-audit` | Salt okunur test boşluğu denetimi. Haftada bir yeter. |
| `godot` | Godot 4 komut satırı, sahne çalıştırma, headless kullanım başvurusu. |

Bu skill'ler genel amaçlıdır. İçlerinde "kullanıcıya sor", "Agent başlat", "AskUserQuestion", "sprint'e ata" ya da "dosyayı düzelt" gibi adımlar görürsen **atla**. Sorunu tur raporuna "Claude'a soru" olarak yaz. Bu rehberin kuralları (kod değiştirmeme, yalnız `docs/tester/` yazma) her skill'in önündedir.

---

## 10. Rapor kategorileri — sadece hata değil, oyunda değişmesi gereken HER ŞEY

Oynadığın her oyunda aşağıdaki gözlüklerle bak ve her bulguya bir **kategori** yaz (BULGULAR ve DEGISIKLIK_ONERILERI başlığında, ör. `TST-0004 · P1 · [DONMA] · KRI-11 · ...`):

| Kategori | Ne ararsın | Nereye |
| --- | --- | --- |
| `[HATA]` | Çökme, SCRIPT ERROR, yanlış sayı, kayıt bozulması | BULGULAR |
| `[DONMA]` | Oyun ilerlemiyor, düğme yok/pasif, oyuncu kilitleniyor (softlock) | BULGULAR (çoğu P0/P1) |
| `[TASARIM]` | Mekanik anlamsız, karar ağırlıksız, bir sistem hiç devreye girmiyor, döngü sıkıcı, oyuncu ne yapacağını anlamıyor | DEGISIKLIK_ONERILERI |
| `[DENGE]` | Kaynak hep sıfır (ör. odun 1. günden 0), bir son hiç gelmiyor/hep geliyor, bir strateji hep kazanıyor | DEGISIKLIK_ONERILERI (sayıyla) |
| `[CEVRE]` | 3B sahne/çevre: yanlış mevsim görseli, havada/iç içe nesne, kayan karakter, yanlış ışık, boş/çirkin alan | BULGULAR (görsel) veya ONR |
| `[DIYALOG]` | Konuşmada mantık hatası, karakterin söylediği durumla çelişiyor, tekrar eden replik, yazım hatası, `[KEY_NOT_FOUND]`, İngilizce kalıntı | BULGULAR (P2) |
| `[ARAYUZ]` | Okunmayan yazı, taşan metin, üst üste binen panel, anlaşılmayan düğme, eksik geri bildirim | BULGULAR veya ONR |
| `[PERFORMANS]` | FPS düşüşü, uzun yükleme, bellek artışı | BULGULAR |

Ekran görüntülerini (`work/tester/oyunlar/foto_<tohum>/`, donmalarda `donma_<tohum>.png`) **açıp bak**; çevre, arayüz ve diyalog bulgularının çoğu oradan çıkar. Görsel bulguya görüntünün yolunu ekle.

## 11. Anlık olay akışı (Claude ile)

- Sürekli oyun bekçisi şu olayları `~/.codex-tester/olaylar.log`'a yazar: `DONMA`, `HATA`, `KILIT`, `BITTI`. **Claude bu dosyayı canlı izler**; donma/hata olduğu an düzeltir ve push eder.
- Push gelince döngün otomatik yeni tur başlatır: o turda Claude'un düzeltmesini **doğrula** (aynı tohumla tekrar oynat), sonucu `DOĞRULANDI` / `YENİDEN AÇILDI` diye yaz.
- Senin görevin olayların **kök nedenini ve oyun tarafını** incelemek: bekçi "donma" der, sen "neden, hangi ekran, oyuncu da kilitlenir mi, tasarım sorunu mu" diye cevaplarsın.
- Örnek (11 Ekim): CHR sorgusunda (Halil) iki cevap da ipucu kilitliydi, "Kararını ver" düğmesi yoktu; otomatik oyuncu dondu. Claude oyuncuyu düzeltti; **senin işin**: gerçek oyuncu inceleme yaptıktan sonra da ipucu bulunamazsa kilitlenir mi? Bu bir `[DONMA]`/`[TASARIM]` bulgusu olabilir — doğrula ve yaz.

---

## 12. Oyuncu gibi düşün — A'dan Z'ye her şeyi test et

Sen bu oyunu **haftalardır oynayan, her köşesini bilen, her şeyi sorgulayan bir oyuncusun.** Sadece "çöktü mü?" diye bakmazsın. Her gördüğün şeyi şu sorularla tartarsın: "Bu mantıklı mı? Neden oldu? Ben oyuncu olsam ne hissederdim? Bunu daha önce gördüm mü?" Kontrol listesi aşağıda. Her turda **en az iki bölümü** derinlemesine işle, sırayla dön; bir haftada hepsi bitmiş olsun.

### 12.1 Olaylar neye göre çıkıyor? (olay–koşul mantığı)
Her olayın bir **tetikleme koşulu** vardır. Senin işin, olayın metninin varsaydığı durumla gerçek durumun uyuşup uyuşmadığını bulmak.
- **Nerede tanımlı:** gece olayları `data/olaylar/*.tres` (`kosullar`, `agirlik`, `tek_sefer`), sıra olayları `data/sira_olaylari/*.tres`, sistem olayları `src/` içinde `olay()` fonksiyonu olan sınıflar (`CasusDevriyesi`, `FisiltiGazetesi`, `SancakAskerTalebi`, `HaberciAgi` …; `src/sistemler/oturum.gd` olay seçimi). Koşul kontrolü `Oturum._kosul_tutar` (gece_min/max, perde, koyde, ayrildi, bayrak, nufus_min, sinif_min, yapi_min, ambar_max, akce_min, tarla_ekili_min, bar_min).
- **Yöntem:** Her olay için (1) metni oku (`data/metin/metinler.csv` → `olay.<id>.metin` ve seçenekleri), (2) metnin varsaydığı her şeyi listele ("okçularımız" → asker var; "pazardaki" → pazar binası var; "Miraen" → Miraen köyde ve canlı), (3) `kosullar` bu varsayımları garanti ediyor mu, karşılaştır. Garanti etmiyorsa `[TASARIM]`/`[HATA]` bulgusu.
- **Oyun içinde doğrula:** Oyun logunda her olay/kartta `OLAY ...` (metin) ve hemen ardından `DURUM ...` satırı var: gece, perde, `koy_sinif` (eski nüfus sayacı) ve `yonetim_sinif` (köydeki gerçek köylüler), akçe, ambar, yapı sayısı. **Örnek:** okçuluk olayı (`okculuk`, koşul `sinif_min asker ≥2`) çıktığında DURUM'da `yonetim_sinif` içinde asker 2'den azsa → askerler olmadan okçu olayı çıkmış demektir, bulgu.
- **Bilinen şüpheler (önce bunları araştır):**
  1. `sira_olayi_sec` sıra olaylarında yalnız `kuyruk_min`'e bakıyor; başka koşul denetlenmiyor.
  2. `koy_sinif` (Oturum.koy) ile `yonetim_sinif` (KoyYonetimi.koylular) ayrışabilir: ölüm, firar, sürgün, zindan, dış görev sonrası iki sayı aynı mı? Ayrışırsa olaylar yanlış sayıya göre çıkar.
  3. `tek_sefer` olmayan olaylar aynı oyunda kaç kez tekrar ediyor? Rahatsız edici sıklıkta mı?
  4. Ölmüş/ayrılmış adlı karakterle ilgili olay sonradan yine çıkıyor mu?

### 12.2 Konuşmalar ve metin (DİYALOG)
- **Kaynaklar:** kapı sohbetleri `data/sohbetler/*.tres`, adsız diyaloglar `data/diyalog/diyalog_01_20.json`, adlı karakter (CHR) sorgu ağaçları `karakterler/` + `data/chr_runtime/`, tüm metinler `data/metin/metinler.csv` (~1700 satır). Turda bir dilim oku (ör. 150 satır), hepsini sırayla bitir.
- **Neye bakarsın:**
  - **Yazım/Türkçe:** yazım hatası, eksik/yanlış harf (ı/i, ş/s, ğ/g), yanlış ek, devrik ya da bozuk cümle, makine çevirisi kokan ifade, İngilizce kalıntı, `[KEY_NOT_FOUND]`, `%d`/`%s` kalıntısı, çift boşluk, kesik cümle.
  - **Saçma/uydurma:** bağlamla ilgisiz, anlamsız, çelişkili ya da gereksiz uzun/tekrar eden cümle; karakterin kişiliğine uymayan konuşma; dönemine (13. yy Anadolu) uymayan kelime.
  - **Kısalık:** konuşma neden kısa kalıyor? Kaç soru sorulabiliyor (`azami_soru`), her karakterin kaç sorusu var, takip soruları (`soru_ust`) açılıyor mu, CHR ağacı kaç düğüm? Oyuncu için yetersiz derinlik varsa `[TASARIM]` önerisi yaz (sayılarla: "chr_007'nin 3 sorusu var, 2'si sorulabiliyor, hiç takip sorusu yok").
  - **Tutarlılık:** karakter aynı gün içinde kendisiyle çelişiyor mu? Cevap, sorulan soruyla uyuşuyor mu? Kabul/ret sonrası metin doğru kişiyi/durumu anlatıyor mu?
- Her dil bulgusunda **tam metni ve anahtarını** yaz (ör. `olay.okculuk.metin`), düzeltilmiş önerini ekle. CSV'yi **sen değiştirmezsin**.

### 12.3 Animasyon ve 3B sahne (CEVRE)
- **Araçlar:** oyun ekran görüntüleri (`foto_<tohum>/`), donma anı (`donma_<tohum>.png`), model önizleme sahnesi `tests/oto/model_onizleme.tscn`, kapı/köy fotoğraf sahneleri (§3.4). Pencereli açarken **daima** `--audio-driver Dummy`.
- **Neye bakarsın:** T-pozu ya da animasyonsuz donuk karakter; ayakların yerde kayması (yürürken yer değiştirmeden adım ya da adımsız kayma); havada duran ya da yere gömülü karakter/nesne; iç içe geçen modeller; yanlış yöne bakarak yürüme; animasyon geçişinde zıplama/titreme; elde tutulan eşyanın (el eşyası) elden kopuk durması; mevsimle uyuşmayan görsel (yazın kar, kışta yeşil); gece/gündüz ışığı hatası; kaybolan/yanıp sönen nesne; kameranın nesne içinde kalması; aynı modelin farklı kişiler için tekrar kullanılıp karıştırılması.
- Kaynak: `src/dunya/` (`karakter_model.gd`, `guvenli_karakter_animasyonu.gd`, `durus_duzeltici.gd`, `el_esyasi.gd`). Hata gördüğün görüntünün yolunu ve hangi karakter/ekran olduğunu yaz.

### 12.4 A'dan Z'ye oyuncu yolu (her ekranda)
Ana menü → ayarlar (her ayar gerçekten etkili mi?) → yeni oyun → kapı (gelen, sohbet, heybe/inceleme, karar, rüşvet, kışla, sıra olayları) → köy (inşa, atama, yol, yık, pazar, nüfus, divan, muhafız odası, harita) → gece raporu ve kartlar (mini oyunlar dahil) → mevsimler → krizler (kıtlık, salgın, isyan, yangın) → 2. perde → sonlar (5 nihai son + kırılma sonları) → kaydet/devam/yükle. Her adımda: **anlaşılıyor mu, geri bildirim var mı, sayı doğru mu, metin doğru mu, görsel doğru mu, mantıklı mı?**

### 12.5 Uzun oyun gözlemi
Uzun süre oynayan oyuncu tekrarı, bıkkınlığı ve dengesizliği fark eder. Oyun kayıtlarından (`ozet.tsv`, `OLAY`/`DURUM`/`gün` satırları) ölç: oyun kaç günde bitiyor, hangi son ne sıklıkla geliyor, aynı olay kaç kez tekrar ediyor, hangi kaynak sürekli 0 (ör. odun 1. günden 0), akçe/ambar eğrisi, nüfus 2. perdeye kaç günde ulaşıyor. Örnek gözlem (11 Ekim, oyun 106): kabul %90 ile oyun 7. gecede "Tekfur'un akıncıları" ile bitti — 2. perde çok erken ve çok çabuk mu kaybediliyor? Bunlar `[DENGE]`/`[TASARIM]` önerisi olur.

---

## 13. Ayrıntılı muayene — karakter, harita/çevre, Türkçe, asset (oyun sonu değil, en ince ayrıntı)

Oyun sonuna bakmak yetmez. Her turda aşağıdaki **dört muayeneden en az birini** derinlemesine yap, sırayla dön. Her biri ayrı bir rapor bölümü olarak tur raporuna girer; bulgular BULGULAR / DEGISIKLIK_ONERILERI'ye kategoriyle yazılır.

### 13.1 Karakter muayenesi (yürüyüş, eller, kollar, duruş, el eşyası)
**Araç:** `tests/oto/karakter_muayene.tscn` — her modeli oyundaki gibi kurar, her hareketini (bekle, yürü, konuş, sevinç, öfke, panik, gergin) önden ve yandan 3'er karede çeker; karakter başına TEK temas sayfası (`<ad>.jpg`, satır = hareket, sol 3 sütun önden, sağ 3 sütun yandan) ve sayısal ölçüm (`muayene.json`).
```
KLASOR=C:\...\tester-ajan\work\tester\muayene [MODELLER=chr_001,aydogdu] <godot_console> --path . --audio-driver Dummy --windowed tests/oto/karakter_muayene.tscn
```
(44 modelin hepsi ~10 dk; pencere açılır, sesi yok.) **Önce `muayene.json`'u oku** (her modelin `uyarilar`, `eksik` hareketleri, `hareketler.<ad>.ayak_y/el_aci/el_y/boy` aralıkları, `kemikler`). Sayısal uyarısı olan modellerin sayfasına bak (turda en fazla 4 sayfa).
- **Ölçüm eşikleri:** `ayak_y` > 0.08 havada, < −0.08 gömülü; `el_aci` > 0.45 T/A-pozu şüphesi (bekle/yürü); `el_y` > 0.35 kollar havada; `boy` < 1.2 ya da > 2.3 ölçek şüphesi (çocuk karakter mi? GDD/CHR'den doğrula).
- **Gözle bak:** kollar gövdeye girmiş mi, eller bilekten kırık/ters mi, parmaklar yamuk mu; yürürken ayak kayıyor mu (yerinde yürümede ayaklar ileri-geri gidip gelmeli); diz/dirsek ters kırılıyor mu; **el eşyası** (yay, sopa, sepet) gövdeden/bacaktan geçiyor mu (11 Ekim örneği: Aydoğdu'nun yayı yandan bakışta bacağın ve gövdenin içinden geçiyor); kıyafet parçası (çizme/pantolon) arasında boşluk ya da kopukluk var mı; yüz/saç bozuk mu; iki karakter birbirinin aynısı mı.
- **Eksik hareket:** `eksik` listesi — ör. tüm CHR modellerinde `gergin` yok, adlı karakterlerin çoğunda yalnız bekle/yürü var. Oyunda bu hareketler çağrılıyorsa karakter donuk kalır → `[CEVRE]`/`[TASARIM]` önerisi (eksik asset envanterine girer).

### 13.2 Harita ve çevre muayenesi
**Araçlar:** köy fotoğrafı `tests/oto/koy_foto.tscn` (`GUN`, `KIP=bilgi|insa|rapor|bos`, `FAZ=gunduz|aksam|gece`, `KAMERA=uzak`), kapı fotoğrafı `tests/oto/kapi_foto.tscn` (`GECE`, `PERDE`, `SUR`, `BEKLE`, `ARAYUZ=0` arayüzsüz), 7/24 oyunların `foto_<tohum>/` görüntüleri. Pencereli + `--audio-driver Dummy`.
- **Neye bakarsın:** havada duran/yere gömülü bina, ağaç, kaya, çit; iç içe geçen nesneler; zemin dokusunda dikiş/kırık; yanlış mevsim (yazın kar, kışta yeşil yaprak); gece/gündüz/akşam ışığı mantıklı mı, meşale/ateş ışığı var mı; uzak kamerada boş/yarım kalmış alanlar; yol ile bina hizası; **kutu/kapsül yer tutucular** (asset kuralı gereği geçici `BoxMesh`/`CapsuleMesh` — hangileri hâlâ kutu, oyuncuya çirkin görünüyor mu?).
- Her bulgu: ekran görüntüsü yolu + ne/nerede (ör. "kapı sahnesi, gece 5, sağ arka: kaya havada").

### 13.3 Türkçe ve metin muayenesi (gerçekten doğal Türkçe mi?)
- **Kaynak:** `data/metin/metinler.csv` (~1700 satır), `data/sohbetler/*.tres`, `data/diyalog/diyalog_01_20.json`, `karakterler/*.md`. Her turda bir **dilim** (ör. 150 satır) oku, kaldığın satırı tur raporuna yaz, sonraki turda devam et; böylece bütün metin taranır.
- **Bak:** yazım (ı/i, ş/s, ğ/g, ç/c, ö/o, ü/u), ek ve ünlü uyumu, büyük/küçük harf, noktalama; **çeviri kokan** cümle (İngilizce yapısında kurulmuş, "yapmak" fiilini zorlayan, devrik değil bozuk dizilim); anlamsız/saçma ya da yapay zekâ üretimi gibi duran boş laf; aynı cümlenin farklı yerlerde tekrar etmesi; döneme (13. yy Anadolu uç beyliği) uymayan kelime (ör. modern terimler); karakter ağzına uymayan dil; `%d`, `%s`, `[KEY_NOT_FOUND]`, çift boşluk, kesik cümle.
- Her bulguda: **anahtar + tam metin + önerdiğin doğal Türkçe hâli**. CSV'yi değiştirmezsin.

### 13.4 Asset muayenesi (düzeltilmesi/eklenmesi gereken asset'ler)
- `docs/EKSIK_ASSET_ENVANTERI.md` zaten bilinen eksikleri listeler; senin işin **oyunda gerçekten göze batanları** sıralamak: hangi yer tutucu (kutu/kapsül/düz renk) oyuncunun en çok gördüğü yerde, hangi model bozuk (13.1), hangi doku düşük çözünürlüklü/esnemiş, hangi ses eksik (log'da sessiz çağrı).
- Çıktı: tur raporunda "Asset öncelik listesi" tablosu (asset · nerede görünüyor · sorun · öncelik · kanıt görüntüsü). Asset **üretmezsin**; uygun ve açık lisanslı karşılığını internette bulursan listeye kaynak ve lisansıyla öneri olarak yaz (eklemeyi kod görevinde yaparsın) (asset kuralı); sadece raporlarsın.

---

## 14. Oyun köprüsü ile oynama (ADM-16)

ADM-16, tester'ın kendi kararlarını gerçek oyuncu UI yoluyla göndermesini sağlar.
Normal oyunda kapalıdır; `godot --path . --audio-driver Dummy -- --bridge-port 9316`
veya `BRIDGE_PORT=9316` ile localhost üzerinde açılır. Komut sözleşmesi ve JSON
örnekleri: [design/gdd/oyun-koprusu.md](../../design/gdd/oyun-koprusu.md).

```powershell
python -B tools/tester_oyuncu.py --godot <godot_console> --headless --tohum 11 --politika temkinli --gece 10 --cikti work/tester/oyun_11.jsonl
```

`--politika rastgele|temkinli|rusvetci|hikaye_odakli`; `--headless` çıkarılırsa pencereli.
`--zaman-asimi 1800` oyun süresi sınırıdır. Her adımın durumu, gönderilen eylem ve
hatası JSONL'e; Godot konsolu `.godot.log`, özet `.ozet.json` dosyasına gider.
Araç kendi oyununu başlatır ve sonunda temizler; insan kayıtları ayrı tutulur.

Kendi kararlarınla oynama yöntemi:

1. `Bridge(port=9316).call("get_state")` ile ekran, kişi, görünen ipuçları,
   etkin seçenekler, kasalar, kaynaklar ve köyü oku.
2. `hazir=true`, `mesgul=false` olduğunda karar ver. Kapıda görünen konuşma ve
   ipuçlarını değerlendir; köyde nüfus/üretim/maliyetlere göre plan yap. İndeksler
   son UI listesindeki sıfır tabanlı indekslerdir.
3. `soru_sor(indeks=...)`, `devam(indeks=...,alan="eylem")`,
   `kapi_karar(karar="kabul|ret|rusvet|kisla")`,
   `koy_eylem(tur="insa",bina="tarla",hucre=[x,y])`,
   `koy_eylem(tur="ata|kaldir",koylu=id,bina=id)` veya `gece_bitir` gönder.
   `koy_eylem(tur="kaldir",bina=id)` bina yıkar; köylü belirtilirse işten çıkarır.
4. Rapor/olay seçeneklerini `devam(indeks=...)` ile kendin seç; mini oyunda her
   `devam` bir gerçek basıştır. Durumu yeniden oku. Animasyonda bekle. Son ekranı
   veya kendi gece sınırında özet/bulgu yaz.

Diğer komutlar: `ping`, `yeni_oyun(tohum=...)` (menü/son), `kaydet`, `yukle`
(mevcut UI kayıt noktası), `screenshot(yol="work/tester/kapi.png")` (pencereli),
`quit`. Hata açıklamasını kaydet; kayıp yanıt sonrası eylemi körlemesine tekrar
etme. Dört bar mevcut 0–10 göstergedir; CHR sohbeti soru kotası yerine dallanan
seçenekler kullandığı için kalan soru hakkı `-1` olur. Bu araç bir örnek politikadır;
tester her adımda get_state çıktısını okuyup tamamen farklı karar verebilir.
