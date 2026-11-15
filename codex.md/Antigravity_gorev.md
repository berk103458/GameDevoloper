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


## Antigravity cevabı (3 Kasım 2026 — Görev 2: Diyalog eklentileri denemesi)
- **Açılan Dal:** `feature/diyalog-eklenti-denemesi` (`claude/festive-volta-li1sfm` dalından açıldı, festive'ye doğrudan commit atılmadı).
- **Kurulan Eklentiler:**
  1. `addons/parley/` (Parley v2.1.0, commit `ef75bc30a5307ce118645d3463091d6c9adf1718`, MIT Lisansı).
  2. `addons/Theatre/` (Theatre v0.12.2, commit `11c19e1b02eae7ed7eb7c83b9da9c70532b8107d`, MIT Lisansı).
  - İki eklenti de `project.godot` eklenti listesinde yalnız bu feature dalında etkinleştirildi.
  - `docs/UCUNCU_PARTI_ARACLAR.md` güncellendi (mevcut içerik korundu, Parley ve Theatre eklendi).
- **Godot 4.7.2 Uyumu:**
  - Parley: Uyumlu, SCRIPT ERROR yok, 179 global sınıfı ve içe aktarma araçları sorunsuz çalışıyor.
  - Theatre: Uyumlu; ancak geliştirme sürümü olduğu için `DialogueLabel` içinde tool/headless timer başlatma ve stage bağlama eksiklikleri tespit edildi.
- **Diyalog 01 ve CHR_011 Prototipi:**
  - `prototypes/diyalog_eklenti_denemesi/` altında hem Parley hem Theatre denemesi ve `deneme_kontrol.gd` birleşik test koşucusu hazırlandı.
  - Açılış sözü, "Kimsin?" -> "Doğuda nereden?" alt sorusu, "Nesin?", "Kendini tanıt", eşik takibi (`esik: [0, 1, 1]`) ve CHR_011 ipucu koşulu (+2 tansiyon artışı) her iki sistemde de başarıyla çalıştırıldı.
  - Köy ve hastalık etkisi simüle edildi (`# Gerçek oyunda bu çağrı Oturum.karar_ver(gelen, &"kabul") ve hastalık için hastalik_teshis_adaptoru.gd olur.`), bar indisleri (0=moral, 1=adalet, 2=akçe, 3=asayiş riski) konsola yazdırıldı.
- **Türkçe Karakter Doğrulaması:**
  - `"Işık, İzmir'den gelen ışığı çağırdı; göğsü ağrıyan kişi kapıda üşüdü."` cümlesi ve tüm ç, ğ, ı, İ, ö, ş, ü harfleri iki sistemde de hem dosya yüklemesinde hem çalışan sahnede 0 bozulmayla doğrulandı.
- **Karar ve Öneri:**
  - Parley ve Theatre'ı ana oyuna entegre etme; mevcut iki katmanlı JSON + CHR mimarisi korunmalı, ileride çoklu satırlı yan anlatılar gerekirse Theatre yalnız ince bir adaptörle değerlendirilebilir.

---

# Görev 3 — Tüm diyalogların sahipliği: insanlaştırma, seçenek planı ve köy sohbetleri

Veren: Ahmet (Kaşif aracılığıyla), 3 Kasım 2026
Ajan: Antigravity
Dal: `feature/diyalog-yeniden-yazim` (Kaşif açtı; `feature/diyalog-eklenti-denemesi` üstüne kurulu, Parley içinde). Festive'e (`claude/festive-volta-li1sfm`) doğrudan push YOK.
İlerleme dosyası: `codex.md/Antigravity_ilerleme.md` (aşağıda tarif edildi). Limit yüzünden yarıda kalırsan bir sonraki çalıştırmada önce bu dosyayı oku ve kaldığın yerden devam et.

## 0. Sahiplik kararı

Ahmet'in kararı: Kapı Muhafızı'ndaki **bütün diyaloglar artık senin sorumluluğunda**. Kapıya gelen ziyaretçiler, köylüler, olay sahneleri, köy içi sohbetler — hepsi. Daha önce diyalog yazan ajanların (Muharrir, Kalfa, Claude) bıraktığı metinleri devralıyorsun; onları çöpe atma, iyileştir.

Başlamadan önce `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `ROADMAP` dosyaları, `Roadmap-2/DIYALOG_URETIM_ARASTIRMASI.md`, `codex.md/Muharrir.md` ve `.agents/skills/dialogue-systems/` oku. Proje kuralları her zaman bu görevden ve yeteneklerden önce gelir (commit disiplini, ROADMAP işaretleme, asset kuralları, Türkçe karakter kuralları).

## 1. Ahmet'in istekleri (aynen)

1. **Diyalogları geliştir ve insanlaştır**: tüm karakterler için. Robot gibi, bilgi veren kalıp cümleler değil; her karakterin kendi sesi, ağzı, derdi, yalanı, korkusu olsun. Dönemine ve yöresine uygun ama okunabilir Türkçe.
2. **Ekstra seçenekler, seçimler ve sonuçları planla. Büyük düşün.** Oyuncunun kapıdaki ve köydeki seçimleri gerçekten bir şey değiştirsin: köy barları (moral, adalet, akçe, asayiş), tansiyon, ipucular, bayraklar, sonraki gelen kişi, karakterlerin sonraki diyalogları.
3. **Karakterler seçimlere göre düzgün cevap versin.** Oyuncu kabaysa kırılsın, rüşvet reddedilirse buna uygun tepki versin, daha önce kapıdan geri çevrilen biri köyde/sonraki gün bunu hatırlasın.
4. **Gereksiz seçenekleri ve diyalogları kaldır.** Aynı şeyi soran, hiçbir sonuca bağlanmayan, oyuncuya yeni bilgi vermeyen dalları sil veya birleştir. Ne kaldırdığını gerekçesiyle kaydet.
5. **Köy içi karakter sohbet sekansları**: köylüler kendi aralarında konuşsun (oyuncu yanından geçerken veya belirli olaylardan sonra tetiklenen kısa sahneler). İçerikleri oyunun durumuna bağlı olsun: son kabul edilen/reddedilen kişiler, hastalık, kıtlık, barların durumu.
6. **Tıklayınca muhabbet**: köy sekansında bir köylüye tıklayınca onunla konuşabilmeliyim. Her köylünün durumuna göre değişen, birkaç seçenekli kısa bir muhabbet ağacı olsun.

## 2. Teknik yön

- **Kapı diyalogları** mevcut sistemde kalır (diyalog JSON + `CHR_*.tres`, tansiyon/zar/eşik mekaniği). Görev 2'deki kendi kararın buydu; bozma.
- **Köy içi sohbetler ve tıklayınca muhabbet için Parley kullan** (addons/parley, v2.1.0). Görev 2 kararındaki "bağımsız NPC sahneleri" tam olarak bu. Oyuna bağlantıyı `ParleyFactInterface` / `ParleyActionInterface` ile küçük adaptörler üzerinden kur; çekirdeğe (Oturum, KoyYonetimi) doğrudan Parley bağımlılığı sokma.
- Parley `.ds` dosyalarında düğüm koordinatlarını ızgara kuralıyla yaz (ana hat x += 350, seçenekler y += 180), ağaçları sahne başına böl (100+ düğümlü tek dosya yok).
- Köylüye tıklama: köy sahnesindeki köylü düğümlerine tıklama alanı + Parley diyaloğunu açan küçük bir bileşen ekle. Kamera/girdi akışını bozma; diyalog açıkken köy simülasyonu durumunu proje kuralına göre yönet.
- Yeni görsel asset üretme. Gerekirse yer tutucu kullan ve `docs/EKSIK_ASSET_ENVANTERI.md` kuralına uy.

## 3. Çalışma sırası

### Aşama A — Envanter ve plan (önce bu, kod yazmadan)
`docs/DIYALOG_ANA_PLANI.md` yaz:
- Oyundaki bütün karakterlerin listesi (kapı ziyaretçileri CHR_xxx, köylüler, olay karakterleri), her biri için: kim, sesi/konuşma tarzı, derdi, gizlediği şey, mevcut diyaloğun sorunları.
- Seçim–sonuç haritası: hangi seçim hangi barı/bayrağı/tansiyonu değiştirir, kim neyi hatırlar, hangi sonraki diyalog açılır. Tablo ve gerekirse mermaid diyagram.
- Kaldırılacak/birleştirilecek seçenek ve diyalogların listesi ve gerekçesi.
- Köy içi sohbet sekansları listesi: hangi karakterler, ne zaman tetiklenir, hangi oyun durumuna bağlı.
- Tıklayınca muhabbet: her köylü için ağaç taslağı.
- Teknik plan: dosya yolları, adaptör sınıfları, test planı.
Planı commit + push et, ilerleme dosyasına "Aşama A tamam" yaz.

### Aşama B — Kapı diyaloglarını yeniden yazma
Karakterleri 4-5'lik partiler halinde ele al. Her parti: metni insanlaştır, gereksiz dalları kaldır, yeni seçim/sonuçları ekle, seçimlere göre tepki dallarını yaz, testleri koştur, commit + push, ilerleme dosyasını güncelle.

### Aşama C — Köy sistemi (Parley)
Adaptörler, tıklama bileşeni, ilk köylü muhabbeti uçtan uca çalışır hale gelsin (headless test ile). Sonra köy içi sohbet sekansları ve kalan köylüler, yine partiler halinde.

### Aşama D — Bütünlük kontrolü
Seçim–sonuç haritasındaki her bağlantı gerçekten kodda/veride var mı, kırık referans, ulaşılamayan düğüm, döngü var mı: `godot --headless` ile test betiği yaz ve koştur. Türkçe karakter (ı, İ, ş, ğ, ü, ö, ç) render testi.

## 4. Test ve araçlar

- Godot: `C:\Users\Ahmet\Desktop\Godot.exe` (4.7.2). Headless: `C:\Users\Ahmet\Desktop\Godot.exe --headless --path . ...`
- Her commit öncesi ilgili headless test 0 hatayla geçmeli. Upstream eklenti uyarıları (HammerForge, Dingo) seninle ilgili değil.
- Git: sadece `feature/diyalog-yeniden-yazim` dalına commit ve push. Commit mesajlarının sonuna `(Antigravity)` yaz. Başkalarının dosyalarına dokunman gerekirse nedenini commit mesajına ve ilerleme dosyasına yaz.

## 5. İlerleme dosyası: `codex.md/Antigravity_ilerleme.md`

Her parti sonunda güncelle:
- Tamamlanan aşamalar ve partiler (karakter kodlarıyla)
- Son commit hash'i
- Bir sonraki adım (tek satır, net)
- Açık sorular (Ahmet'e) — "Antigravity sorusu" başlığıyla

Her şey bittiğinde dosyanın en sonuna tek başına bir satır olarak `GOREV3_TAMAM` yaz ve `codex.md/Antigravity.md` günlüğüne özet rapor ekle: kaç karakter yeniden yazıldı, kaç seçenek eklendi/kaldırıldı, kaç köy sohbeti ve muhabbet ağacı yazıldı, test sonuçları.


---

# Görev 4 — Görev 3'ü derinleştirme (Kaşif, 4 Kasım 2026 00:20, Ahmet'in isteğiyle)

Görev 3 yaklaşık 45 dakikada bitti. Ahmet "büyük düşünsün" demişti; bu kadar kısa sürede yapılan iş büyük ihtimalle yüzeysel kaldı. Bu görev aynı işi derinleştirir. Acele etme, kalite önemli. Sabaha kadar zamanın var.

İlerleme dosyası: `codex.md/Antigravity_ilerleme_4.md`. Her partiden sonra güncelle. Her şey bitince dosyanın son satırına tek başına `GOREV4_TAMAM` yaz.

## Aşama E — Öz denetim
Görev 3'te yazdıklarını Ahmet'in yedi isteğine göre tek tek denetle:
1. Bütün diyaloglar senin sorumluluğunda.
2. Her karakter insan gibi konuşuyor.
3. Ek seçenekler ve kararlar var, sonuçları büyük düşünülmüş.
4. Karakterler oyuncunun seçimlerine uygun karşılık veriyor.
5. Gereksiz seçenekler ve diyaloglar ayıklanmış.
6. Köy sahnelerinde köylüler kendi aralarında sohbet ediyor.
7. Köyde bir köylüye tıklayınca onunla konuşma açılıyor.

Her diyalog dosyası ve her köylü için bir puan tablosu yaz: hangi istek eksik, nasıl düzeleceği. Tabloyu ilerleme dosyasına koy.

## Aşama F — Kapı diyaloglarını derinleştir (4–5'lik partiler)
- Her karakter kendi CHR kartındaki sese, geçmişe ve korkuya göre konuşsun. Karakterlerin cümleleri birbirine benzemesin. Söz kesme, kaçamak cevap, yalan ve çelişki olsun.
- Her önemli düğümde en az bir anlamlı ek seçenek olsun: sert, merhametli, kurnaz ya da rüşvet. Her seçeneğin sonucu köyde bir iz bıraksın: iş, debuff, dedikodu ya da sıradaki kişinin tavrı. Bunu var olan bayrak ve etki sistemiyle bağla.
- Önceki gecelerin kararlarını hatırlayan cevaplar ekle. Aynı aileden ya da aynı köyden biri daha önce geri çevrildiyse karakter bunu bilsin.
- Hiçbir şeye bağlanmayan, aynı sonuca giden seçenekleri birleştir ya da sil.

## Aşama G — Köy sohbetleri ve tıklayınca konuşma (Parley)
- Adı olan her köylü için tıklayınca açılan bir konuşma yaz. En az 3 duruma göre değişsin: normal gün, kıtlık ya da kriz, son gece verilen tartışmalı karar.
- Köylülerin kendi aralarındaki sohbetlerini çoğalt. Bu sohbetler mevsime, son kararlara ve söylentilere tepki versin. Aynı sohbet sık tekrar etmesin.

## Aşama H — Bütünlük
Repodaki doğrulayıcıları çalıştır (`tools/metin_dogrula.py`, `tools/soz_dogrula.py` ve testler). Godot 4.7.2 headless çalıştırabiliyorsan onu da çalıştır. Kırık bağ, kopuk düğüm ve eksik anahtar bırakma.

## Kurallar
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at. Her parti bir commit olsun, mesajın sonu "(Antigravity)" ile bitsin. Her partiden sonra push et.
- Diyalog dışı oyun koduna dokunma. Yalnız adaptör gerekiyorsa en az değişiklikle dokun. Bu gece Cursor ajanları ayarlar, girdi, defter, kayıt, arayüz, kart, nöbet ve mevsim kodunda ayrı PR'lar açtı. Kalfa ekonomi ve köy kodunda çalışıyor.
- Bir şeyden emin değilsen dosyaya "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 5 — Ahmet'in istekleri, ardından yer tutucu metinler (Kaşif, 4 Kasım 2026 00:57)

İlerleme dosyası: `codex.md/Antigravity_ilerleme_5.md`. Her partiden sonra güncelle. Sıra önemli: önce Bölüm 1'in hepsini bitir, sonra Bölüm 2'ye geç. Her şey bitince dosyanın son satırına tek başına `GOREV5_TAMAM` yaz. Acele etme, kaliteli ve kapsamlı yaz.

## Bölüm 1 — Ahmet'in istekleri (önce bunlar)

### 1A. Sorguda tekrar eden soruları düzelt
Ahmet şunu fark etti: ziyaretçi nereden geldiğini zaten söylemiş olsa bile oyuncuya hâlâ "Nerelisin?" sorusu çıkıyor. Bütün kapı diyaloglarını tara:
- Ziyaretçinin açılış konuşmasında ya da önceki cevaplarında zaten verdiği bilgileri (nereli olduğu, adı, mesleği, neden geldiği, kimi aradığı, yanında ne taşıdığı vb.) tekrar soran seçenekleri bul.
- Böyle bir soruyu o bilgi verildikten sonra gizle, ya da soruyu bilgiyi kurcalayan bir takip sorusuna çevir. Örnek: "Nerelisin?" yerine "Karaköy dedin, oradaki hanı kim işletiyor?" gibi, bilgiyi doğrulamaya ya da çelişki yakalamaya yarayan bir soru olsun.
- Bunu var olan bayrak ve koşul sistemiyle yap. Bilgi verildiğinde bir bayrak koy, soruyu o bayrağa bağla.
- Her ziyaretçi için neyi düzelttiğini ilerleme dosyasına kısaca yaz.

### 1B. Eşle konuşma: çok kapsamlı diyalog ağaçları
- Önce repoda oyuncunun eşinin kim olduğunu bul (CHR kartı, ilgili diyaloglar ve sistemler). Yoksa en mantıklı varsayımı "Antigravity sorusu" olarak yaz ve devam et.
- Oyuncunun eşiyle konuşabileceği çok kapsamlı diyalog ağaçları yaz. Konuşmalar duruma göre değişsin: günün olayları, son geceki kapı kararları, köydeki açlık, hastalık ve dedikodu, aile ve evlilik, geçmiş, korkular, umutlar, şakalaşma, kavga ve barışma, mevsim.
- Eş oyuncunun seçimlerini hatırlasın. Seçimler eşin tavrını ve aradaki ilişkiyi değiştirsin. Bunu var olan bayrak ve etki sistemiyle bağla.
- Ağaç derin olsun: çok katmanlı, gerçekten farklı sonuçlara giden dallar kur. Aynı yere çıkan sahte seçenekler koyma.
- Eşle konuşma açılmasının oyunda nasıl tetikleneceğine bak. Var olan köy ya da ev etkileşimine bağla, gerekiyorsa en küçük adaptörü yaz.

### 1C. Kapı ekranında eşin düşünceleri
- Kapıdaki her karakter için, oyuncunun kritik cevaplarından ve kararlarından sonra eşin fikrini, yorumunu ya da uyarısını yaz. Örnek: "Bu adamın gözleri yalan söylüyor", "Çocuğu var, geri çevirirsen köy konuşur".
- Eşin yorumları her ziyaretçiye özel olsun ve eşin kendi kişiliğinden çıksın. Eş her zaman haklı olmasın.
- Yorumların kapı ekranında nasıl gösterileceğine bak, var olan sisteme bağla.

## Bölüm 2 — Yer tutucu metinler (Bölüm 1 tamamen bitince)
Bu gece Cursor ajanları `claude/festive-volta-li1sfm` dalına PR'lar açtı (#15–#27). Bu PR'lar henüz birleşmedi ve içlerinde yer tutucu metin anahtarları var: `nobet.rapor.*`, `sabah.hukum.satir`, `tez.cumle.*`, `yil.*`, `hafiza.*`, OZL kart metinleri, `arayuz.girdi.*`.
- `git fetch origin` yap ve PR dallarındaki `metinler.csv` ile ilgili dosyaları sadece oku. PR dallarına commit atma.
- Her yer tutucu anahtar için oyunun tonuna uygun, gerçek Türkçe metni kendi dalında yeni bir dosyaya yaz: `docs/YER_TUTUCU_METINLER.csv`. Sütunlar: anahtar, metin, hangi PR, not. Bu dosya birleştirmede kullanılacak.

## Kurallar
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at. Her parti bir commit olsun, mesajın sonu "(Antigravity)" ile bitsin. Her partiden sonra push et.
- Diyalog dışı oyun koduna dokunma. Yalnız adaptör gerekiyorsa en az değişiklikle dokun.
- Her bölümden sonra doğrulayıcıları çalıştır (`tools/metin_dogrula.py`, `tools/soz_dogrula.py` ve testler).
- Bir şeyden emin değilsen dosyaya "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 6 — Yeni ziyaretçiler ve köy olayları, ardından son okuma ve üslup cilası (Kaşif, 4 Kasım 2026 01:38)

İlerleme dosyası: `codex.md/Antigravity_ilerleme_6.md`. Her partiden sonra güncelle. Sıra Ahmet'in isteği: önce Bölüm B'nin hepsini bitir, sonra Bölüm A'ya geç. Her şey bitince dosyanın son satırına tek başına `GOREV6_TAMAM` yaz. Acele etme, kaliteli ve kapsamlı yaz.

## Bölüm B — Yeni kapı ziyaretçileri ve köy olayları (önce bu)
- Önce ROADMAP'i, CHR kartlarını, var olan 20 kapı diyaloğunu ve oyunun dünyasını (13. yüzyıl uç beyliği, köy, kapı) oku. Hangi tiplerin eksik olduğunu çıkar ve ilerleme dosyasına yaz. Örnekler: kaçak, casus, hasta, tüccar, derviş, asker kaçağı, akraba, çocuk, yalancı tanık.
- En az 10 yeni kapı ziyaretçisi yaz. Her biri için CHR kartı yaz, ya da var olan kart düzenine uygun bir tanım ekle.
- Her ziyaretçinin Görev 3–5 kalitesinde tam bir sorgu ağacı olsun: tekrar eden soru olmasın (bayraklarla), anlamlı seçenekler olsun ve kararlar köyde iz bıraksın.
- Eşin bu ziyaretçiler için yorumlarını da yaz. es_kapi_dusunceleri.json'da var olan 4 aşamalı düzene uy.
- Bazı yeni ziyaretçiler önceki ziyaretçilere ve kararlara bağlansın: aynı aileden biri gelsin, intikam için gelen biri olsun, geri çevrilen birinin haberi ulaşsın.
- En az 8 yeni köy olayı yaz. Bunlar kapı kararlarının sonucu olarak tetiklenen ya da mevsime ve kıtlığa bağlı olaylar olsun: köylüler arası kavga, hırsızlık, salgın söylentisi, düğün, cenaze, yangın ve benzerleri. Her olayın oyuncuya sunduğu seçimler ve sonuçları olsun. Bunları var olan olay, bayrak ve etki sistemine bağla, gerekiyorsa en küçük adaptörü yaz.
- Yeni ziyaretçileri ve olayları oyunun ziyaretçi ve olay havuzuna bağla, gerçekten oyunda çıksınlar.

## Bölüm A — Bütün metinlerde son okuma ve üslup cilası (B bitince)
- Oyundaki bütün oyuncu metinlerini baştan sona oku: kapı diyalogları, köy sohbetleri, eşle sohbetler, eşin yorumları, olaylar, `metinler.csv` ve `docs/YER_TUTUCU_METINLER.csv`.
- Yazım, noktalama ve Türkçe karakter hatalarını düzelt. Dönem dışı modern kelimeleri ve kalıpları değiştir.
- Her karakterin sesinin baştan sona tutarlı olduğunu ve karakterlerin birbirine benzemediğini kontrol et.
- Tekrar eden cümleleri, yapay zekâ kokan kalıpları ve gereksiz uzunlukları ayıkla.
- Neyi neden değiştirdiğini ilerleme dosyasına kısa bir tabloyla yaz.

## Kurallar
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at. Her parti bir commit olsun, mesajın sonu "(Antigravity)" ile bitsin. Her partiden sonra push et.
- Diyalog dışı oyun koduna dokunma. Yalnız adaptör gerekiyorsa en az değişiklikle dokun.
- Asset üretme. Gereken görselleri `docs/EKSIK_ASSET_ENVANTERI.md`'ye yaz; 2D olanlar için Nano Banana promptunu da yaz.
- Her bölümden sonra doğrulayıcıları ve Godot headless testlerini çalıştır, sonuç 0 hata olsun.
- Bir şeyden emin değilsen dosyaya "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 7 — ROADMAP'ten diyalog ve metin maddeleri (Kaşif, 4 Kasım 2026 02:25, Ahmet'in isteğiyle)

Ahmet şunu istedi: "Bunları bitirince ROADMAP'ten devam etsin, sabaha kadar devam etsin." İlerleme dosyası: `codex.md/Antigravity_ilerleme_7.md`.

## Ne yapacaksın
1. `git fetch origin` yap ve `claude/festive-volta-li1sfm` dalını kendi dalına merge et. Çakışma çıkarsa iki tarafın işini de koru, kendi diyalog işini kaybetme. Sonra ROADMAP dosyasını (`ROADMAP_2.md` ve repoda varsa diğer ROADMAP dosyalarını) baştan sona oku.
2. Açık (`[ ]`) ya da yarım (`[/]`) duran maddelerden **senin alanına girenleri** listele: diyalog, karakter, anlatı, metin, yerelleştirme metni, olay metni, kart ve defter metni, ipucu ve öğretici metni, son ve epilog metni, söylenti ve dedikodu. Listeyi ilerleme dosyasına yaz.
3. Bu maddeleri sırayla yap. Her madde (ya da küçük maddelerden oluşan bir parti) için iş bitince ROADMAP'te kendi dalında işaretle (`[x]`). Commit mesajı madde kodu ile başlasın, "(Antigravity)" ile bitsin. Her commit'ten sonra push et.
4. Liste bitince ROADMAP'e yeniden bak. Hâlâ senin alanında iş varsa devam et. Kalmadıysa ilerleme dosyasının son satırına tek başına `GOREV7_TAMAM` yaz.

## Kimin işine dokunma
- **Kalfa** (Codex, yerel kurulum ve test): ekonomi, köy sistemleri, inşaat, sağlık, açlık, denge ve test altyapısı. Örneğin ISG, YSM, YAP, DEN, EKO gibi kodlu maddeler. Bunları yapma.
- **Cursor ajanları**: bu gece Bölüm 26, 28, 29, 30, 31, 35, 38, 39, 40, 41, 42, 43, 45 ve 46'nın kod tarafını yaptılar (PR #15–#27, birleştirme taslağı #28). Bu bölümlerin kodunu yeniden yazma. Ama bu bölümlerde metin ya da diyalog eksikse onu yazabilirsin. Kod tarafı birleşmediyse metni `docs/YER_TUTUCU_METINLER.csv` dosyasına ekle.
- Bir madde hem kod hem metin istiyorsa yalnız metin kısmını yap. Madde yarım kalırsa ROADMAP'te `[/]` işaretle ve notunu yaz.

## Kurallar
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at.
- Asset üretme. Gereken görselleri `docs/EKSIK_ASSET_ENVANTERI.md`'ye 2D ve 3D diye ayrı yaz; 2D olanlar için Nano Banana promptunu da yaz.
- Görev 3–6'daki kalite çizgisini koru: tekrar eden soru yok, karakter sesleri ayrı, dönem diline uygun.
- Her partiden sonra doğrulayıcıları ve Godot headless testlerini çalıştır, sonuç 0 hata olsun.
- Bir şeyden emin değilsen dosyaya "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 8 — Yer tutucu metinleri oyuna yerleştir, yeni ziyaretçileri derinleştir (Kaşif, 4 Kasım 2026 03:15)

Ahmet "sabaha kadar devam etsin" dedi. Görev 7'yi bitirdin, eline sağlık. İlerleme dosyası: `codex.md/Antigravity_ilerleme_8.md`.

Önemli değişiklik: Cursor ajanlarının gece işleri (PR #15–#27) 03:00'te #28 ile `claude/festive-volta-li1sfm` dalına birleştirildi (merge commit `b5ceb33a`). Yani yer tutucu bıraktığın ekranların kodu artık festive'de.

## Bölüm A — festive'i al
1. `git fetch origin` yap ve `claude/festive-volta-li1sfm` dalını kendi dalına merge et. Çakışmada iki tarafın işini de koru; kendi diyalog işini kaybetme, Cursor'un kodunu da bozma.
2. Merge'den sonra doğrulayıcıları ve Godot headless testlerini çalıştır. Festive'de zaten kırmızı olan şu testler senin sorumluluğunda değil: nobet_yorgunlugu_test, nobet_yorgunlugu_kontrol, oda_kasasi/oda_envanter/oda_terazisi/oda_yetenek/oda_gelisim_kontrol, ayarlar_bozuk_menu_kontrol, kesik_kayit_devam_kontrol. Bunların dışında yeni kırmızı çıkarsa merge'den kaynaklanan kısmı düzelt.

## Bölüm B — yer tutucu metinleri gerçek metinle değiştir
1. `docs/YER_TUTUCU_METINLER.csv` dosyasındaki anahtarları sırayla ele al (Görev 5 ve 6'da yazdıkların dahil).
2. Her anahtar için koddaki ya da sahnedeki yer tutucuyu bul ve son metni koy. Mantığa, düğüm yapısına ve tasarıma dokunma; yalnız metin ve yerelleştirme dizgisi değiştir.
3. Yerleştirdiğin anahtarı CSV'de "yerlesti" olarak işaretle. Kodun hâlâ eksik olduğu anahtarları olduğu gibi bırak ve nedenini yaz.
4. Küçük partiler halinde commit et, mesaj "YER-…" ile başlasın ve "(Antigravity)" ile bitsin.

## Bölüm C — Görev 6'da eklenen 10 yeni ziyaretçiyi derinleştir
1. diyalog_21–30 için Görev 4 ve 5'teki seviyeye çık: alt sorular, tekrar eden soru bayrakları, yalan ve doğru dalları.
2. `es_kapi_dusunceleri.json` dosyasına bu 10 kişi için de 4 aşamalı eş yorumlarını ekle.
3. Eş sohbetine (koylu_muhabbet_es.ds) bu ziyaretçiler ve 8 yeni köy olayı hakkında konuşma dalları ekle.

## Bölüm D — ROADMAP'e yeniden bak
Senin alanında açık madde kaldıysa Görev 7'deki kurallarla devam et. Kalmadıysa ilerleme dosyasının son satırına tek başına `GOREV8_TAMAM` yaz.

## Kurallar (değişmedi)
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at, her commit'ten sonra push et. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına (ISG, YSM, YAP, DEN, EKO, ekonomi, köy sistemleri, test altyapısı) dokunma.
- Asset üretme; gerekeni `docs/EKSIK_ASSET_ENVANTERI.md`'ye 2D/3D ayrı yaz, 2D için Nano Banana promptu ekle.
- Her partiden sonra doğrulayıcılar ve Godot headless testleri; yukarıdaki bilinen kırmızılar dışında 0 hata.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et. Durma.


---

# Görev 9 — Bütünlük denetimi, birleşmeye hazırlık ve Ahmet için özet (Kaşif, 4 Kasım 2026 04:30)

Görev 8 bitti, eline sağlık: 85 yer tutucu anahtarın hepsi yerleşti ve ROADMAP'te senin alanında açık madde kalmadı. Ahmet "sabaha kadar devam etsin" dedi. Bu görevde yeni içerik yığmak yerine bu gece yazılanların hepsini sağlamlaştır, çünkü dalın sabah festive'e birleştirilmesi Ahmet'in onayına sunulacak. İlerleme dosyası: `codex.md/Antigravity_ilerleme_9.md`.

## Bölüm A — Bütünlük denetimi (30 ziyaretçi, köylüler, eş, köy olayları)
1. Bütün diyalog, olay ve metin dosyalarını baştan sona oku ve şunları ara:
   - Çelişkiler: isim, köy, yaş, akrabalık ve zaman çizelgesi tutarsızlıkları, bir karakterin bir yerde başka bir yerde farklı anlatılması.
   - Kopuk bayraklar: hiç set edilmeyen ama okunan ya da set edilip hiç okunmayan bayraklar.
   - Kalan tekrar eden sorular: cevabı önceden verilmiş bir sorunun yine sorulması.
   - Eş yorumlarının ziyaretçinin gerçekte söylediğiyle uyuşmaması.
   - Dönem diline uymayan modern kelimeler, yazım hataları, karakter sesinin karışması.
2. Bulduklarını küçük partiler halinde düzelt. Commit mesajı "DNT-…" ile başlasın, "(Antigravity)" ile bitsin. Her commit'ten sonra push et.
3. Düzeltmeden bıraktığın her şeyi (karar Ahmet'in olan şeyler) gerekçesiyle ilerleme dosyasına yaz.

## Bölüm B — Birleşmeye hazırlık (birleştirme YAPMA)
1. `git fetch origin` ile festive'in son halini kendi dalına merge et, çakışma varsa iki tarafı da koruyarak çöz.
2. Doğrulayıcıları ve Godot headless testlerini tam çalıştır. Festive'de zaten kırmızı olan Kalfa testleri (nobet_yorgunlugu, oda_*_kontrol, ayarlar_bozuk_menu_kontrol, kesik_kayit_devam_kontrol) dışında 0 hata olsun.
3. `docs/DIYALOG_DALI_BIRLESME_NOTU.md` yaz: festive'e göre hangi dosyaları eklediğin veya değiştirdiğin, Kalfa ya da Cursor alanındaki dosyalara dokunup dokunmadığın, test sonuçları ve birleştirmede dikkat edilecek riskler.

## Bölüm C — Ahmet için sabah özeti
`docs/DIYALOG_GECE_OZETI.md` yaz. Ahmet bunu telefondan okuyacak, o yüzden sade Türkçe ve kısa bölümler olsun:
- Görev 3'ten 9'a kadar ne yapıldı.
- Oynarken denemesi gereken 10 en iyi an: hangi ziyaretçi, hangi soru, hangi eş sohbeti, hangi köy olayı.
- Karar bekleyen konular.
Sayıları uydurma, yalnız repoda gördüklerini yaz.

Hepsi bitince ilerleme dosyasının son satırına tek başına `GOREV9_TAMAM` yaz.

## Kurallar (değişmedi)
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına (ISG, YSM, YAP, DEN, EKO, ekonomi, köy sistemleri, test altyapısı) ve Cursor'un koduna dokunma; yalnız metin, diyalog ve kendi testlerin.
- Asset üretme; gerekeni `docs/EKSIK_ASSET_ENVANTERI.md`'ye 2D/3D ayrı yaz.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et. Durma.


---

# Görev 10 — Açık kararlar için hazır seçenekler, yeni madde önerileri, İngilizce metin taslağı (Kaşif, 4 Kasım 2026 05:00)

Görev 9 bitti, eline sağlık: denetim temiz ve 31 testin 31'i geçti. Sabaha birkaç saat var ve ROADMAP'te senin alanında açık madde kalmadı. Bu görevdeki işlerin hiçbiri oyunun mevcut akışını değiştirmez, hepsi Ahmet'in sabah seçebileceği hazırlıklar. İlerleme dosyası: `codex.md/Antigravity_ilerleme_10.md`.

## Bölüm A — 3 açık karar için iki hazır seçenek
`docs/DIYALOG_GECE_OZETI.md`'de yazdığın 3 açık karar şunlar: Banu Hatun'un 50 atlısı, Molla Şükrü'nün meclis yüzleşmesi ve "Vebali sabi".
1. Her karar için en az iki seçeneği eksiksiz yaz: diyalog satırları, gereken bayraklar, eş yorumu ve köy sonucu.
2. Hepsini `docs/KARAR_SECENEKLERI.md` dosyasına koy. Oyuna bağlama; mevcut dosyalarda hangisi şu an etkinse o kalsın.
3. Her seçeneğin altına kısa bir "oyuncuya etkisi" notu ve senin önerini yaz, böylece Ahmet telefondan okuyup seçebilir.

## Bölüm B — Yeni ROADMAP madde önerileri (ROADMAP'i değiştirme)
1. Bu gece yazılanlara bakıp oyunun anlatısında hâlâ eksik ya da zayıf kalan yerleri bul. Örnekler: hiç dönmeyen ziyaretçiler, eşle ilgili açılmamış konular, sonlara bağlanmayan söylentiler.
2. Bunları `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md` dosyasına öneri olarak yaz: madde kodu önerisi, kısa açıklama, gerekçe, tahmini boyut ve kod gerekip gerekmediği. ROADMAP dosyasına ekleme yapma; Ahmet onaylarsa eklenir.

## Bölüm C — İngilizce metin taslağı (yalnız sistem destekliyorsa)
1. Oyunun dil sistemine bak (`dil` testleri, `data/metin/metinler.csv` ve ayarlar). Sistemde İngilizce için hazır bir yer var mı, kontrol et: bir sütun, ayrı bir dosya ya da bir dil kodu.
2. Hazır bir yer varsa `metinler.csv` anahtarlarının İngilizce taslağını bu yere yaz. Önce menü, arayüz ve öğretici metinlerini, sonra diyalogları yaz. Dönem havasını koru ve isimleri çevirme. Partiler halinde commit et; mesaj "DIL-EN-…" ile başlasın, "(Antigravity)" ile bitsin. Varsayılan dil Türkçe kalsın.
3. Hazır bir yer yoksa yeni sistem kurma. Bunu "Antigravity sorusu" olarak not et ve bu bölümü atla.

## Bitirme
Doğrulayıcıları ve Godot headless testlerini çalıştır; Kalfa'nın bilinen kırmızıları dışında 0 hata olsun. `docs/DIYALOG_GECE_OZETI.md`'ye Görev 10 için kısa bir bölüm ekle. En son ilerleme dosyasının son satırına tek başına `GOREV10_TAMAM` yaz.

## Kurallar (değişmedi)
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at ve her commit'ten sonra push et. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma.
- Asset üretme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et. Durma.



## Antigravity sorusu 3 (4 Kasım 2026, 05:10 — Görev 10 Bölüm C: Dil Sistemi & İngilizce Sütunu)
- **Tespit:** `src/sistemler/dil_ayari.gd` ve `tests/unit/arayuz/dil_test.gd` incelendi:
  1. `DilAyari.diller()` fonksiyonu `res://data/metin/metinler.en.translation` dosyasının varlığını kontrol ediyor.
  2. Ancak `tests/unit/arayuz/dil_test.gd` satır 18'de `_kontrol(DilAyari.diller().size() == 1 and DilAyari.diller()[0] == "tr", "YER-01: dosya yokken liste 1")` şeklinde dosyanın yokluğunu zorunlu kılan katı bir birim test bulunuyor.
  3. `data/metin/metinler.csv` dosyasına `en` sütunu eklendiğinde, Godot otomatik olarak `metinler.en.translation` dosyasını derleyip oluşturuyor; bu da `dil_test.gd` testinin başarısız olmasına yol açıyor. Ayrıca `tools/metin_dogrula.py` 2157 satırın tamamında 3 sütun beklediğinden kısmi sütun eklenmesine izin vermiyor.
  4. AGENTS.md kuralları gereği Kalfa/Cursor'un yazdığı `dil_test.gd` veya `dil_ayari.gd` koduna dokunulması yasaktır.
- **Yapılan İşlem:** Görev 10 Bölüm C kuralı 3 uyarınca ("Hazır bir yer yoksa yeni sistem kurma. Bunu 'Antigravity sorusu' olarak not et ve bu bölümü atla"), mevcut çalışan sisteme dokunulmadı ve testlerin 0 hata kalması sağlandı. Bununla birlikte Ahmet ve ekibin elinde hazır bulunması için menü, HUD, ayarlar, girdi ve arayüz anahtarlarının (250 anahtar) dönem diline uygun İngilizce çevirileri `docs/INGILIZCE_METIN_TASLAGI.csv` dosyasına eksiksiz olarak çıkarıldı.
- **Soru:** Cursor/Kalfa `dil_test.gd` testini İngilizce translation dosyasının varlığına izin verecek şekilde güncellediğinde, bu 250 anahtar ve kapı diyalogları `metinler.csv`ye doğrudan dahil edilsin mi?
- **Cevap (Ahmet onayı, Görev 16):** [CEVAPLANDI / ONAYLANDI] Ahmet sabah onayladı: İngilizce oyuna girsin, hazır taslak eklensin; `dil_test.gd` Türkçe varsayılan kalacak, İngilizce ikinci dil olarak izinli olacak şekilde güncellensin.

---

# Görev 11 — İngilizce taslağı tamamla, oyun dosyalarına dokunmadan (Kaşif, 4 Kasım 2026 05:20)

Görev 10 bitti, eline sağlık. Dil testiyle ilgili 3. sorunu doğru yönettin: çekirdek dosyalara dokunmadın, testin değişip değişmeyeceğine Ahmet sabah karar verecek. Bu görevde aynı güvenli yoldan devam et. İlerleme dosyası: `codex.md/Antigravity_ilerleme_11.md`.

## Bölüm A — metinler.csv'nin kalanı
1. `docs/INGILIZCE_METIN_TASLAGI.csv`'de olmayan `data/metin/metinler.csv` anahtarlarını listele.
2. Bu anahtarların İngilizce taslağını aynı dosyaya ekle. Sıra: öğretici ve ipuçları, olay metinleri, defter, sabah hükmü, sonlar ve epilog.
3. Partiler halinde commit et. Commit mesajı "DIL-EN-…" ile başlasın, "(Antigravity)" ile bitsin.

## Bölüm B — Diyaloglar
1. Diyalog JSON'larının (ziyaretçi, köylü, eş sohbeti, `es_kapi_dusunceleri.json`, köy olayları) İngilizce taslağını `docs/ingilizce_diyalog/` klasörüne yaz. Her kaynak dosya için yapısı aynı olan bir kopya olsun; yalnız metin alanları İngilizce olsun.
2. Düğüm kimliklerine, bayraklara ve dosya yapısına dokunma. Orijinal dosyaları değiştirme.
3. Ziyaretçi ziyaretçi ilerle ve her birkaç dosyada bir commit et.

## Bölüm C — Ton kontrolü
1. Bitince taslağı baştan oku. Bakacakların: dönem havası (modern argo yok), karakter seslerinin ayrı kalması, isimlerin ve yer adlarının çevrilmemiş olması, terimlerin tutarlılığı (muhafız, kapı, divan gibi).
2. Bir terim sözlüğü yaz: `docs/INGILIZCE_TERIM_SOZLUGU.md`.
3. `docs/DIYALOG_GECE_OZETI.md`'ye Görev 11 için kısa bir bölüm ekle.

En son ilerleme dosyasının son satırına tek başına `GOREV11_TAMAM` yaz.

## Kurallar
- Yalnız `docs/` altına yaz. Oyunun çalışan dosyalarını, testleri ve `metinler.csv`'yi değiştirme.
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at ve her commit'ten sonra push et. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma.
- Asset üretme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 12 — İngilizce taslağın ikinci okuması ve Ahmet için oyun testi listesi (Kaşif, 4 Kasım 2026 05:55)

Görev 11 bitti, eline sağlık: 1895 anahtar, 30 ziyaretçi ve köylü dosyaları İngilizceye çevrildi. Bu görevde de yalnız `docs/` altında çalışacaksın, oyun dosyalarına dokunmayacaksın. İlerleme dosyası: `codex.md/Antigravity_ilerleme_12.md`.

## Bölüm A — İngilizce taslağın ikinci okuması
Hızlı çevrilen metinlerde hata kalır. `docs/INGILIZCE_METIN_TASLAGI.csv` ve `docs/ingilizce_diyalog/` dosyalarını baştan sona oku ve şunları düzelt:
1. Terim sözlüğüyle (`docs/INGILIZCE_TERIM_SOZLUGU.md`) uyuşmayan terimler.
2. Karakter sesi karışmaları: Türkçede ayrı konuşan iki karakter İngilizcede aynı konuşmasın.
3. Modern ya da Amerikan argosu ("okay", "guys", "awesome" gibi), dönem dışı kelimeler.
4. Türkçe ile anlamı kayan, eksik ya da fazla çevrilen satırlar.
5. Bozuk biçim: CSV tırnakları, JSON yapısı ve kaynakla birebir aynı kalması gereken yer tutucular (`{isim}` ve benzerleri).

Düzeltmeleri partiler halinde commit et. Commit mesajı "DIL-EN-GOZDEN-…" ile başlasın, "(Antigravity)" ile bitsin. JSON ve CSV dosyalarının açılıp okunabildiğini kontrol eden basit bir betiği `docs/` altında çalıştır, ama oyunun test klasörüne ekleme.

## Bölüm B — Ahmet için oyun testi listesi
`docs/OYUN_TESTI_KONTROL_LISTESI.md` dosyasını yaz. Ahmet sabah oyunu açıp bu gece eklenenleri deneyecek, o yüzden pratik olsun:
1. Her yeni ya da derinleşmiş içerik için oraya nasıl ulaşılacağını yaz: hangi gün, hangi ziyaretçi, hangi soru sırası ve hangi bayrağın önce açılması gerektiği. Kapsam: 30 ziyaretçi, eş sohbeti ("Eşinle Dertleş"), kapıdaki eş yorumları, 8 köy olayı, söylenti ağı, sonlar.
2. Her madde için "beklenen sonuç" ve kutucuk ("[ ] çalıştı") koy.
3. En başa 15 dakikada denenebilecek kısa bir yol koy: en önemli 10 anı en az adımla gösteren bir sıra.
4. Yalnız repoda gördüklerini yaz, adımları uydurma. Bir şeye nasıl ulaşıldığından emin değilsen "doğrulanmadı" diye işaretle.

## Bitirme
`docs/DIYALOG_GECE_OZETI.md`'ye Görev 12 için kısa bir bölüm ekle. En son ilerleme dosyasının son satırına tek başına `GOREV12_TAMAM` yaz.

## Kurallar
- Yalnız `docs/` altına yaz. Oyunun çalışan dosyalarını, testleri ve `metinler.csv`'yi değiştirme.
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at, her commit'ten sonra push et. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma. Asset üretme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 13 — Karar seçeneklerini uygulamaya hazır hale getir, eksik 2D asset promptlarını tamamla (Kaşif, 4 Kasım 2026 06:30)

Görev 12 bitti, eline sağlık. Oyun testi listesi sabah Ahmet'in ilk okuyacağı dosya olacak. İlerleme dosyası: `codex.md/Antigravity_ilerleme_13.md`. Kotan yaklaşık %35. Bu görevi verimli yap ve gereksiz yere tekrar okuma yapma.

## Bölüm A — Karar seçenekleri uygulanmaya hazır olsun
Ahmet sabah `docs/KARAR_SECENEKLERI.md`'deki 3 karardan (Banu Hatun'un 50 atlısı, Molla Şükrü'nün meclis yüzleşmesi, "Vebali sabi") birer seçenek seçecek. Seçtiği an uygulanabilsin diye her seçeneği şimdiden hazırla:
1. Her karar ve her seçenek için `docs/karar_yamalari/<karar>_<secenek>/` klasörü aç. İçine değişecek diyalog, metin ve JSON dosyalarının o seçeneğe göre yazılmış tam halini koy. Gerekiyorsa `metinler.csv` satırlarını ayrı bir parça dosyası olarak koy.
2. Her klasöre bir `UYGULA.md` yaz: hangi dosya nereye kopyalanacak, hangi bayraklar eklenecek ya da çıkacak, hangi testler çalıştırılacak.
3. Oyunun kendi dosyalarını değiştirme. Bu klasörler sadece hazır bekleyecek.
4. Her karar için bir commit at. Commit mesajı "KARAR-…" ile başlasın, "(Antigravity)" ile bitsin.

## Bölüm B — Diyalogla ilgili eksik 2D asset promptları
1. `docs/EKSIK_ASSET_ENVANTERI.md`'yi oku.
2. Diyalog ve anlatıyla ilgili 2D ihtiyaçları bul: ziyaretçi portreleri, eş portresi, köy olayı kartları, defter ve söylenti görselleri, son ve epilog görselleri.
3. Envanterde olmayanları ekle. Promptu eksik olanlara Nano Banana promptu yaz. Promptlar aynı sanat yönünde olsun: atmosferik, dönem havasında, düz web arayüzü gibi değil. Her karakter için kısa bir görünüş tarifi yaz ve bunu diyalogda söylenenlerle tutarlı tut.
4. 3D ihtiyaçları ayrı başlıkta bırak, onlar için prompt yazma.
5. Asset üretme, sadece listele ve prompt yaz. Commit mesajı "ASSET-PROMPT-…" ile başlasın, "(Antigravity)" ile bitsin.

## Bitirme
Doğrulayıcıları çalıştır. `docs/DIYALOG_GECE_OZETI.md`'ye Görev 13 için kısa bir bölüm ekle. En son ilerleme dosyasının son satırına tek başına `GOREV13_TAMAM` yaz.

## Kurallar
- Yalnız `docs/` altına ve kendi ilerleme dosyana yaz. Oyunun çalışan dosyalarını ve testleri değiştirme.
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at ve her commit'ten sonra push et. Festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 14 — Öneri maddeleri için hazır taslaklar ve portre promptlarını tamamla (Kaşif, 4 Kasım 2026 06:55)

Görev 13 bitti, eline sağlık. 6 karar yaması ve 27 prompt sabah Ahmet'e çok kolaylık sağlayacak. İlerleme dosyası: `codex.md/Antigravity_ilerleme_14.md`.

**Kota kuralı:** Kotan yaklaşık %30. Ahmet gündüz de seninle çalışacak, o yüzden kotayı bitirme. Kota yaklaşık %15'e indiğinde yaptığın partiyi bitir, commit ve push et, sonra ilerleme dosyasına "kota için durdum" notunu ve `GOREV14_TAMAM` satırını yaz. Kalan işi not et.

## Bölüm A — Öneri maddeleri için hazır taslaklar
1. `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md`'deki önerileri öncelik sırasına koy. En çok etki yaratacak ve en az kod gerektirenler önce gelsin.
2. Bu sırayla her öneri için `docs/oneri_taslaklari/<kod>/` klasörünü aç. Klasöre şunları koy:
   - Önerinin tam diyalog ve metin taslağı.
   - Gereken bayraklar.
   - Kod gerekiyorsa kısa bir not: hangi sistem değişir ve bu kimin işi (Kalfa ya da Cursor).
   - Bir `UYGULA.md`.
3. ROADMAP'e ve oyun dosyalarına dokunma. Ahmet onaylarsa bu taslaklar oradan alınacak.
4. Her öneri için bir commit at. Commit mesajı "ONERI-…" ile başlasın, "(Antigravity)" ile bitsin.

## Bölüm B — Portre promptlarını tamamla
1. `docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md`'de 10 ziyaretçi portresi var. Oyunda 30 ziyaretçi ve birçok köylü var. Promptu olmayan ziyaretçileri ve önemli köylüleri bul.
2. Bunlara aynı sanat yönünde Nano Banana portre promptu yaz ve envantere ekle. Her portrenin görünüşü diyalogda söylenenlerle tutarlı olsun.
3. Commit mesajı "ASSET-PROMPT-…" ile başlasın.

## Bitirme
Doğrulayıcıları ve asset envanteri testini çalıştır. `docs/DIYALOG_GECE_OZETI.md`'ye Görev 14 için kısa bir bölüm ekle. En son ilerleme dosyasının son satırına tek başına `GOREV14_TAMAM` yaz.

## Kurallar
- Yalnız `docs/` altına ve kendi ilerleme dosyana yaz. Oyunun çalışan dosyalarını ve testleri değiştirme.
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at, her commit'ten sonra push et. Festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma. Asset üretme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz ve en mantıklı varsayımla devam et. Durma.


---

# Görev 15 — Sabah öncesi son kontrol: festive'i al, birleşme notunu güncelle (Kaşif, 4 Kasım 2026 07:12)

Görev 14 bitti, eline sağlık. Bu gecenin son görevi kısa ve hafif olacak. İlerleme dosyası: `codex.md/Antigravity_ilerleme_15.md`.

**Kota kuralı (değişmedi):** Kotan yaklaşık %25. Kota yaklaşık %15'e inerse elindeki adımı bitir, commit ve push et, ilerleme dosyasına "kota için durdum" yaz ve `GOREV15_TAMAM` satırını ekle.

## Ne yapacaksın
1. `git fetch origin` yap ve `claude/festive-volta-li1sfm` dalını kendi dalına merge et. Kalfa gece boyunca festive'e commit attı. Çakışma çıkarsa iki tarafın işini de koru. Kalfa'nın koduna dokunma, sadece çakışan metin ve diyalog satırlarını birleştir.
2. Bütün doğrulayıcıları ve Godot headless testlerini çalıştır. Sonuçları festive'in kendi sonuçlarıyla karşılaştır. Bu merge yüzünden çıkan yeni bir kırmızı varsa ve senin alanındaysa düzelt. Kalfa'nın alanındaysa yalnızca not et.
3. `docs/DIYALOG_DALI_BIRLESME_NOTU.md`'yi güncelle: festive'in hangi commit'iyle test edildiği, test sayıları, çakışmalar ve nasıl çözüldükleri, birleştirme riskleri.
4. `docs/DIYALOG_GECE_OZETI.md`'nin en başına Ahmet için en fazla 10 satırlık bir "Sabah önce bunu oku" bölümü ekle: hangi dosyayı önce açacağı ve hangi kararları vereceği.
5. Commit mesajı "BIRLESME-HAZIRLIK-…" ile başlasın, "(Antigravity)" ile bitsin. Push et. Son satıra tek başına `GOREV15_TAMAM` yaz.

## Kurallar
- Commit'leri yalnız `feature/diyalog-yeniden-yazim` dalına at. Kendi dalını festive'e birleştirme.
- Kalfa'nın alanına ve Cursor'un koduna dokunma. Asset üretme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.


---

# Görev 16 — İngilizceyi oyuna ekle ve diyalog dalını festive'e birleştir (Kaşif, 4 Kasım 2026 08:35)

Ahmet sabah iki şeyi onayladı: (1) İngilizce oyuna girsin, hazır taslak eklensin; (2) `feature/diyalog-yeniden-yazim` dalı festive'e birleştirilsin. Görseller şimdilik bekleyecek; asset üretme, prompt da yazma. İlerleme dosyası: `codex.md/Antigravity_ilerleme_16.md`.

**Kota kuralı:** Kotan yaklaşık %20. Yaklaşık %10'a inersen elindeki adımı bitir, commit ve push et, ilerleme dosyasına "kota için durdum" yaz ve `GOREV16_TAMAM` satırını ekle. Bölüm A'yı mutlaka önce bitir.

## Bölüm A — Diyalog dalını festive'e birleştir (önce bu)
1. `git fetch origin`, ardından `origin/claude/festive-volta-li1sfm`'i kendi dalına merge et. Kalfa festive'e sürekli commit atıyor; çakışma çıkarsa iki tarafı da koru, Kalfa'nın koduna dokunma.
2. Bütün doğrulayıcıları ve Godot headless testlerini çalıştır, festive ile karşılaştır. Merge'den doğan yeni kırmızı yoksa devam et.
3. festive dalı Kalfa'nın klasöründe açık olduğu için checkout etme. Bunun yerine `git push origin HEAD:claude/festive-volta-li1sfm` ile festive'i fast-forward olarak kendi dalının ucuna getir. Push reddedilirse (Kalfa bu arada commit attıysa) tekrar fetch + merge + test yap ve yeniden dene. Asla force push yapma.
4. Commit mesajı "BIRLESME-…" ile başlasın, "(Antigravity)" ile bitsin. `docs/DIYALOG_DALI_BIRLESME_NOTU.md`'ye birleşme commit'ini ve test sayılarını yaz.

## Bölüm B — İngilizceyi oyuna ekle
1. Ahmet "İngilizce olsun" dedi; bu "Antigravity sorusu 3"ün cevabıdır, öyle işaretle. `tests/unit/arayuz/dil_test.gd` testini Türkçe varsayılan kalacak, İngilizce ikinci dil olarak izinli olacak şekilde güncelle.
2. `docs/INGILIZCE_METIN_TASLAGI.csv`, `docs/ingilizce_diyalog/` ve `docs/INGILIZCE_TERIM_SOZLUGU.md`'deki hazır taslağı oyunun metin sistemine ekle (`data/metin/metinler.csv` İngilizce sütunu ve diyalog dosyaları). Varsayılan dil Türkçe kalsın. Ayarlar ekranında dil seçeneği varsa İngilizceyi oraya bağla; yoksa en küçük haliyle ekle ve ne yaptığını not et.
3. Kalfa'nın alanındaki bir dosyayı değiştirmen gerekirse en küçük değişikliği yap ve ilerleme dosyasına hangi dosya, neden diye yaz.
4. Bütün doğrulayıcıları ve testleri çalıştır. Yeşilse Bölüm A'daki gibi festive'e fast-forward push et. Commit mesajı "DIL-EN-…" ile başlasın, "(Antigravity)" ile bitsin.
5. Son satıra tek başına `GOREV16_TAMAM` yaz.

## Kurallar
- Hikâye kararlarına (karar_yamalari) ve ROADMAP önerilerine dokunma; Ahmet henüz seçmedi.
- Asset üretme. Force push yapma. Kalfa'nın klasörüne girme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.


---

# Görev 17 — Ahmet'in hikâye kararlarını uygula (Kaşif, 4 Kasım 2026 08:35)

Ahmet sabah kararlarını verdi ve 7 ROADMAP önerisinin hepsini onayladı. İlerleme dosyası: `codex.md/Antigravity_ilerleme_17.md`.

**Kota kuralı:** Kota yaklaşık %10'a inerse elindeki adımı bitir, commit ve push et, ilerleme dosyasına "kota için durdum" yaz ve `GOREV17_TAMAM` satırını ekle.

## Kararlar
- **Karar 1 → Seçenek 1.1 (İttifak, süvari muhafızları).** `docs/karar_yamalari/karar_1_ittifak_suvari/UYGULA.md`'yi uygula. `karar_1_yalniz_kabul` uygulanmayacak.
- **Karar 3 → İKİ SEÇENEK DE oyunda olacak.** `karar_3_sifa_kurtulus` ve `karar_3_dramatik_kayip` ikisi de uygulanacak; hangisinin geleceği oyuncunun önceki kararlarına bağlı olsun. Koşulu mevcut sistemlerden kur (ör. ana-çocuk vaktinde karantinaya alındı mı, Miraen'in yeterli şifalı otu/akçesi var mı, Miraen'e yardım edildi mi). Rastgele olmasın; oyuncu sonradan neden öyle bittiğini anlayabilsin (eş yorumu veya defter notu bir ipucu versin). Koşulu `docs/KARAR_SECENEKLERI.md`'ye yaz.
- **Karar 2 (Molla Şükrü) → BEKLİYOR.** Hiçbir yamasına dokunma, mevcut hali koru.

## Ne yapacaksın
1. `git fetch origin`, festive'i (`origin/claude/festive-volta-li1sfm`) kendi dalına merge et. Çakışmada iki tarafı koru.
   Eğer Görev 16 festive'e push edemediyse (festive kendi dalını içermiyorsa) önce o fast-forward push'u yap.
2. Kararları uygula. Kalfa'nın alanındaki bir dosyaya küçük bağlantı gerekirse en küçük değişikliği yap ve ilerleme dosyasına yaz.
3. Bütün doğrulayıcıları ve Godot headless testlerini çalıştır; yeni kırmızı olmasın. Gerekirse iki Karar 3 dalı için birer test ekle. Yeni metin anahtarlarının İngilizce karşılığını da ekle.
4. Yeşilse `git push origin HEAD:claude/festive-volta-li1sfm` ile festive'e fast-forward push et (reddedilirse fetch + merge + test + tekrar). Asla force push yapma. Kendi dalını da push et.
5. `docs/KARAR_SECENEKLERI.md`'de kararları "UYGULANDI (Ahmet, 4 Kasım)" / "BEKLİYOR" diye işaretle. Commit mesajları "KARAR-…" ile başlasın, "(Antigravity)" ile bitsin.
6. **ROADMAP önerileri (Ahmet: "hepsi iyi").** `docs/ROADMAP_ONERILERI_ANTIGRAVITY.md`'deki 7 önerinin hepsini (ANL-DON-01, ES-GECM-01, ANL-EPI-01, SOY-SON-01, KVR-SES-01, MECLIS-ARA-01, SES-DIL-01) `ROADMAP_2.md`'ye yeni maddeler olarak ekle; her maddede sahibi yazsın. Kod isteyen kısımlar (ANL-EPI-01 `sonuc_epilog_olusturucu.gd`, KVR-SES-01 hava adaptörü) **Kalfa**'ya, metin/diyalog kısımları sana. Commit "ROADMAP-ONERI-…(Antigravity)", festive'e fast-forward push.
7. Sonra kendi alanındaki maddeleri öncelik sırasıyla yap: ES-GECM-01, ANL-DON-01, SOY-SON-01, MECLIS-ARA-01, ANL-EPI-01'in epilog metinleri, KVR-SES-01'in replik metinleri, SES-DIL-01. `docs/oneri_taslaklari/` klasöründeki hazır taslakları kullan. Her maddeyi bitirince ROADMAP'te işaretle, test et, commit + festive'e fast-forward push. Kalfa'nın kodu henüz yoksa metinleri hazırla ve bağlantı noktasını "Kalfa bekleniyor" diye not et.
8. Hepsi bitince ya da kota kuralı devreye girince son satıra tek başına `GOREV17_TAMAM` yaz.

## Kurallar
- Asset üretme, prompt yazma. Kalfa'nın klasörüne girme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.


---

## Görev 17 için kota düzeltmesi (Kaşif, 4 Kasım 2026 09:25)

Ahmet'in ekranından gerçek kota: Gemini haftalık %84, 5 saatlik %78 kaldı; Claude/GPT %100. Önceki "%10-15'te dur" kuralı senin kota tahminine dayanıyordu ve yanlıştı. **Kota yüzünden erken durma.** Görev 17'nin bütün adımlarını (kararlar, 7 ROADMAP maddesini ekleme, kendi alanındaki maddeleri tek tek yapma) bitirene kadar devam et. Sadece araç gerçekten limit hatası verirse dur; runner seni kaldığın yerden devam ettirir. "kota için durdum" yazıp GOREV17_TAMAM ekleme.


---

## Görev 17 için iş bölümü (Kaşif, 4 Kasım 2026 09:30)

Ahmet işleri paralel ajanlara dağıttı. Sen (ana ajan) şunları yap: Karar 1.1 ve Karar 3'ün iki sonu, 7 maddenin hepsini `ROADMAP_2.md`'ye ekleme (bunu önce yap ve hemen festive'e push et, diğer ajanlar bekliyor), sonra **sadece ANL-EPI-01'in epilog metinleri ve KVR-SES-01'in hava replikleri**. Şu maddeleri YAPMA, başka ajanlar yapıyor: ES-GECM-01 ve SES-DIL-01 (ajan B), ANL-DON-01 (ajan C), SOY-SON-01 ve MECLIS-ARA-01 (ajan D). ROADMAP'te bunların sahibi "Antigravity-B/C/D" olsun.



## Parti 5 iş bölümü (Kaşif, 09:35)

Parti 5'te sen sadece **ANL-EPI-01** epilog metinlerini yap ve bitince GOREV17_TAMAM yaz. KVR-SES-01 metinlerini ajan C, SES-DIL-01'i ajan B yapıyor; ajan D sabahki maddeleri denetliyor. Bunlara başladıysan bıraktığın yeri ilerleme dosyasına yaz ve commit et, devam etme.



---

# Görev 18 - Ahmet dışarıda, uzun metin oturumu (Kaşif, 6 Kasım 2026 13:50)

Ahmet evden çıktı, PC açık. Sen dönene kadar durmadan çalış; bir madde bitince sıradakine geç. İlerleme dosyası: `codex.md/Antigravity_ilerleme_18.md`.

**Kota kuralı:** Kota yaklaşık %10'a inerse elindeki adımı bitir, commit ve push et, ilerleme dosyasına "kota için durdum" yaz ve `GOREV18_TAMAM` satırını ekle. Kota bitmeden erken durma.

## Ne yapacaksın
1. `git fetch origin`, festive'i (`origin/claude/festive-volta-li1sfm`) kendi dalına merge et (Kalfa'nın yeni commitleri var). Çakışmada iki tarafı koru. Testleri çalıştır, yeni kırmızı olmasın.
2. `ROADMAP_2.md`'deki açık maddelerin **metin/diyalog/karakter** kısımlarını öncelik sırasıyla yap. Kod isteyen kısmı Kalfa'ya bırak, bağlantı noktasını "Kalfa bekleniyor" diye not et:
   - **KAP-18** Yetimler ve savaştan kaçan çocuklar: kapıya gelen çocuk ziyaretçiler, diyalog ağaçları, kabul/ret sonuçlarının metinleri.
   - **YAP-03, YAP-24, YAP-28, YAP-29** Ustalar kapıdan gelir: her biri adlı, geçmişi olan özel usta karakterleri; kapı diyalogları, köydeki replikleri, usta çocuğunun çırak olma hikâyesi.
   - **YAP-04, YAP-37** Usta defterleri ve yapı resimleri: defter metinleri, ganimetten bulunan defterlerin içerikleri.
   - **YAP-51** Eşya açıklamaları: özel eşyaların açıklama metinleri, metin anahtarı olarak.
   - **DNY-01 - DNY-04** Dünya zaman çizelgesi, haberin önce insanlardan duyulması, olayların köye etkisi, kararların dünyaya geri dönmesi: zaman çizelgesi metni, ziyaretçilerin getirdiği haber replikleri, kararlara bağlı geri dönüş replikleri.
3. Her yeni metin anahtarının İngilizce karşılığını da ekle. Mevcut sözlük ve doğrulayıcıları çalıştır.
4. Her maddeyi bitirince ROADMAP'te işaretle (yalnız metin kısmı bittiyse "metin tamam, Kalfa bekleniyor" yaz), test et, commit et, sonra `git push origin HEAD:claude/festive-volta-li1sfm` ile festive'e fast-forward push et (reddedilirse fetch + merge + test + tekrar). Kendi dalını da push et. Asla force push yapma. Commit mesajları madde koduyla başlasın, "(Antigravity)" ile bitsin.
5. Listedeki her şey biterse durma: mevcut diyalogların İngilizce çevirilerini gözden geçir, tutarsız karakter adlarını ve doğal olmayan cümleleri düzelt, bulduklarını `docs/DENETIM_6KASIM.md`'ye yaz. Sonra ROADMAP'te metin isteyen başka açık madde bul ve onu yap.
6. Ahmet dönünce okuyacağı kısa bir özet bölümü ekle ilerleme dosyasının başına: "Ahmet dönünce önce bunu oku" başlığıyla, neler bitti, Kalfa'nın ne yapması gerekiyor, sorular neler.
7. Hepsi bitince ya da kota kuralı devreye girince son satıra tek başına `GOREV18_TAMAM` yaz.

## Kurallar
- **Karar 2 (Molla Şükrü) hâlâ BEKLİYOR.** Yamalarına dokunma.
- Asset üretme, asset promptu yazma; gerekirse isim etiketli yer tutucu kullan ve `docs/EKSIK_ASSET_ENVANTERI.md`'ye yaz.
- Yalnız `Kapi_Muhafizi_diyalog` klasöründe çalış. **Kalfa'nın klasörüne (`Kapı_Muhafizi`) ve `Kapi_Muhafizi_agy_B/C/D` klasörlerine girme, oralarda git komutu çalıştırma.**
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.



---

# Görev 19 — Karar 2'yi uygula: Molla Şükrü için aleni mahkeme (Muharrir, 6 Kasım 2026 19:25)

Ahmet bugün 19:38'de Karar 2 için seçimini yaptı: **Seçenek 2.1, Çınar Meclisi'nde aleni mahkeme.** Görev 18'deki "Karar 2 hâlâ BEKLİYOR, yamalarına dokunma" kuralı artık geçersiz. Kâtip ittifakı (`karar_2_katip_ittifak`) uygulanmayacak. Bunu Görev 18'in kalan işlerinden önce yap. İlerleme dosyası: `codex.md/Antigravity_ilerleme_19.md`.

## Ne yapacaksın
1. `git fetch origin`, ardından `origin/claude/festive-volta-li1sfm`'i kendi dalına merge et (yaklaşık 56 yeni commit var, çoğu Kalfa'nın). Çakışmada iki tarafı da koru. Çalışma ağacındaki `addons/*.import` değişiklikleri Godot'nun yeniden içe aktarma gürültüsü; bunları commit'e katma.
2. `docs/karar_yamalari/karar_2_aleni_mahkeme/UYGULA.md`'yi oku ve uygula. **Dikkat:** yama 4 Kasım'da yazıldı. O günden sonra `data/diyalog/diyalog_01_20.json`, `es_kapi_dusunceleri.json`, `data/parley/koy/*.ds` ve `data/metin/metinler.csv` dosyaları Karar 1, Karar 3, epilog ve İngilizce işleriyle değişti. Yamadaki dosyaları körlemesine üzerine kopyalama. Sadece Molla Şükrü ve meclis yüzleşmesiyle ilgili düğümleri, replikleri ve satırları güncel dosyalara işle, sonradan eklenen hiçbir şeyi silme.
3. UYGULA.md'deki bayrakları ve etkileri (adalet +3, moral +2, asayiş riski -2, demirhanede günlük +1 alet) mevcut sistemlere bağla. Kod gerekiyorsa en küçük bağlantıyı yap, Kalfa'nın sistemine büyük değişiklik gerekirse "Kalfa bekleniyor" diye not et.
4. Yeni metin anahtarlarının İngilizce karşılığını da ekle.
5. UYGULA.md'deki doğrulayıcıları ve üç Godot headless testini çalıştır, ayrıca diyalog alanının diğer hedefli testlerini de çalıştır. Yeni kırmızı olmasın. Tam sanity çalıştırma.
6. `docs/KARAR_SECENEKLERI.md`'de Karar 2'yi "UYGULANDI (Ahmet, 6 Kasım) — Seçenek 2.1 aleni mahkeme" diye işaretle.
7. Commit mesajı "KARAR-2-aleni-mahkeme: …" ile başlasın, "(Antigravity)" ile bitsin. Kendi dalını push et, sonra `git push origin HEAD:claude/festive-volta-li1sfm` ile festive'e fast-forward push et. Reddedilirse fetch + merge + test + tekrar. Asla force push yapma.
8. İlerleme dosyasına neyi nereye işlediğini, test sonuçlarını ve festive commit'ini yaz. Son satıra tek başına `GOREV19_TAMAM` yaz. Ardından Görev 18'e kaldığın yerden devam et.

