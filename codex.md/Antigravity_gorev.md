# Antigravity (agy, Berk) görevi — Berk tarafı, 15 Kasım 2026

## Amaç

ROADMAP_2.md başındaki boş, sahipsiz maddeleri bitir. Sen listenin başından ilerlersin. Her maddeyi sahiplen, uygula, hedefli testle ve kendin `[x]` işaretle. Döngüde durma.

## Kapsam

Kaynak: `ROADMAP_2.md` (aktif liste). Bu grubun **34** boş `[ ]` maddesi var. Bölümler:
- **BÖLÜM 15: Kapı Akışı ve Nüfus Gerçekçiliği (Faz 1)** (1 madde): KAP-18
- **BÖLÜM 20: İş Gücü, Meslek Uyarısı ve Geçici İşler (Faz 4)** (1 madde): ISG-39
- **BÖLÜM 21: Yapı Kilidi, Ustalar, Usta Defterleri ve Yapı Resimleri (Faz 4)** (3 madde): YAP-03, YAP-06, YAP-55
- **BÖLÜM 23: Zamanla İlerleyen Dünya (Faz 5)** (4 madde): DNY-01, DNY-02, DNY-03, DNY-04
- **BÖLÜM 24: Arayüz, Görsel Dil ve Yükleme Ekranları (Faz 6)** (4 madde): ARY-02, ARY-03, ARY-04, ARY-70
- **BÖLÜM 25: Diyalog — Sorgu Eylemleri, Kapı Dışındaki Sonuçlar ve Yazım Araçları (Faz 2–3)** (1 madde): DYL-14
- **BÖLÜM 25a: Sevilen Yüz — Köyde Tekrar Görme (Faz 4)** (1 madde): SEV-05
- **BÖLÜM 30: Yılın izi** (1 madde): YIL-09
- **BÖLÜM 32: Denge yeniden ayarı ve ekonomi ölçümü** (2 madde): DEN-37, DEN-38
- **BÖLÜM 33: Oyuncuyu alıştırma ve ilk saat** (2 madde): OGR-23, OGR-57
- **BÖLÜM 34: Ana hikâye omurgası ve perde yapısı** (2 madde): OMR-33, OMR-55
- **BÖLÜM 35: Ayarlar, erişilebilirlik ve okuma konforu** (2 madde): AYR-29, AYR-33
- **BÖLÜM 36: Muhafızın kişisel hayatı ve hane içi diyalog** (2 madde): HAN-13, HAN-34
- **BÖLÜM 37: Söylenti, dedikodu ve kamuoyu ağı** (8 madde): SOY-25, SOY-27, SOY-34, SOY-35, SOY-36, SOY-37, SOY-43, SOY-46

Madde listesi (satır numarası ROADMAP_2.md içindir):

