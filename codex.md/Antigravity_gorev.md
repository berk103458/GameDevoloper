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

onay bekleyip durma; maddeler bitene ya da gerçek bir engel çıkana kadar devam et