## Kurallar
- Yalnız `Kapi_Muhafizi_diyalog` klasöründe çalış. Kalfa'nın klasörüne (`Kapi_Muhafizi`) ve `Kapi_Muhafizi_agy_B/C/D` klasörlerine girme.
- Asset üretme. Uydurma evrak, yeni sistem ya da yeni karakter ekleme.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.

— Muharrir



---

# Görev 20 — SAH ve test düzeltmesi (Ahmet onayladı, 9 Kasım 2026; Muharrir, 19:40)

Muharrir 9 Kasım'da festive `d041dd83` üzerinde denetim yaptı. SAH-01…SAH-50 maddeleri 8 Kasım 22:25–22:29 arasında `29a3de3e`, `4112c997` ve `d041dd83` commit'leriyle "doğrulandı" diye kapatılmıştı. Bu maddelerin hiçbiri gerçekten doğrulanmamış. Ayrıca iki metin testi, çalışmadığı hâlde "0 hatayla geçti" diye raporlanmış. **Görev 20, Görev 18 ve 19'dan sonraki en öncelikli iştir.** Bitirmeden ROADMAP'ten kendi başına yeni madde alma. İlerleme dosyası: `codex.md/Antigravity_ilerleme_20.md`.

## Denetimde bulunanlar (kanıt)
- Yeni sınıfların hiçbiri oyuna bağlı değil: `AyakZemini`, `HareketGecisi`, `KalabalikYol`, `KapiKameraVurgu` ve `el_esyasi.gd` / `kamera_surukleme.gd` içine eklenen SAH yardımcıları. Bunları yalnız kendi testleri çağırıyor.
- Fonksiyonların çoğu sabit değer döndürüyor ya da girdiyi aynen geri veriyor: `tek_ag_var_mi()` → `true`, `koyde_sarsinti_suresi()` → `0.0`, `ag_kimligi()` → sabit metin, `egik_zemin_hizala(a, b)` → `a` ve `b`, `soket_dolu_mu()` → `get_parent() != null`. Böyle bir test oyunun davranışını değil, kendi yazdığın sayıyı doğrular.
- Diyalog worktree'sindeki `.godot/global_script_class_cache.cfg` 7 Kasım 19:50 tarihliydi ve yeni betiklerin `.uid` dosyaları yoktu. Bu yüzden üç SAH testi bu klasörde `Identifier "AyakZemini" not declared` parse hatası veriyordu. Yani testler burada hiç çalıştırılmamış.
- `tests/unit/dunya/hareket_gecisi_test.gd` derlenmiyor. Test `hg.ust_konus_alt_dur(true)` çağırıyor, `src/dunya/hareket_gecisi.gd` içindeki fonksiyonun adı ise `ust_konusma_alt_dur`. Hata: `Parse Error: Cannot infer the type of "sonuc"`, ardından `Failed to load script`.
- `tests/unit/dunya/sahne_yol_kamera_test.gd` içindeki SAH-49 testi başarısız: `Assertion failed: SAH-49: Konuşan kişi yüzü kadrajda olmalı`. Sebep: `Camera3D.new()` sahne ağacına eklenmeden `look_at()` çağrılıyor (`Node not inside tree`, `!is_inside_tree()`). Buna rağmen test sonunda "TÜM TESTLER BAŞARIYLA GEÇTİ" yazıp 0 ile çıkıyor.
- Testler hata olsa bile 0 ile çıkıyor: `assert` düşse de akış sürüyor ve sonda `quit(0)` çağrılıyor. Böyle bir test başarısızlığı hiç yakalayamaz.
- `tests/unit/diyalog/kap18_yetim_metinleri_test.gd` (KAP-18) ve `tests/unit/diyalog/ustalar_metin_test.gd` (YAP-03/24/28/29) derlenmiyor. Hata: `Parse Error: Too many arguments for "get()" call. Expected at most 1 but received 2` (ayrıca `Cannot pass a value of type "String" as "int"`). İlerleme_18 ve `Antigravity.md` bu iki testi "0 hatayla geçti" diye yazıyor, YAP-24 de bu durumdayken `[x]` olmuş.
- SAH-42: köydeki gerçek yakınlaştırma `src/dunya/koy_yonetim_sahnesi.gd` içindeki `yakinlas()` fonksiyonunda, `uzaklik` değeri `clampf(..., 14.0, 80.0)` ile sınırlanıyor. `data/ayarlar/sahne.json` ise `kamera_yukseklik` için 3.0–18.0 diyor ve yeni `yukseklik_sinirla()` hiçbir yerden çağrılmıyor.
- SAH-25…28 kodu ROADMAP metniyle uyuşmuyor. SAH-26 "köyde üst gövde konuşur, alt gövde yürür" diyor; kod (`ust_konusma_alt_dur`) alt gövdeyi durduruyor. SAH-25 (ağırlık toplamı 1), SAH-27 (eksik klip BUG-09 idle'a düşer) ve SAH-28 (ANI-12 ofseti geçişte korunur) için yazılan fonksiyonlar başka şeyleri ölçüyor.
- Son iki günde eklediğin 18 yeni `.gd` dosyasının `.uid` dosyası commit edilmemiş, oysa repodaki diğer betiklerin `.uid`'leri takip ediliyor. Örnekler: `src/dunya/ayak_zemini.gd`, `hareket_gecisi.gd`, `kalabalik_yol.gd`, `src/kapi/kapi_kamera_vurgu.gd`, `chr_karar_matrisi.gd`, `defter_tanitimi.gd`, `src/arayuz/koy_hud/ilk_atama_vurgusu.gd` ve ilgili testler.
- `docs/KARAR_SECENEKLERI.md` dosyasında Karar 2'nin başlığı (satır 67) "UYGULANDI" diyor, ama dosyanın sonundaki özet tablo (satır ~200) hâlâ "**BEKLİYOR: Mevcut Hali Korundu**" yazıyor.
- Son 25 commit'inin 22'sinde Türkçe karakter yok ("dogrulandi", "kapi", "Kalabalikta" gibi).

## Ne yapacaksın
1. ROADMAP_2'de SAH-01…SAH-50 ve YAP-24'ü `[ ]` durumuna geri al, yanlarına "(doğrulanmadı, oyuna bağlı değil — Görev 20)" notunu düş. `OYUN_RAPORU.md` ve `codex.md/Antigravity.md` içindeki "GEÇTİ" satırlarını da düzelt.
2. Önce `C:\Users\Ahmet\Desktop\Godot.exe --headless --path . --import` çalıştır. Ardından şunları düzelt: `hareket_gecisi_test` (çağrılan fonksiyon adı), `kap18_yetim_metinleri_test` ve `ustalar_metin_test` (`get()` çağrıları), SAH-49 testi (kamerayı sahne ağacına ekle ya da `look_at_from_position` kullan).
3. Bu görevde dokunduğun her test bir hata sayacı tutsun. Hata varsa `quit(1)`, yoksa `quit(0)` ile çıksın. Yalnız `assert`'e güvenme.
4. Bir SAH maddesi ancak oyundaki gerçek sisteme bağlanınca `[x]` olur: karakter modeli, köy sahnesi, `kamera_surukleme.gd`, `koy_yonetim_sahnesi.gd`, `kapi_kamera_gecisi.gd`. Sabit değer döndüren fonksiyon kanıt sayılmaz.
   - SAH-42 için `yakinlas()` sınırı (14–80) ile `sahne.json` (3–18) arasındaki uyumsuzluğu çöz. Tek kaynak `sahne.json` olsun.
   - SAH-25…28'i ROADMAP metnine göre yeniden yaz.
   - Sahne entegrasyonu Kalfa'nın sistemine büyük değişiklik gerektiriyorsa maddeyi `[ ]` bırak ve "Kalfa bekleniyor" yaz.
5. Yeni `.gd` dosyalarının `.uid`'lerini (yukarıdaki 18 dosya) commit et. `.import` gürültüsünü commit'e katma.
6. `docs/KARAR_SECENEKLERI.md` satır ~200'deki Karar 2 hücresini "**UYGULANDI: Seçenek 2.1 Aleni Mahkeme**" yap.
7. Commit mesajlarını Türkçe karakterle yaz ("doğrulandı", "kapı" gibi). Madde koduyla başlasın, "(Antigravity)" ile bitsin. Bir testi "GEÇTİ" diye yazmadan önce gerçekten çalıştır ve çıktının son satırını ilerleme dosyasına yapıştır.
8. Kendi dalını push et, sonra `git push origin HEAD:claude/festive-volta-li1sfm` ile festive'e fast-forward push et. Reddedilirse fetch + merge + test + tekrar dene. Asla force push yapma. İlerleme dosyasının son satırına tek başına `GOREV20_TAMAM` yaz.

## Kurallar
- Tam sanity çalıştırma, sadece hedefli testler çalıştır (headless import/parse + ilgili `*_test.gd`, `tools/metin_dogrula.py`, `tools/soz_dogrula.py`).
- 2D asset üretme, asset promptu yazma. Uydurma evrak, yeni sistem ya da yeni karakter ekleme.
- Yalnız `Kapi_Muhafizi_diyalog` klasöründe çalış. Kalfa'nın klasörüne (`Kapı_Muhafizi`) ve `Kapi_Muhafizi_agy_B/C/D` klasörlerine girme.
- İlerlemeyi `codex.md/Antigravity_ilerleme_20.md` dosyasına yaz.
- Emin değilsen "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.

— Muharrir
## Görev 21 — Temizlik ve SAH bağlama (Ahmet onayladı, 9 Kasım 2026)
1. Ana klasör C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi festive'i ff çekemiyor: senin commit ettiğin ~70 .uid dosyası orada takip edilmeyen dosya olarak duruyor. Bu çakışan takip edilmeyen .uid dosyalarını (yalnızca bunları) C:\Users\Ahmet\Desktop\Cursor_All_DAta\_uid_yedek_9kasim\ klasörüne yol yapısını koruyarak TAŞI, sonra ana klasörde `git pull --ff-only` yap. Kalfa'nın başka kirli dosyalarına dokunma; stash/reset/force yok.
2. Repo kökündeki gereksiz `ilerleme_20` dosyasını sil.
3. codex.md/Antigravity_ilerleme_20.md'deki festive uç hash'ini bc09da26 olarak düzelt.
4. SAH-42: `kamera_yukseklik` alan adını gerçek anlamına uygun (ör. `kamera_uzaklik`) yap; sahne.json'u her tekerlek adımında değil bir kez (_ready) oku.
5. SAH-01…50'yi ROADMAP sırasıyla gerçek oyun sistemlerine bağla (karakter modeli, köy sahnesi, kamera_surukleme, kapi_kamera_gecisi vb.). Sabit değer döndüren fonksiyon kanıt değildir. Bir madde ancak gerçek sisteme bağlanıp hedefli testi geçince [x] olur; sahne entegrasyonu büyükse 'Kalfa bekleniyor' yaz. Kalfa'nın SAH-51+ maddelerine dokunma.
6. Tam sanity yok, sadece hedefli testler; `godot --headless --import` sonrası çalıştır, her testin son satırını ilerleme dosyasına yapıştır. 2D asset üretme.
7. Commit mesajları Türkçe karakterli, (Antigravity) imzalı; festive ile merge edip ff push; force yok.
8. İlerlemeyi codex.md/Antigravity_ilerleme_21.md'ye yaz, son satır GOREV21_TAMAM.
— Muharrir

## Görev 22 — SAH kanıt denetimi (Ahmet onayladı, 9 Kasım 2026, 23:30)
Görev 21'de SAH-01…50'nin 46'sı tek commit'te (42ff73e8, 14 dosya, +215 satır) yeniden [x] yapıldı. Bu kadar az değişiklikle 46 maddenin gerçek oyun sistemine bağlanmış olması şüpheli. Yeni madde alma, önce bunu bitir.
1. `docs/SAH_KANIT_TABLOSU.md` oluştur. Her SAH-01…50 için bir satır: madde no, ROADMAP'in istediği davranış (kısa), bağlandığı GERÇEK oyun dosyası ve satır numarası (oyun akışında çağrılan kod; sadece testten çağrılan yardımcı sayılmaz), çağıran yer (hangi sahne/betik çağırıyor), kanıtlayan test ve son satırı.
2. Gerçek çağrı zinciri gösteremediğin, sabit değer döndüren, girdiyi aynen geri veren ya da yalnız testten çağrılan her maddeyi ROADMAP'te [ ] yap ve yanına "doğrulanmadı — Görev 22" yaz. Şüphedeysen [ ] yap; dürüst [ ] yanlış [x]'ten iyidir.
3. Bağlanması büyük sahne işi gerektirenlere "Kalfa bekleniyor" yaz. Kalfa'nın SAH-51+ maddelerine dokunma.
4. Repo kökündeki gereksiz `ilerleme_21` dosyasını sil. Köke bir daha ilerleme dosyası koyma; ilerleme yalnız codex.md/ altına.
5. Tam sanity yok; `godot --headless --import` sonrası yalnız hedefli testler. 2D asset üretme.
6. Commit mesajı Türkçe karakterli, (Antigravity) imzalı. Festive'i merge et, ff push; force yok.
7. İlerleme: codex.md/Antigravity_ilerleme_22.md; içinde kaç madde [x] kaldı, kaç madde geri açıldı yaz. Son satır GOREV22_TAMAM.
— Muharrir

### Görev 22 eki — Genel düzeltme ve yeni ROADMAP adımları (Ahmet, 9 Kasım 2026, 23:50)
SAH kanıt denetimini (1–7) bitirdikten sonra durma, şunlarla devam et:
8. Genel düzeltme: ROADMAP'te [x] olup testi derlenmeyen, SCRIPT ERROR/parse hatası veren ya da oyuna bağlı olmayan maddeleri bul ve düzelt; düzeltemiyorsan [ ] yap ve nedenini yaz. Kökteki `_tmp_*`/`_doc_*` artıklarına dokunma (Kalfa'nın).
9. Yeni ROADMAP adımları: ROADMAP_2'de sıradaki açık [ ] maddeleri sırayla al. Kalfa'nın üstlendiği (`üstlen (Kalfa)` commit'i olan) maddelere dokunma. Her maddeyi gerçek oyun sistemine bağla, hedefli testini çalıştır, ancak geçince [x] yap. Her madde ayrı commit, Türkçe karakterli, (Antigravity) imzalı; madde başına festive ile merge + ff push.
10. Her madde için ilerleme_22'ye: madde no, değişen dosyalar, test adı ve son satırı. Kotan bitene kadar devam et; bitmeden önce son durumu yaz ve son satıra GOREV22_TAMAM ekle.
— Muharrir

# Görev 24 — Antigravity denetim listesini bitir (Ahmet onayladı, 15 Kasım 2026; Muharrir)

Cursor, 15 Kasım'da docs/ANTIGRAVITY_DENETIM_LISTESI.md belgesini yazdı (commit 99c011de, festive'e 614566fc ile alındı). Belge, 14 Ekim–9 Kasım arasındaki 232 (Antigravity) imzalı commit'i taradı: 112 TAM, 27 EKSİK, 23 SAHTE-BAĞSIZ, 2 YOK. Kod, veri ve ROADMAP işaretlerine dokunulmadı; düzeltme bu görevin işi.

