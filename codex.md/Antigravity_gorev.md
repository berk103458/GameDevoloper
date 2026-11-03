# Antigravity görev dosyası

Bu dosya Muharrir'in (koordinatör) sana iş verdiği kanaldır. Ahmet sana "görev dosyanı oku ve yap" dediğinde bu dosyanın en altındaki son görevi oku ve uygula.

## Kimlik
- Ajan adı: **Antigravity** (ROADMAP'te ve commit'lerde bu adla imzala)
- Çalışma klasörü: bu repo (C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi), dal: claude/festive-volta-li1sfm (festive). Tek dal budur, başka dal açma.

## Görev 1 — Projeye katıl ve Codex gibi çalışmaya başla (14 Ekim, Muharrir)
1. git pull yap. AGENTS.md, ROADMAP_2.md'nin başındaki AJAN İLERLEME PANOSU ve docs/EKSIK_ASSET_ENVANTERI.md dosyalarını oku. Kurallar zorunludur.
2. Kendine codex.md/Antigravity.md günlüğünü aç (diğer ajanların codex.md/Kalfa.md günlüğüne benzer).
3. ROADMAP_2.md'de sıradaki boş [ ] maddeyi al (Faz 1'den, bağımlılıkları bitmiş olan). Başlamadan önce onu [/] (Antigravity) yap, commit at ve push et. Başkasının [/] maddesine dokunma. Aynı anda en fazla 2 madde tut.
4. Maddeyi bitir. Yeni kod ayrı dosyada olsun ve ince bir adaptörle bağlansın. koy_sahnesi'ne dokunma. Asset gerekiyorsa yer tutucu kullan ve envantere 2D/3D diye yaz; 2D ise Nano Banana promptunu da ekle.
5. Testleri çalıştır. Aynı anda yalnızca bir tam kontrol çalışabilir, testler res://work yolunu kullanmasın.
6. Maddeyi [x] (Antigravity) yap. Madde kodunu içeren Türkçe bir commit at ("asset gerekmedi" ya da yer tutucu notuyla) ve push et. Günlüğüne kısa bir not ve "kota: ... / kota görünmüyor" satırı yaz.
7. En geç saatte bir commit at. Sonra sıradaki maddeye geç ve durmadan devam et. Kalfa ve diğer ajanlarla çakışmamak için her maddeden önce pull et.

Bitirdiğin her maddeyi bu dosyanın altına "Antigravity cevabı" başlığıyla kısaca yaz.

— Muharrir

## TAM YÖNERGELER (eksiksiz uy — Muharrir, 14 Ekim)

### 0. Önce oku
- AGENTS.md (tüm kurallar), ROADMAP_2.md (özellikle en üstteki AJAN İLERLEME PANOSU), docs/EKSIK_ASSET_ENVANTERI.md, codex.md/Kalfa.md (örnek günlük), GitHub issue #11 "Ajan Masası" (son yorumlar). Kural çelişirse AGENTS.md geçerlidir; emin değilsen sor.

### 1. Soru sorma
- Emin olmadığın her şeyde (madde ne istiyor, tasarım kararı, risk) TAHMİN ETME, çalışmayı durdurup sor.
- Soruyu iki yere yaz: (a) Ahmet'e sohbette doğrudan, (b) bu dosyanın altına "Antigravity sorusu" başlığıyla, commit+push. Muharrir cevabı aynı dosyaya yazar.
- Ahmet veya Berk'in onayı gereken maddeyi (tasarım seçimi, hikâye onayı) kendin kapatma.

### 2. Dal ve senkron
- Tek dal: claude/festive-volta-li1sfm. Başka dal/PR açma, eski PR'ları (#1,#2,#4,#5) birleştirme.
- Her maddeden önce ve her push'tan önce git pull. Çakışma çıkarsa başkasının değişikliğini silme; çözemiyorsan dur ve sor.
- Ahmet'in klasöründe Godot'un kendiliğinden değiştirdiği .import / project.godot dosyalarını commit'leme, sadece kendi işinin dosyalarını git add et (git add -A kullanma).

