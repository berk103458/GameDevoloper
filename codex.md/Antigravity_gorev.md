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