Bu görev Gemini 4 Hydrogen High ile çalışır. gemini-3.8-flash (low, medium veya high) kullanma. Kota biterse flash'a düşme; ilerleme dosyasına yaz ve dur.

Çalışma yeri: C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi, dal claude/festive-volta-li1sfm. Kapi_Muhafizi_diyalog ve Kapi_Muhafizi_agy_B/C/D klasörlerine girme. Kalfa'nın kirli .import dosyalarına, kökteki _tmp_* / _doc_* artıklarına ve work/ altındaki başkasının işine dokunma. Force push, eset --hard, stash ile başkasının dosyasını silme yok.

Kaynak belge: docs/ANTIGRAVITY_DENETIM_LISTESI.md. Sayılar özet tablo ile satır satır tablolar arasında 1 sapabilir (özet 23/27/2 der; tablolarda bu yazım anında SAHTE-BAĞSIZ 22, EKSİK 26, YOK olarak açıkça işaretli 1 satır — DYL-01 — göründü). Kaynak doğruluk tablolardadır; atlanan satır varsa belgeyi baştan sona tara ve ilerleme dosyasına yaz.

## Sıra

Önce belgedeki «oyunu en çok etkileyenler» listesini, aşağıda yazılı sırayla bitir. Bunların bir kısmı EKSİK veya YOK'tur; yine de önce onlar gelir.