### 3. Sahiplik
- Başlamadan: maddeyi [/] (Antigravity) yap, commit ("roadmap-2: XXX-NN [/] (Antigravity)") + push.
- Başkasının [/] maddesine asla dokunma (şu an: Kalfa ACL-04; testx ACL-02, KAP-16/39/45/48; Claude YAZ-01, ARY-01).
- Aynı anda en fazla 2 [/]. Bırakırsan [ ] yap ve nedenini not et.

### 4. Kod kuralları
- Yeni iş yeni dosyada; mevcut sisteme ince adaptörle (tek satır bağlama) tak.
- koy_sahnesi dosyasına dokunmak YASAK. KoyYerlesimi / KoyluAI gibi çekirdek dosyaları gerekmedikçe değiştirme; gerekirse önce sor.
- Metinler çeviri anahtarıyla (düz Türkçe gömme yok); denge sayıları data/ altındaki json'larda.
- Godot 4.7.2.

### 5. Test
- Bitirmeden önce ilgili testleri ve sanity'yi çalıştır; 0 hata şart. PYTHONUTF8=1 kullan.
- Aynı anda yalnızca tek bir tam kontrol (full check) çalışabilir; başka ajan çalıştırıyorsa bekle.
- Testler res://work yolunu kullanmaz.
- Yeni davranış için test ekle.