- [ ] **KAP-18** (ROADMAP_2.md:340) — (Cursor bıraktı: DNY-01 dünya savaş olayı ve KAP-17 kafilesi yok) Yetimler ve savaştan kaçan çocuklar. *(metin tamam, Kalfa bekleniyor — Antigravity: `data/soz/yetim_kafilesi.json`, `data/soz/en/yetim_kafilesi.json` v...
- [ ] **ISG-39** (ROADMAP_2.md:1374) — Grev söylenti eşiğini SOY-34 okur
- [ ] **YAP-03** (ROADMAP_2.md:1544) — (Cursor bıraktı: geliş ağırlığı KAP-16 (testx) çekiciliği ve DNY olayını okur; ikisi açık) Ustalar kapıdan gelir — özel karakterler. *(metin tamam, Kalfa bekleniyor — Antigravity: `data/ustalar.json`, `data/soz/usta_*...
- [ ] **YAP-06** (ROADMAP_2.md:1642) — Özel eşyalar. *(metin tamam, Kalfa bekleniyor — Antigravity: `data/ozel_esyalar.json` içinde 8 özel eşya ve `esya.ozel.*` metin anahtarları eklendi)*
- [ ] **YAP-55** (ROADMAP_2.md:1678) — Yapı kartı tema zemini ister
- [ ] **DNY-01** (ROADMAP_2.md:1773) — Dünya zaman çizelgesi. *(metin tamam, Kalfa bekleniyor — Antigravity: `data/dunya/zaman_cizelgesi.json` TR/EN ve `dunya.olay.*` metin anahtarları eklendi)*
- [ ] **DNY-02** (ROADMAP_2.md:1783) — Haber önce insanlardan duyulur. *(metin tamam, Kalfa bekleniyor — Antigravity: 6 olay için 2'şer erken söylenti ve kesin haber karakter repliği `dunya.haber.*` olarak TR/EN eklendi)*
- [ ] **DNY-03** (ROADMAP_2.md:1792) — Olayların köye etkisi. *(metin tamam, Kalfa bekleniyor — Antigravity: tek kapı hedefleri ve gece raporu satırları `dunya.rapor.*` olarak TR/EN eklendi)*
- [ ] **DNY-04** (ROADMAP_2.md:1801) — Oyuncunun kararları dünyaya geri döner. *(metin tamam, Kalfa bekleniyor — Antigravity: `tekfur_haraci`, `mogol_elcisi`, `turkmen_ittifaki` için `kabul`/`ret`/`bekliyor` dönüş metinleri `dunya.donus.*` olarak TR/EN ekl...
- [ ] **ARY-02** (ROADMAP_2.md:1850) — Tema altyapısı — seçilen dil tek yerden.
- [ ] **ARY-03** (ROADMAP_2.md:1865) — Ekranların taşınması — harita, sorgu, seçim, köy HUD, pazar, divan, oda, gece raporu.
- [ ] **ARY-04** (ROADMAP_2.md:1880) — Yükleme ekranları ve ara sahne çerçevesi — çeşitli, tekrarsız.
- [ ] **ARY-70** (ROADMAP_2.md:1913) — Üç genişlik açılır
- [ ] **DYL-14** (ROADMAP_2.md:2165) — (Antigravity) Kaynaklı örnek defteri — bir köylü buna nasıl cevap verir? (doğrulanmadı — Görev 22; `docs/dunya_kitabi/ornek_defteri/` ve `tests/tools/test_ornek_defteri.py` yok; `docs/ORNEK_DEFTERI.md` kaynaksız 11 ör...
- [ ] **SEV-05** (ROADMAP_2.md:2279) — (Antigravity) Köylüler birbirine bağlanır. (doğrulanmadı — Görev 22; SevilenYuz (src/koy/sevilen_yuz.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten)
- [ ] **YIL-09** (ROADMAP_2.md:2834) — (Cursor) Söylenen ad karttaki addır (doğrulanmadı — Görev 22; YilIzi (src/koy/yil_izi.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten; Görev 23: yıl satırı artık oyunda ve kartta duran adı (Koylu.ad) söyl...
- [ ] **DEN-37** (ROADMAP_2.md:3591) — Eşin mesleği demirhaneye yazılmaz.
- [ ] **DEN-38** (ROADMAP_2.md:3597) — Meslek değişiminin bir günlük kaybı durur.
- [ ] **OGR-23** (ROADMAP_2.md:4033) — Boş gün ilk kez gelince açıklanır.
- [ ] **OGR-57** (ROADMAP_2.md:4255) — Kapanış testi — altı gece tek koşu.
- [ ] **OMR-33** (ROADMAP_2.md:4493) — Boş gün oranı perdeye göre değişir.
- [ ] **OMR-55** (ROADMAP_2.md:4637) — Kapanış testi — iki perde tek koşu.
- [ ] **AYR-29** (ROADMAP_2.md:4854) — Yuva kartı. (Antigravity) (doğrulanmadı — Görev 22; KayitYuvaKarti (src/arayuz/kayit_yuva_karti.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten)
- [ ] **AYR-33** (ROADMAP_2.md:4878) — Uyumsuz kayıt açılmaz, açıklanır. (Antigravity) (doğrulanmadı — Görev 22; KayitYuvaKarti (src/arayuz/kayit_yuva_karti.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten)
- [ ] **HAN-13** (ROADMAP_2.md:5113) — (Antigravity) Misafir eşle konuşur. (doğrulanmadı — Görev 22; AksamSohbeti (src/koy/aksam_sohbeti.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten)
- [ ] **HAN-34** (ROADMAP_2.md:5251) — (Antigravity) Eş çınarda söz alır (MCL-03'ün hane tarafı). (doğrulanmadı — Görev 22; AksamSohbeti (src/koy/aksam_sohbeti.gd) oyunda hiçbir sahne/betikten çağrılmıyor, yalnız testten)
- [ ] **SOY-25** (ROADMAP_2.md:5556) — Dış söylenti çelişir (DNY-02 kural 1). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-27** (ROADMAP_2.md:5568) — Söylenti satırları YAZ kotasına girer. (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-34** (ROADMAP_2.md:5616) — Grev söylentiden tetiklenebilir (`meslek_grevi.gd`). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-35** (ROADMAP_2.md:5622) — Husumet söylentiyle büyür (`husumet.gd`, `kan_davasi.gd`). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-36** (ROADMAP_2.md:5628) — Pazar fiyatı söylentiye tepki verir (`ticaret_fiyatlari.gd`). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-37** (ROADMAP_2.md:5634) — Göç söylentisi (`goc_yolu_guvenligi.gd`). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-43** (ROADMAP_2.md:5676) — "Duydum ki" kalıpları şablon dilbilgisidir (YAZ-09). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)
- [ ] **SOY-46** (ROADMAP_2.md:5694) — Köy sohbeti söylentiyi okur (YAZ-08). (doğrulanmadı — Görev 22; SoylentiAgi oyunda hiçbir sahne/betikten kurulmuyor ve kayda yazılmıyor, yalnız testten çağrılıyor)

Grup dışındaki boş maddelere, kendi grubun bitmeden başlama. Grup bitince kalan herhangi bir boş `[ ]` maddeye geç.

## Kurallar

- Çalışma alanı yalnız `D:\Kapi_Muhafizi\GameDevoloper` ve gerekirse `D:\Kapi_Muhafizi\work` ile `D:\Araclar`dır. D: dışına çıkma. Dal: `claude/festive-volta-li1sfm`.
- Kod yazmadan önce `git pull` et. Sonra yalnız boş `[ ]` maddeyi `[/] (Antigravity-Berk)` yap, bu sahipliği commit'le ve push et. Push başarılı olmadan koda başlama. İlk push eden maddenin sahibidir.
- Başkasının `[/]` veya `[x]` maddesine dokunma. Rebase veya merge sırasında ROADMAP satırını kendi eski hâlinle ezme.
- Maddeni bitirince hedefli headless Godot testi koş: `D:\Araclar\Godot\Godot_v4.7.2-stable_win64_console.exe`. Test gerçekten geçmeden, kod oyuna bağlanmadan ve bozulunca test düşmeden `[x]` koyma. Sahte GEÇTİ yok. Konsolda `SCRIPT ERROR` varken birleştirme veya `[x]` yok.
- Test gerçekten geçince maddeyi kendin `[x] (Antigravity-Berk)` yap, commit'le ve push et. (Berk'in yeni kuralı: ajan kendi maddesini işaretler.)
- Bir madde bitince pull et, kendi grubundaki sıradaki boş `[ ]` maddeyi sahiplen ve devam et. Grubun biterse ROADMAP_2.md içindeki herhangi bir kalan boş `[ ]` maddeyi al (başkasının `[/]` olanına değil).
- Yalnız boş `[ ]` maddeler bitince veya gerçek bir engel çıkınca dur. O zaman `codex.md/Antigravity.md` dosyasının sonuna tek başına bir satır yaz: iş bittiyse `TAMAMLANDI`, gerçek engelde `ENGEL`. ENGEL satırının hemen altına kısa gerekçeyi ekle.
- En geç saatte bir veya madde bittiğinde commit at ve push et. İş yarım kalsa bile `WIP:` önekli commit at. Commit mesajları Türkçe olur ve `(Antigravity-Berk)` imzası taşır.
- Force push ve `reset --hard` yok. Asset üretme (görsel, doku, 3B model, ses, müzik, animasyon yok). Eksik asset için yer tutucu kullan ve `docs/EKSIK_ASSET_ENVANTERI.md` güncelle. Gizli bilgi (anahtar, parola, token) yazma, commit'leme, loglama.
- Ahmet tarafının asset üretim ajanına ve onun işine dokunma. Başka ajanın çalışma ağacını bozma.

## Bitiş ölçütü

- Kendi grubundaki bütün boş maddeler (ve sonra kalan sahipsiz boş maddeler) ya `[x] (Antigravity-Berk)` olmuştur ya da başkası o sırada sahiplenip bitirmiştir.
- Her `[x]` maddesinin hedefli headless testi gerçekten geçmiştir; bozulunca test düşer; kod oyunda çağrılır.
- Çalışma `codex.md/Antigravity.md` günlüğüne işlenmiştir. İş bitince son satır `TAMAMLANDI`, gerçek engelde `ENGEL` olur.
- Kota %15'in altına düşerse yeni madde alma; elindeki işi commit'le, bitiremediğin `[/]` maddeyi gerekirse bırakıp günlüğe yaz.

## Rapor

İlerlemeyi `codex.md/Antigravity.md` dosyasının sonuna ekle: hangi maddeyi aldığın, ne yaptığın, testin nasıl geçtiği, kalan kota (göremiyorsan `kota görünmüyor`). Her commit/push sonrası güncelle.

## Codex'ten devir (limit)

Codex kullanım limiti doldu (sıfırlanma: 15 Kasım 2026, 20:56 Europe/Istanbul). Aşağıdaki **16** madde, Codex'in bitmemiş işinden (açık `[/] (Codex-Berk)` + aralıktaki kalan `[ ]`, KLT-13…GRV-64) geçici olarak sana devredildi. Kota sıfırlandıktan sonra Usta bunları Codex'e iade edebilir.

Elindeki mevcut `[/]` işi bitirdikten sonra orijinal grubunun bitmesini beklemeden bu devir listesine geç. Boş maddeleri önce `[/] (Antigravity-Berk)` ile sahiplen (commit+push), sonra uygula, hedefli testle ve kendin `[x]` işaretle. GRV-32 zaten `[/] (Antigravity-Berk)` olarak işaretlendi; yeniden sahiplenmen gerekmez.

- [ ] **KLT-13** (ROADMAP_2.md:6449) — DYL-13 yan yana bakış kapı adımıdır. Not: Codex daha önce KLT-13 için DYL-13 kayıt sözleşmesi yok diye ENGEL yazmıştı; gerekirse atlayıp listedeki bağımsız maddelere geç.
- [ ] **KLT-14** (ROADMAP_2.md:6455) — DYL-14 örnek defteri yazarın elindedir.
- [ ] **KLT-47** (ROADMAP_2.md:6474) — (Cursor bıraktı: DYL-14 örnek defteri yok (Antigravity Görev 24)) Örnek cümle kadro adıdır
- [ ] **KLT-18** (ROADMAP_2.md:6529) — Tester K7 kör noktası bu kapıya bağlanır.
- [ ] **KLT-57** (ROADMAP_2.md:6542) — Hikâye personası dal gezmez diye kalite puanı yazılmaz
- [/] **GRV-32** (ROADMAP_2.md:7383) — `chr_inceleme_paneli.gd` temaya bağlanır. Not: Codex-Berk bu maddeyi `d6419b67` ile sahiplendi; limit öncesi uygulama commit'i yok (yalnız ROADMAP sahipliği). Sahiplik şimdi Antigravity-Berk. Kaldığın yerden uygula, test et, `[x]` işaretle.
- [ ] **GRV-33** (ROADMAP_2.md:7390) — `grafik_ayarlari_paneli.gd` temaya bağlanır.
- [ ] **GRV-35** (ROADMAP_2.md:7404) — `hud.gd` temaya bağlanır.
- [ ] **GRV-37** (ROADMAP_2.md:7418) — `koylu_karti.gd` temaya bağlanır.
- [ ] **GRV-39** (ROADMAP_2.md:7432) — `heyet_kapi_paneli.gd` temaya bağlanır.
- [ ] **GRV-40** (ROADMAP_2.md:7439) — `tuccar_kapi_paneli.gd` temaya bağlanır.
- [ ] **GRV-41** (ROADMAP_2.md:7449) — `oda_gelistirme_paneli.gd` temaya bağlanır.
- [ ] **GRV-42** (ROADMAP_2.md:7456) — `oda_kasasi_paneli.gd` temaya bağlanır.
- [ ] **GRV-43** (ROADMAP_2.md:7463) — `oda_terazisi_paneli.gd` temaya bağlanır.
- [ ] **GRV-44** (ROADMAP_2.md:7470) — `oda_vicdan_paneli.gd` temaya bağlanır.
- [ ] **GRV-45** (ROADMAP_2.md:7477) — `oda_yetenek_paneli.gd` temaya bağlanır.

## Sahipsiz yarım maddeler devri

15 Kasım 2026, 21:03 Europe/Istanbul (Berk). Ahmet tarafı Cursor 19:40'ta kalan açık/yarım maddelerin Berk tarafına ait olduğunu bildirdi (`c8d0d423`). 27 sahipsiz/yarım madde, iade sonrası açık yüke göre paylaştırıldı:

- Antigravity-Berk kalan iş: 24 maddeydi; Claude limiti nedeniyle ek 6 madde aldı (OGR-43, KAP-16, KAP-39, KAP-45, KAP-48, ACL-02)
- Codex-Berk kalan iş: 18 iade edilmiş `[/]` madde (çalışabilir; en çok payı aldı)
- Claude-Berk: 5 saatlik kota limiti (sıfırlanma 23:10 Europe/Istanbul); bu 27 maddeden pay yok

Rutin `Codex limit sonrası geri dönüş` 18 başlanmamış devir maddesini zaten Codex-Berk'e iade etti (`63120aee`); bu commit onu tekrarlamaz.

Berk'in güncel emri: Claude 5 saatlik limitte (sıfırlanma 23:10 Europe/Istanbul), bu 27 maddeden pay almaz. Iade + ilk paylaşım sonrası yük: Antigravity 24, Codex 39; kalan **6** madde (Claude'a verilenler) yüküne göre sana alındı. ROADMAP'de `[/] (Antigravity-Berk)` olarak işaretlendi; yeniden sahiplenmen gerekmez. Codex'ten iade edilen KLT-13/14/47'yi alma. Bitirdiğin KLT-18/57 ve GRV-32…45 sende `[x]` olarak kalır. Elindeki ISG/SOY işini bitirdikten sonra bu listeye geç.

- [/] **OGR-43** (ROADMAP_2.md:4167) — Yedi persona ilk saati geçer. (Kanıt Antigravity'de; Cursor doğrulaması bekleniyordu.) Not: Eski sahip `(Antigravity)` (Ahmet tarafı). Uygulama `70ecc754`, `20461b6f`; Usta `[x]` geri alımı `ac18fe16`; Cursor-Berk doğrulaması KALDI `398d6d11` / devralma `46e74e2f`; sahiplik iadesi `8160160b`. Cursor doğrulaması hâlâ bekleniyor. Mevcut kanıtı bozmadan doğrulamayı bitir, test et, `[x]` işaretle.
- [/] **KAP-16** (ROADMAP_2.md:310) — Değişken gelen sayısı, boş gün ve sayfadaki bar eşiği. Not: Eski etiket `(testx)`; ROADMAP sahipliği `75dbf1d0`. Uygulama commit'i bulunamadı.
- [/] **KAP-39** (ROADMAP_2.md:356) — Heybe açıkken soru seçilmez. Not: Eski etiket `(testx)`; ROADMAP sahipliği `2e19df1c` (KAP-39/45/48 birlikte). Uygulama commit'i bulunamadı.
- [/] **KAP-45** (ROADMAP_2.md:380) — Karar bir kez uygulanır. Not: Eski etiket `(testx)`; ROADMAP sahipliği `2e19df1c`. Uygulama commit'i bulunamadı.
- [/] **KAP-48** (ROADMAP_2.md:387) — Rüşvet hakkı ayardadır. Not: Eski etiket `(testx)`; ROADMAP sahipliği `2e19df1c`. Uygulama commit'i bulunamadı.
- [/] **ACL-02** (ROADMAP_2.md:223) — Eş — oynanabilir ama sıradan köylü değil. Not: Eski etiket `(testx)`; ROADMAP sahipliği `0a24eb92`. Uygulama commit'i bulunamadı.

onay bekleyip durma; maddeler bitene ya da gerçek bir engel çıkana kadar devam et

---

## Görev 27: ROADMAP_3 sıra tabanlı savaş yol haritasını yaz

Hedef model: **Gemini 4 Hydrogen High**. Bu görev tamamen Hydrogen High'a bırakılır. Ajan adı: Antigravity. Günlük: `codex.md/Antigravity.md`. Dal: `claude/festive-volta-li1sfm`. Onay: Ahmet, 15 Kasım 2026, ek talimat 22:05.

Bu görev, yukarıdaki ROADMAP_2 madde döngüsünden ayrıdır. Bu turda kod yazılmaz, test koşulmaz, ROADMAP_2.md'ye dokunulmaz. Tek iş `ROADMAP_3.md` dosyasını yazmaktır. Yazım bittikten sonra denetim Codex'indir (`codex.md/Codex_gorev.md` içindeki "ROADMAP_3 son denetimi"). Hydrogen denetimi beklemez.

### Benzersizlik kuralı (en önemli kural)

Her madde benzersizdir. Kapsamı başka hiçbir maddeyle örtüşmez. Madde 1 ile madde 2 farklı işlerdir. Birbirini tekrar eden basit maddeler yazılmaz. Her düşman türü, her silah ya da her savaş türü için kopya madde açılmaz. Türler tek bir veri tablosunun satırı olur. Ayrı madde, ancak kuralı gerçekten farklıysa açılır.

Madde boyutu içeriğe göre belirlenir. Uzun ve sıralı bir iş tek başlık altında numaralı alt adımlara bölünür. Küçük ama farklı işler, kapsamları karışmıyorsa tek başlık altında toplanabilir. Alt madde (`SVS-xx.a`) yalnız üst maddenin sıradaki adımıysa açılır. Aynı işi ikinci kez tarif etmez.

### Oyun sistemleri analizi

ROADMAP'i yazmadan önce şu sıra tabanlı oyunları incele: XCOM 2, Battle Brothers, Into the Breach, Darkest Dungeon, Mount & Blade, Banner Saga ve benzerleri. Derin bir tarih araştırması yapma. Her oyundan bu oyuna taşınacak tek bir mekanik karar çıkar.

Analiz `ROADMAP_3.md` dosyasının başında kısa bir bölüm olur: hangi sistemden ne alındı ve neden. Alınmayanlar da birer cümleyle yazılır. Bu bölüm madde değildir ve SVS kimliği almaz.

İncelemeden çıkan şu konuların her biri yol haritasında açık bir madde ya da alt adım olarak durur. Her biri tek yerde tarif edilir, başka maddede tekrarlanmaz:

- **Dengeleme:** sayısal tablolar, tavanlar, karşı güçler. Her güçlü seçeneğin bir karşı gücü vardır.
- **Güçlendirme ve zayıflatma:** buff ve debuff, durum etkileri, süreleri, yığılma kuralları. Aynı etki üst üste binmez, süre uzar ya da tablo ne diyorsa o olur.
- **Sınıf ve birim yetenekleri:** bekleme süresi, maliyet (eylem ya da yorgunluk), karşı oynanış. Her düşmana ayrı yetenek maddesi açılmaz. Yetenekler tek tablodadır.
- **Teçhizat:** 13. yüzyıl silah ve zırhlarının birbirinden farkı (menzil, hasar, zırh delme, ağırlık, iki eylem harcayan atış). Her silah ayrı madde değildir.
- **Moral ve yorgunluk:** ikisi birbirini nasıl etkiler. Yorgun birimin morali daha kolay bozulur. İki ayrı çubuk, tek etkileşim kuralı.
- **Baskın strateji yasağı:** tek doğru yol olmasın. "Hep yay", "hep kapıda bekle" gibi bir yol tabloyla cezalandırılır. Kaçınılacak yollar maddede adıyla yazılır.
- **Zorluk eğrisi:** ilk savaş küçük ve okunaklıdır. Sonraki savaşlar birim sayısıyla ve düşman bileşimiyle zorlaşır. 20 birim tavana kadar. Zorluk, YZ hilesiyle artmaz.

### Amaç

Kapı Muhafızı (Godot 4.7.2, 1243 Kösedağ sonrası Selçuklu ucu, ciddi ve gerçekçi) için ROADMAP_1 ve ROADMAP_2 kalitesinde, uçtan uca düşünülmüş, uygulanabilir bir savaş yol haritası yaz. Yol haritası sıra tabanlı savaşın bütün katmanlarını kapsar. Ön rapordaki 54 maddelik taslak başlangıçtır; onu kopyalayıp bırakmak yetmez. Eksikleri bul, maddeleri gerekirse alt maddelere böl, bağımlılık sırasını kur.

### İş akışı

1. Hydrogen High `ROADMAP_3.md` dosyasını yazar, commitler ve `claude/festive-volta-li1sfm` dalına pushlar. İmza `(Antigravity)`.
2. Codex, push edilmiş dosyanın üstünden geçer. Eksik, hatalı ya da tekrar eden kısımları ekler, düzeltir ya da siler ve nihai `ROADMAP_3.md` dosyasını oluşturur. Bu adım Hydrogen'ın işi değildir. Görevi `codex.md/Codex_gorev.md` içindeki "ROADMAP_3 son denetimi" bölümündedir. İmza `(Codex)`.

### Başlamadan

1. `git pull` et. Force push ve `reset --hard` yok.
2. Şu dosyaları oku ve biçimlerini çıkar: kökteki `ROADMAP.md`, `ROADMAP_2.md` (özellikle baştaki ajan panosu, bölüm başlıkları ve bir maddenin iç iskeleti: Ne, Kurallar, Uç durumlar, Kabul, Bağımlılık, Dosya, Asset), `AGENTS.md`, `docs/ROADMAP_3_SAVAS_ON_RAPOR.md`.
3. Asıl kaynak ön raporun §5 (motor), §5.9 (galibiyet ve mağlubiyet tablosu), §7A (kesinleşen kararlar) ve §8 (madde taslağı) bölümleridir. §7A gövdeyle çelişirse §7A geçerlidir.
4. `ROADMAP_3.md` yoksa oluştur. Varsa baştan yazma; eksik bölümü ekle. Bu görevde dosya henüz yoktur.

### Çıktı

Tek dosya: kökte `ROADMAP_3.md`.

Biçim, ROADMAP_2 ile aynı ailede olsun: başlık, kısa ajan panosu, sonra ana bölümler. Maddeler `- [ ] **SVS-xx:**` satırıyla başlar. Bir madde tek cümleyle kapanmaz.

Yapı üç seviyeye kadar iner:

- Ana bölüm (ör. motor çekirdeği, yapay zekâ, savaş türleri).
- Madde: `SVS-xx`.
- Gerekirse alt madde: `SVS-xx.a`, `SVS-xx.b`.
- Gerekirse alt-alt adım: aynı maddenin içinde numaralı adımlar. Yeni bir ID öneki açma.

Her maddede şu alanlar durur:

- **Amaç:** Bu madde bitince oyuncu ya da sistem ne kazanır.
- **Kapsam:** Ne dahildir, ne dışarıdadır.
- **Bağımlılıklar:** SVS kimlikleri ve ilgili ROADMAP_2 / ROADMAP_1 kimlikleri (CAT, ZAR, HAR, KRI, DNY, GRV, YER, SYS). Yoksa "yok" yaz.
- **Etkilenen dosya ve klasörler:** Yeni dosya yolu ve dokunulacak mevcut dosya. Korumalı çekirdeğe (`src/arayuz/ana.gd`, `koy_ekrani.gd`, `tema.gd`, `hud.gd`, `src/dunya/karakter_model.gd`, `koy_yonetim_sahnesi.gd`, `src/sistemler/oturum.gd`, `ses.gd`, `koy_nufusu.gd`, `guvenli_kayit.gd`, `data/metin/metinler.csv`, `tests/oto/otomatik_oyuncu.gd`) yalnız tek satırlık adaptör gerekçesiyle girilir. Gerek yoksa "çekirdeğe dokunulmaz" yaz.
- **Veri şeması:** JSON ya da kaynak alanı, anahtar adları ve birim. Sayı gömülmez; eşikler `data/savas/` altındadır. Şema gerekmiyorsa "veri yok" yaz.
- **Kabul ölçütleri:** Sayılabilir. "Çalışıyor" kabul değildir.
- **Testler:** Birim ya da senaryo testi, dosya yolu, sabit tohum. Headless koşulur. Oyuncuya açık otomatik çözüm için test yazılmaz.
- **Asset:** Yer tutucu yolu ve `docs/EKSIK_ASSET_ENVANTERI.md` satırı. Asset gerekmiyorsa "asset gerekmedi" yaz.
- **Metin anahtarları:** `svs.xx.*` biçiminde TR ve EN. Metin yoksa "metin yok" yaz. Eski `metinler.csv` satırları ve mevcut diyaloglar değiştirilmez.
- **Sahip:** `baştan` ya da `sondan` (K17). Antigravity baştan ileri gider. Berk tarafı sondan geri gelir. Her maddeye birini yaz. Orta bölge açma.

### Kapsanacak katmanlar

Ön rapordaki SVS-01 … SVS-54 durur. Bunları genişlet ve en az şu katmanların her biri için madde ya da alt madde olsun:

1. Veri: birim şablonu, HP, silah ve zırh, dost ve düşman şablonları, 13. yüzyıl teçhizatı.
2. Motor çekirdeği: savaş durumu, deterministik RNG, kare ızgara, kapı arenası, inisiyatif, turda 2 eylem, hareket ve görüş, savaş zarı, HP hasarı, düştü durumu, moral, yorgunluk, nöbet tutma, galibiyet ve mağlubiyet.
3. Yapay zekâ: fayda tabanlı çekirdek, davranış profilleri, niyet gösterimi. YZ hile yapmaz.
4. Savaş türleri: gece baskını, tekfur kuşatması, kapı ve sur hasarı, yangın, küçük Moğol grubu, büyük Moğol kolunun savaşsız karar düğümü, dış sefer, kervan koruma, müttefik takviyesi.
5. Kapı düellosu (K11): oyuncu ya muhafızın adamlarını gönderir ya da muhafızın kendisi kapıdaki karakterle düello yapar. İkisi de oynanır. Eski tek zar çözümü oyuncuya açık kalmaz. Bu iki yol, CAT-02 "askerle karşılık" seçeneğinin içindedir. Beşinci kapı seçeneği açılmaz.
6. Savaş öncesi ve sonrası: karar paneli, konuşlanma, tedavi, ölüm, hane ve yetim, köye etki, kan davası, söylenti, gece raporu.
7. Esir ve fidye (K14): yakalama, tutma, fidye, salıverme. Divan hükmü bu akışın parçasıdır.
8. Ganimet terazisi (K13): paylaşım adalet ve yozlaşma terazisine yazılır.
9. Galibiyet ve mağlubiyet sonuç tablosu (§5.9): ganimet, itibar, husumet, yara, kaynak kaybı, köye etki. Tablo `data/savas/sonuc_tablosu.json` olur.
10. Muhafız (K4): ölmez. HP 0 olursa savaş kaybedilmiş sayılır. Kalan dostlar çekilebilir, galibiyet yazılmaz, komuta kimseye devredilmez. Muhafız yara zarının ölüm satırına girmez, hayatta kalır, yerine kimse geçmez.
11. Arayüz, girdi, yerelleştirme: savaş ekranı, zar kadrajı, günlük, özet, klavye ve gamepad, TR/EN anahtarlar.
12. Kayıt (K12): savaş ortasında kayıt yok. Savaş başlamadan otomatik kayıt alınır.
13. Denge ve kapanış: senaryo koşucusu, `otomatik_oyuncu` 20 gece duman testi, perde ve son bağlantıları, kapanış testi.
14. Erişilebilirlik: sonuç renkle değil sözcükle yazılır. Punto GRV-13'ün altına inmez.
15. Performans: bir savaşta en fazla 20 birim (K15). 21. birim sahneye girmez. Kabul ölçütü bu tavanı sabit tohumla doğrular.
16. Okçuluk (K9): `okculuk_oyunu.gd` sur okçusu becerisine bağlanır.
17. Katılım ayarı (K6): kadınlar ve gençler. Varsayılan açık, oyun ortasında değiştirilebilir. Çocuklar her durumda savaş dışıdır.
18. Denge, durum etkileri, yetenek tablosu, teçhizat farkları, moral ve yorgunluk etkileşimi, baskın strateji yasağı, zorluk eğrisi. Bunlar yukarıdaki "Oyun sistemleri analizi" listesindeki tek maddelerdir. Aynı kural ikinci bir maddede yeniden yazılmaz.

### Kararlar (bunların dışına çıkma)

- Dönem 1243 Kösedağ sonrası Selçuklu ucudur. Yeni metinde akıncı, tımar, sipahi, yeniçeri ve levent ocağı yazılmaz. Yerine uç beyi, subaşı, alp, gazi, tekfur, harami kullanılır. Eski metinler ve diyaloglar olduğu gibi kalır (K18).
- Turda 2 eylem vardır. Aksiyon puanı yoktur (K2).
- Can sayısal HP'dir (K3).
- Küçük Moğol grupları savaşılır. Büyük akın savaş olarak oynanmaz (K5).
- Kıtlık ve açlık isyanı için madde açılmaz (K7). Gelecek notu olarak bir satır yeter.
- Otomatik çözüm yoktur (K10). SVS-19 yalnız test amaçlı YZ-YZ koşucusudur. Oyuncu menüsünde görünmez. Eski formüllerle "aynı sayıyı versin" diye yeni test isteme.
- ID öneki SVS-'dir. CAT-01..04 durur. CAT-05 ve sonrası açılmaz (K8).
- Nüfus eşiği altındaki savaş yasağı (BUG-18, OMR-42) korunur. Meclis savaş açamaz (MCL-09).

### ROADMAP_2 bağlantısı

Her savaş maddesi, ön raporun §6 tablosundaki ilgili ROADMAP_2 kimliğini bağımlılık alanına yazar: CAT-01..04, ZAR-01..06, HAR-02, HAR-03, HAR-04, HAR-05, HAR-07, HAR-10, HAR-14, HAR-15, KRI-03, KRI-05, KRI-13, DNY-01, KAP-18, YAP-56, SYS-19, SYS-20 ve diğerleri.

Berk tarafının ROADMAP_2 maddelerine dokunma. `[ ]`, `[/]` ve `[x]` satırlarını değiştirme. ROADMAP_2.md'ye savaş maddesi ekleme. Çakışan bir kural görürsen (örneğin "yeni savaş yok" diyen nöbet ve usta defteri maddeleri) ROADMAP_3 içinde "ROADMAP_2 sınırı" diye yaz, o maddenin kabul testini bozacak iş önerme.

### Kurallar

- `AGENTS.md` geçerlidir. Genişletme yapılır, yeniden yazma yapılmaz. Eski `koy_sahnesi` geri gelmez.
- Asset: 2B arayüz üretimi serbesttir. 3B yalnız Meshy ya da doğrulanmış açık lisans (CC0, CC-BY) ile gelir. Ses sessiz yer tutucudur. Her ihtiyaç `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır. 3B savaş animasyonları 3B başlığındadır (K16). Bu görev asset üretmez. Yalnızca yol haritasında ihtiyacı tarif eder.
- Zar: `SorguZari` dili kullanılır. d6 ve d12, `zar >= gerekli`, tavan her zaman başarı, 1 her zaman başarısız. İsabet olasılığı mevcut `basari_olasiligi` yolundan gelir. İkinci bir hesap yolu yazılmaz.
- Sayılar koda gömülmez. Eşikler veridedir.
- Bu görev kod, sahne, test ve asset yazmaz. Yalnız `ROADMAP_3.md` ve kendi günlüğünü yazar.
- Commit başlığı Türkçe olur ve `(Antigravity)` imzası taşır. İş bölünebilir. Her tutarlı parçada commit at ve `claude/festive-volta-li1sfm` dalına push et. Force push ve `reset --hard` yok. Yazmadan önce pull et.
- Gizli anahtar, parola ve token yazma.

### Belirsizlik

Karar listesinde olmayan bir sayıyı, eşiği ya da hikâye sonucunu uydurma. Aynı `ROADMAP_3.md` dosyasının sonuna `## Antigravity sorusu` başlığıyla yaz. Her soru tek cümle olsun, hangi maddeyi kilitlediğini söylesin ve senin tahminini karar diye yazma. Kilitlenen maddeyi `[ ]` bırak, sahibini yaz, kabul ölçütünü "soru kapanınca" diye işaretle.

### Tekrar denetimi

Yazmayı bitirince, commit atmadan önce bütün maddeleri kapsam bakımından birbiriyle karşılaştır. Örtüşen iki maddeyi birleştir ya da kapsamlarını ayır. Kopya düşman, kopya silah ve kopya savaş türü maddesi kalmasın. Sonuç `codex.md/Antigravity.md` günlüğüne yazılır: kaç madde birleştirildi, kaç madde ayrıldı, kalan madde sayısı. Denetim yapılmadan push edilmez.

### Bitiş

İş bitince `codex.md/Antigravity.md` sonuna şunları yaz: `ROADMAP_3.md` yolu, madde sayısı (SVS-xx ve alt maddeler ayrı sayılır), bölüm listesi, tekrar denetiminin sonucu, açık `Antigravity sorusu` varsa sayısı ve konusu, commit hash'leri. Kota görünmüyorsa `kota görünmüyor` yaz. `TAMAMLANDI` satırını ancak `ROADMAP_3.md` push edildikten sonra ekle. Denetim Codex'e aittir. Hydrogen Codex'in işine başlamaz.