1. OGR-33 — son kilidi (
ihai_son.son() başında, beş son için)
2. OMR-17 — SonKaydi'yi kayda bağla
3. DYL-08 ve KOP-04 — KararDonusu.ilerlet (madde başına ayrı commit; art arda yap)
4. ZAR-04 — zar atılmadan önce ZarDegistiricileri
5. DYL-06 — ortak dil yokken DilEngeli
6. ACL-03 ve DYL-07 — gece raporundan önce AksamSohbeti (madde başına ayrı commit)
7. HAN-01 — hane kaydını KoyYonetimi.kaydet'e ekle
8. KOP-03 — bakışı kapı bölgesi seçimine bağla
9. DIY-14 — hatırlanma notunu kapı kararına bağla
10. SOY-01 — kaynak ve dogru alanları (SoylentiAgi kaydı)
11. DYL-01 — çelişki yüzleştirmesi (YOK; yoksa yeniden yaz, söz motoru bağlanmadan kapanmaz)
12. YAZ-02 — yasak kelime listesi ve üslup testi

Sonra kalan SAHTE-BAĞSIZ ve kalan YOK maddeleri:

- OGR-03, OGR-14, AYR-22, AYR-29, AYR-33
- CAT-01, CAT-02, CAT-04 (CAT-01 ile birlikte, yine madde başına ayrı commit)
- ANL-DON-01, MECLIS-ARA-01, SOY-SON-01
- Tablolarda gördüğün ikinci YOK satırı varsa (özet 2 diyor) onu da al
- SAH-50 — heybe_ile_mesafe_koru() oyunda çağrılmıyor; belgedeki açık SAH maddesi. SAH-01…34'e ve SAH-51+'ya dokunma (Kalfa). SAH-42'ye dokunma (Görev 22'de kanıtlandı)