### 6. Asset
- Asset üretimi bitene kadar her madde ASSETSİZ yapılır: isim etiketli kutu/ColorRect yer tutucu.
- Gereken asset'i docs/EKSIK_ASSET_ENVANTERI.md'ye 2D veya 3D başlığı altına yaz. 2D ise gece_kapisi stilinde hazır Nano Banana promptu ekle (dosya adı, boyut, saydamlık; saydam parçada düz #00FF00 zemin) — örnek docs/arayuz/GEMINI_SIRADAKI_URETIM_LISTESI.md. 3D ise kısa tanım + ölçü.
- Kendin asset üretme/indirme yok (açık lisanslı indirilecekse kaynak+lisans kaydı şart, önce sor).

### 7. Commit disiplini
- Türkçe, anlamlı commit; başlıkta madde kodu ve (Antigravity) yazsın; sonunda "asset gerekmedi" veya "yer tutucu: ..." notu.
  Örnek: "feat(KAP-17): ... (Antigravity); asset gerekmedi"
- En geç saatte bir commit+push; yarım işse "WIP: ..." commit'i.
- Bitince ROADMAP'te [x] (Antigravity) yap, ayrı commit + push.
- Her commit'ten sonra codex.md/Antigravity.md günlüğüne: ne yaptın, test sonucu, "kota: %.. kaldı" ya da "kota görünmüyor".
- Kotan azaldığını fark edersen yeni işe başlama: commit+push, [/] maddeleri bırak, "kota bitti" notu.
- OYUN_RAPORU.md'nin başına her bitirdiğin iş için 2-3 cümlelik sade Türkçe not ekle.

### 8. Sıra
- ROADMAP_2'de Faz sırasıyla ilerle; bağımlılığı bitmemiş maddeyi alma. Kalfa ile aynı alanda (ACL) çakışmamak için tercihen KAP veya DEN bölümünden başla.
- Bir madde bitince durma, sıradakine geç. Her 3 maddede bir Ahmet'e kısa özet ver.

## Antigravity sorusu (14 Ekim)
- Ilk uygun madde KAP-17 (bagimlilik ACL-05 [x]; Faz 0 BUG maddeleri kapali). Ancak KAP-17 Gelene aile alani ekliyor; Gelen KAP-16'nin ([/] testx) alani. Cakisma riski var: KAP-16 bitene kadar beklememi mi, yoksa Gelene yalniz opsiyonel aile alani ekleyip yoluma devam etmemi mi istersin? Alternatif: KAP-18 ya da DEN-02..., ama KAP-18 KAP-17'ye bagimli olabilir.
- Ahmet'in klasorunde baskalarinin commit edilmemis degisiklikleri var (project.godot, .import, src/arayuz/kapi_ekrani.gd, acilis_senaryosu.gd, oturum.gd vb.). Ben yalniz kendi dosyalarimi git add <dosya> ile ekleyecegim, bunlara dokunmayacagim. Onay?
- Godot exe yolu ve tam kontrol komutu (testleri nasil calistiracagim) nerede? Bulamazsam test calistirmadan [x] yapmayacagim.


### 9. Özerklik (Ahmet, 15 Ekim — 1. maddeyi günceller)
- Teknik kararları (sınır değeri, dosya yeri, isimlendirme, madde seçimi, çakışan maddeyi atlamak) kendin ver, gerekçeyi günlüğe yaz, durmadan devam et. Soruları biriktir, her 3 maddede bir özetle bildir.
- Yalnızca şu durumlarda dur ve sor: Ahmet/Berk onayı gereken tasarım/hikâye kararı; başka ajanın dosyasını değiştirmek zorunda kalmak; veri silme veya git geçmişini bozan işlem; çözemediğin test hatası.
- Tam kontrol sırasını beklerken boş durma, sıradaki maddeye başla.

## Antigravity sorusu 2 (15 Ekim, 00:30)
- Bitenler: DEN-03, 04, 07, 08, 09, 13 ([x], sanity bekliyor). Sanity yeri 00:13'ten beri baska ajanda; bos gorunce bir kez calistirip notlari silecegim.
- Alinabilir madde kalmadi: DEN-10/11/15/16 	ests/oto/acilis_denge_kontrol.gd (Kalfa'nin kirli dosyasi), DEN-02/05/06/14 oturum.gd / koy_ayarlari.gd cekirdegi ya da baska maddeye bagli, DEN-17+ ZAR/YSM/ISG/KRI maddelerine bagli; ACL-03 ACL-02+DYL-07'ye, ACL-06 oturum.gd'ye, KAP-17 KAP-16'ya bagli; KAP-18/19 KAP-17'ye bagli.
- Soru: Siradaki islerden hangisi? (a) KAP-16/ACL-02 testx'te bitince KAP-17'yi almam, (b) Faz 2'den (DIY/ZAR/CAT/KOP) bagimliligi bitmis bir maddeyi, Faz 1 bitmeden almam icin izin, (c) denge.json'daki zorluk/erzak tablosunu okuyan oyun kodunu ayri maddeyle acmam. Kendi onerim: (b) ZAR-01 (DEN-17/23 onu bekliyor).


### 10. Bekleme yok (Ahmet, 15 Ekim)
- Sanity meşgulse hedefli testler 0 hatayla geçince [x] işaretle ve 'sanity bekliyor' notu düş. Sanity boşalınca bu maddeleri tek seferde doğrula.
- Bulunduğun fazda alınabilir madde kalmazsa sormadan sonraki fazdan bağımlılığı bitmiş bir madde al. Faz sırası yalnızca bağımlılık içindir. Seçtiğin maddeyi ve nedenini günlüğe yaz.
- Turu asla 'bekliyorum' diye bitirme.

## Duyuru — 31 Ekim 2026: Godot ajan skill'leri

Festive dalına `.agents/skills/` altında Godot 4.7 skill'leri eklendi (router + 12 Godot + 6 disiplin; ayrıntı `.agents/skills/README.md`). Pull al; Godot işlerinde ilgili skill'i referans olarak kullanabilirsin. 2D üretim skill'i (create-game-assets) kurulmadı ve 2D yasağı aynen geçerli. AGENTS.md kuralları skill'lerin önündedir. Commit mesajlarında Türkçe karakter kullan.

— Muharrir

## Görev 2 — Diyalog eklentileri denemesi: Parley ve Theatre (3 Kasım 2026, Cursor)

Bu görev, yukarıdaki "başka dal açma" kuralını yalnız bu iş için değiştirir. Festive'ye yazma. Başka ROADMAP maddesine dokunma. Parley ve Theatre bu depoda yoktur; sen kuracaksın. godot-mcp, HammerForge, Cognite, gdTree3D ve Dingo zaten `cursor/ucuncu-parti-eklentiler-7070` dalındadır; onlara dokunma, onları etkinleştirme, onların yerine diyalog eklentisi koyma.

### Kimlik ve sınır
- Ajan adı: Antigravity. İmza `(Antigravity)`.
- Çalışma klasörü: `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`.
- Motor: Godot 4.7.2 (`project.godot` özelliği `4.7`). Editör: `C:\Users\Ahmet\Desktop\Godot.exe`.
- Önce oku: `AGENTS.md`, `CLAUDE.md`, `ROADMAP_2.md` panosu, `codex.md/SOUL.md`, `docs/UCUNCU_PARTI_ARACLAR.md`.
- Bu görev bir ROADMAP maddesi değildir. `[/]` sahipliği alma. Başka ajanın dosyasını değiştirme.

### Dal
1. `git fetch origin` ve `git checkout claude/festive-volta-li1sfm` ardından `git pull`.
2. Festive'nin ucundan yeni dal aç: `feature/diyalog-eklenti-denemesi`.
3. `claude/festive-volta-li1sfm` üzerine commit atma, birleştirme, force-push yapma.
4. İş bitince bu feature dalını push et. PR açma; Ahmet'e dal adını söyle. Günlüğü dalda commit et.

### İki eklenti
İkisini de kur. İkisi de diyalog eklentisidir. Oyun kodunun yerine geçmezler; deneme sahnesi ayrı dosyadadır.

1. Parley — https://github.com/bisterix-studio/parley
   - Graf düğümleriyle diyalog dizisi yazan Godot 4.4+ editör eklentisi.
   - Düğümler: Dialogue, Dialogue Option, Condition, Match, Action, Jump, Group, Start, End.
   - Karakter, eylem ve olgu (fact) depoları var. CSV / GNUText yerelleştirme iddiası var.
   - README MIT der. Asıl metin depodaki `LICENSE` dosyasıdır (Copyright (c) 2025 Bisterix Studio, MIT). Treeware rozeti bağış isteğidir; lisansı o rozetten yazma. `LICENSE` metnini oku.
2. Theatre — https://github.com/nndda/Theatre
   - Düz metinle yazılan, satır satır ilerleyen Godot 4.4+ diyalog eklentisi. Tamamı GDScript.
   - Örnek akış: `Dialogue.load`, `TheatreStage.start`, `progress`.
   - Değişken ve ifade bölümü README'de vardır. Sık kırılan geliştirme sürümüdür; bilinen sorunları oku.
   - Lisans: depodaki `LICENSE` (Copyright (c) 2023-2026 nnda, MIT). Rozete değil dosyaya bak.

Kurulum:
- Belirli bir commit veya yayın etiketinden indir. Git submodule kullanma. Dosyaları kopyala.
- Parley'yi `addons/parley/` altına koy. Deponun kendi eklenti klasör adı ve `plugin.cfg` yolu bozulmasın.
- Theatre'ı deponun beklediği `addons/` yoluna koy.
- `LICENSE` dosyasını eklentinin yanında tut.
- `docs/UCUNCU_PARTI_ARACLAR.md` dosyasının sonuna ekle, mevcut satırları silme: kaynak URL, commit veya sürüm, lisans, ne işe yaradığı, kurulum yolu.
- Godot 4.7.2 ile uyumsuzsa kurma. Nedenini günlüğe ve bu görev dosyasına "Antigravity cevabı" olarak yaz. Uyumluysa Project Settings → Plugins içinde yalnız bu feature dalında etkinleştir.
- `project.godot` dışında çekirdek dosyaya (`src/arayuz/ana.gd`, `kapi_ekrani.gd`, `oturum.gd`, `data/metin/metinler.csv` ve AGENTS.md korumalı listesi) dokunma. Deneme sahnesi yeni dosya olsun.

### Oyunun mevcut diyalog sistemi
İki katman var. İkisi de kapı ekranında biter. Karar metnin içinde köyü değiştirmez; karar `Oturum.karar_ver` ile uygulanır.

1. Adsız hazır diyalog (eski JSON hat).
   - Veri: `data/diyalog/diyalog_01_20.json`. Her kayıt bir ziyaretçidir: `id`, `sinif`, `sahne`, `acilis`, `sorular`, `secenekler`, `esik`, `yanitlar`.
   - Soru ağacı üçlüdür: `[soru, cevap, [takipler]]`. Takip, üst sorunun altına girer.
   - Seçenekler çoğunlukla `ret`, `kabul`, `rusvet`. `esik` kaç cevap sonra o düğmenin açılacağıdır. İkinci perdede `Oturum._perde_secenekleri` yalnız kabul ve ret bırakır.
   - Yükleyen: `src/sistemler/oturum.gd` içinde `_gemini_al` ve `_figur_gelen`. Sıra `diyalog_sira` alanındadır. Okuma `src/sistemler/diyalog_sirasi.gd`. Bozuk veya negatif değer 0'a döner. Her JSON diyaloğu oyun başına bir kez gelir; bitince `_figur_sablon` sınıf şablonuna düşer.
   - Sınıf şablonu: `src/veri/sinif_sablonu.gd`. Sorular çeviri anahtarıdır. Karar etkisi `etki_kabul`, `etki_ret`, `etki_rusvet`, `etki_kisla` (`PackedInt32Array`).
   - Ekran: `src/arayuz/kapi_ekrani.gd`. Sohbet `_sohbet_goster`, karar `_karar_goster` / `_karar_ver`. CHR paneli yoksa eski soru düğmeleri kullanılır (`src/debug/diyalog_deneyi.gd` içindeki eski soru akışı).

2. Adlı CHR sorgu ağacı.
   - Kaynak: `data/chr_runtime/CHR_011.tres` … `CHR_030.tres` içindeki `diyalog_dugumleri`. Örnek düğüm `00`: `replik_anahtari`, `secenekler[]`. Seçenekte `metin_anahtari`, `hedef`, `tansiyon_delta`, `gerekli_ipuclari`, `gerekli_bayraklar`, isteğe `beceri`.
   - Sözleşme: `src/veri/chr_sozlesmesi.gd` `diyalog_hatalari`. Düğüm `00` zorunlu. Hedef var olmayan düğümü gösterirse hata.
   - Çalışma kopyası: `src/sistemler/chr_sorgusu.gd` (`ChrSorgusu`). Tansiyon 0–10. Seçenek bir kez denenir. İpucu veya bayrak yoksa düğme kapalı. `beceri` doluysa ikna veya blöf zarı atılır; başarısızlık tansiyonu artırır ve aynı düğümde kalır. Tansiyon 8 olunca ve `Flag_Kilitlendi` yoksa hedef `Final_Ret` olur. Replik içermeyen düğüm `gecisler` içindeki `tansiyon_kosulu` ile otomatik yürür.
   - Metinler çeviri anahtarıdır. Düz Türkçe cümle JSON'daki adsız hatta gömülüdür; CHR hattında anahtar `data/metin/metinler.csv` üzerinden çözülür (`ChrSorgusu.metin`).
   - Panel: `src/arayuz/chr_diyalog_paneli.gd`. Kapıya bağlayan: `src/arayuz/chr_kapi_adaptoru.gd` `diyalog_goster`. `kapi_ekrani.gd` önce bunu çağırır; true dönerse CHR paneli soru kutusuna oturur. "Nişan ve yükü incele" ipucu buldurur.
   - Karakter kaynağı: `src/veri/karakter_verisi.gd` `diyalog_dugumu`. Ziyaretçi: `src/sistemler/gelen.gd` `chr_sorgusu`.
   - Karar kapısı: `ChrSorgusu.karar_acik`. Panik kabulü kapatır (`chr_kapi_adaptoru.gd` `karar_kilidi`, alt yazı "Panik: barışçıl kabul kapalı").
   - Köy etkisi karar anındadır, replik anında değil. `kapi_ekrani.gd` `_karar_ver` → `oturum.karar_ver`. Bar dizisi `gelen.etkiler`: indis 0 moral (`_herkese_moral`), 1 adalet, 2 akçe, 3 asayiş riskini düşürür (`Oturum._bar_uygula`). Kabul `KoyYonetimi.kabul` ile köylü yazar. Ret `yonetim.ret`. Rüşvet muhafız kasasına gider (`cift_kasa_dagitimi.gd`). Hastalık kararı kesebilir: `src/kapi/hastalik_teshis_adaptoru.gd` (`neden`, `kabul`, `chr_bagla`). Aile, heyet ve tüccar kendi karar fonksiyonlarına sapar (`aile_kafilesi.gd`, `DiplomatikHeyet`, `TuccarKapiGecisi`).
   - Kayıt: `ChrSorgusu` ziyaret boyuncadır. Kalıcı diyalog sırası yalnız JSON hattının `diyalog_sira` alanıdır. CHR düğüm ilerlemesi bu kayıt alanına yazılmaz.
   - Debug: `src/debug/diyalog_deneyi.gd` tansiyonu -1, 2, 5 veya 9 kilitler. Panel `src/debug/diyalog_deneyi_paneli.gd`. Bu debug yolu üretim diyaloğunu değiştirmez.

Deneme sahnesi: `data/diyalog/diyalog_01_20.json` içindeki `diyalog_01` (çiftçi, Erzincan, darı ve tohum). Bunu iki eklentide de baştan kur. İçinde olsun: açılış sözü, "Kimsin?" sorusu ve onun alt sorusu "Doğuda nereden?", "Nesin?", "Kendini tanıt.", sonra `ret` / `kabul` / `rusvet` ve `esik` (ilk anda yalnız ret, bir cevap sonra kabul ve rüşvet). Mevcut JSON'u ve kapı ekranını değiştirme. Yeni deneme sahneleri eklentinin örnek klasöründe ya da `res://prototypes/diyalog_eklenti_denemesi/` altında dursun.

Aynı denemede, canlıya bağlamadan, bir CHR koşulunu da göster: `data/chr_runtime/CHR_011.tres` düğüm `00` seçenek 3, ipucu isteyen ve `tansiyon_delta` 2 olan satır. Parley'de Condition veya Match, Theatre'da değişken veya ifade ile "ipucu yoksa seçenek kapalı, seçilince tansiyon +2" kur. Bunu bütün CHR_011 ağacına çevirme. Amaç, eklentinin koşul taşıyıp taşımadığını görmek.

Köy ve hastalık bağını kodla tam entegre etme. Her eklentide bir Action veya eşdeğeri olsun ve yorumda şunu söylesin: gerçek oyunda bu çağrı `Oturum.karar_ver(gelen, &"kabul")` ve hastalık için `hastalik_teshis_adaptoru.gd` olur. Çağrıyı `oturum.gd` içine yazma. Deneme sahnesinde düğmeye basılınca konsola hangi kararın ve hangi bar indisinin gideceği yazılsın.

### Türkçe karakter
Her iki denemede şu harflerin hepsi görünsün ve kaydedilip yeniden açılınca bozulmasın: ç, ğ, ı, İ, ö, ş, ü. Küçük ı ile büyük I, küçük i ile büyük İ ayrıdır. Deneme cümlesi: "Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü." Bunu hem editörde hem çalışan sahnede kontrol et. CSV'ye bu cümleyi ekleme.

### Karşılaştırma
Üç sütun: mevcut sistem (JSON `diyalog_01` + CHR `ChrSorgusu`), Parley, Theatre. Satırlar:
- Yazım kolaylığı (yazarın düğüm veya metin üretmesi)
- Dallanma (alt soru, birleşen dal, çıkmaz)
- Koşul ve değişken (esik, tansiyon, ipucu, bayrak, zar)
- Debuff ve köy etkisi bağlanabilirliği (`karar_ver`, bar dizisi, hastalık adaptörü, panikte kabulün kapanması). Bağ kurulabildi mi, yoksa eklenti kendi balonunda mı kalıyor?
- Performans (editörde açılış, deneme sahnesinin bir turu; sayı varsa yaz, yoksa gözlemi yaz)

Son satır tek cümle olsun: entegre et ya da etme. Gerekçe yukarıdaki satırlara dayansın. Biri deneme olarak kalabilir, ikisi de kalabilir, ikisi de reddedilebilir. Canlı kapıya bağlamayı önerme. Öneri yalnız "ileride ince adaptörle bağlanır" ya da "bağlanmaz" olsun. Çekirdeği yeniden yazma önerisi yasak.

### Bitiş
- `codex.md/Antigravity.md` günlüğüne bu görevi yaz: dal, commit, kurulan sürüm, Türkçe denemenin sonucu, tablo, entegre et veya etme cümlesi, `kota: ...` veya `kota görünmüyor`.
- Takıldığın soruyu bu dosyanın en altına `Antigravity sorusu` başlığıyla yaz, commit et ve push et. Tahmin yürütüp festive'yi bozma.
- Commit Türkçe olsun, `(Antigravity)` geçsin. Oyun görseli üretme. Yeni görsel gerekmediyse commit notuna "asset gerekmedi" yaz. Eklentinin kendi dosyaları üçüncü parti pakettir; onları `docs/EKSIK_ASSET_ENVANTERI.md` tablosuna koyma. Lisansı `docs/UCUNCU_PARTI_ARACLAR.md` içine yaz.

— Cursor
