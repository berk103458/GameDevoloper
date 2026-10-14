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