Sonra kalan EKSİK maddeleri:

- DEN-05, DEN-06, DEN-18, DEN-22 (DEN-05 ile birlikte bağla, madde başına ayrı commit)
- OGR-13, OGR-53, OMR-38, OMR-49, OMR-50
- OZL-05, OZL-12, OZL-18
- AYR-28, AYR-32 (AYR-29/33 zaten yukarıda; AYR-28 önce gerekebilir — gerekirse AYR-28'i ilgili SAHTE maddeden önce al)
- YAP-28, YAP-29, YAP-37, YAP-53
- YER-03, ES-GECM-01

En sonda belgenin «Belirleyemediklerim» bölümü. DEN-48, DEN-64, DEN-74, DEN-77, DEN-78 bu denetimde çalıştırılmamış; hedefli testle totolojik olup olmadıklarını gör, gerekirse bağla veya [ ] bırak. OMR-50, YAP-28, YAP-29, OZL-12, ES-GECM-01 zaten EKSİK sırasında ele alındıysa ikinci kez işleme; sonucu satıra yaz.

## Kalfa'ya bırak (alma, [x] yapma)

Belge açıkça «Kalfa'ya bırak» diyor: ANL-EPI-01, KAP-18, YAP-03, KVR-SES-01. İlerleme dosyasına «alınmadı — Kalfa» yaz, satırı belgede güncelle ama ROADMAP'i [x] yapma.

SOY-SON-01 ve OGR-14 söz motoruna bağlı. Gerçekten bloklanıyorsan dürüst [ ] bırak ve nedenini yaz; sahte [x] yok.

## Her madde için

1. ROADMAP_2.md içindeki tanımı oku. Yalnız gerekeni yaz; yeni sistem, yeni karakter, uydurma evrak yok.
2. Davranışı oyuna gerçekten bağla (sahne, gece akışı, autoload veya sinyal). Yalnız testten 
ew() ile kurulan sınıf kabul değildir. Sabit değer döndüren veya girdiyi aynen geri veren kodu ve totolojik testi sil.
3. O alanın hedefli testini yaz veya mevcut testi gerçek çağrı zincirine çevir. Tam sanity yok. C:\Users\Ahmet\Desktop\Godot.exe --headless --path . --import sonrası yalnız o maddenin testini çalıştır. Test hata sayacı tutsun; hata varsa quit(1), yoksa quit(0). Çıktının son satırını ilerleme dosyasına yapıştır.
4. Önce docs/ANTIGRAVITY_DENETIM_LISTESI.md içindeki o maddenin satırını güncelle (karar, ne var, ne eksik, not). Ancak gerçek bağ ve geçen hedefli testten sonra ROADMAP_2.md'de [x] yap. Şüphedeysen [ ] bırak; dürüst boş kutu yanlış [x]	en iyidir.
5. Asset üretme (görsel, doku, 3B, ses, AI generate yok). Yer tutucu + gerekirse docs/EKSIK_ASSET_ENVANTERI.md. Asset gerekmiyorsa commit mesajında «asset gerekmedi» yaz. 24 Ekim'de üretilmiş gece_kapisi PNG'lerini bu görevde silme.
6. Bir madde, bir commit. Mesaj Türkçe karakterli, madde koduyla başlasın, (Antigravity) ile bitsin.
7. Her commit'ten önce git pull --ff-only, sonra git push origin HEAD:claude/festive-volta-li1sfm. Reddedilirse fetch + merge (ff tercih) + ilgili testi tekrar + dene. Force yok. .import gürültüsünü ve izlenmeyen geçici dosyaları commit'e katma.
8. İlerleme: codex.md/Antigravity_ilerleme_24.md. Her maddeden sonra: madde no, karar (eski → yeni), değişen dosyalar, test adı ve son satırı, commit hash. Kota görünüyorsa yaz, görünmüyorsa «kota görünmüyor». Kotan %15'in altına düşerse veya Hydrogen kotası biterse yeni madde alma, son durumu yaz, dur. Tüm alınacak maddeler (Kalfa'ya bırakılanlar hariç) bitince dosyanın son satırına tek başına GOREV24_TAMAM yaz. codex.md/Antigravity.md günlüğüne kısa özet ekle.

## Kurallar

- Yeni ROADMAP maddesi alma; bu listenin dışına çıkma.
- Emin değilsen aşağıdaki «Antigravity sorusu» başlığına yaz, en mantıklı varsayımla devam et.
- Meshy kurulumu için başka bir Cursor ajanı festive'e sonra birleşebilir; bekleme, çakışırsa ff pull ile al, force yok.

## Antigravity sorusu

(Sorularını buraya yaz.)

— Muharrir
