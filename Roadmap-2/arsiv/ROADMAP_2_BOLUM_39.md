# BÖLÜM 39 — Karar sonuçlarının görünürlüğü ve hafıza defteri

Faz 2–3 (Söz kaydı yazılır yazılmaz). Zemin:

- "Bu hatırlanacak" bildirimi DIY-14; kararın dönüşü DYL-08; beyan defteri DIY-07 (`src` yolu o maddede); sabah defteri SAB-01; kişi hafızası DIY-11 (`karakter_kadrosu.gd durumlar`); grup itibarı DIY-12.
- Gece raporu `src/sistemler/gece_bilancosu.gd`; son ekranı `ana.gd:125` dört sayı (gün, kabul, ret, nüfus); oda teftiş notu `oda_teftis_notu.gd`; muhafız epilogu `muhafiz_epilogu_sunumu.gd`.
- Kodda oyuncunun geçmiş kararlarını sayfa sayfa okuduğu tek bir hafıza defteri yoktur (`rg -i 'hafiza_defteri|karar_defteri'` src → 0; beyan defteri sorgu-içi ve DIY-07'nindir).

Bu bölüm kayıt alanlarını yeniden tanımlamaz. DIY-07, DIY-11, DIY-14, DYL-08, SAB-01 ve SOY-29'un yazdığı satırları tek okuma yüzeyinde toplar. Kalp puanı, romans, "ilişki barı" yok.

Kimlikler HFZ-01 … HFZ-32. OGR-10, SOY-29, HAN-21, OZL-03/11 bu çekirdeği (HFZ-01) bekler. Asset üretilmez; defter kabuğu ARY-02 temasını okur. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 39.1 Çekirdek — tek defter, dört sayfa

- [ ] **HFZ-01:** Hafıza defteri çekirdeği.
  - Ne: oyuncunun okuduğu tek defter. Sayfalar: Karar, Beyan, Söylenti, Not. Veri kaynağı mevcut kayıtlardır; defter ikinci bir olay günlüğü tutmaz.
  - Kabul: dört sayfa; sayfa verisi DIY-14 / DIY-07 / SOY-29 / OGR-10 okuyucusudur. Test: dört okuyucu, yazım 0 (defter yazmaz).
  - Bağımlılık: DIY-14, DIY-07. Boyut: M.
  - Dosya: yeni: `src/sistemler/hafiza_defteri.gd`; yeni: `src/arayuz/hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi. Kabuk ARY-02.
- [ ] **HFZ-02:** Defter kaydı optional alandır.
  - Ne: oyun kaydına `hafiza.okunan` (hangi satırlar görüldü) yazılır; satırların kendisi kaynak sistemlerindir. Eski kayıtta alan yoksa boş sayılır.
  - Kabul: alan silinmiş kayıt açılır, çökmez. Test: KAY birimi.
  - Bağımlılık: KAY-04, HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri.gd` `kaydet` / `yukle`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-03:** Defter oyunu durdurur, hızı değiştirmez.
  - Ne: açılınca `koy_ekrani` hızı saklanır (divan_baglantisi kalıbı: `divan_baglantisi.gd:16`); kapanınca aynı değere döner. `Engine.time_scale` defter kodunda yazılmaz.
  - Kabul: açıkken hız değişmez, kapandıktan sonra önceki hız. Test: hız 2'de aç/kapa.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-04:** Defter kapı ve köyde aynı dosyadır.
  - Ne: ikinci bir "kapı defteri" ekranı açılmaz; `kapi_ekrani.gd` sağdaki DEFTER dikdörtgeni (satır 13, `Rect2(1172, 104, 716, 952)`) sorgu defteridir, bu maddenin defteri değildir.
  - Kabul: sınıf adı `HafizaDefteriEkrani` bir kez. Test: tarama.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 39.2 Karar sayfası

- [ ] **HFZ-05:** Karar satırı DIY-14 ve DYL-08'dan gelir.
  - Ne: "Bu hatırlanacak" tetiklenen her seçim bir satır: kişi, gece, kısa sonuç (DYL-08 döndüğünde güncellenir). Metin DIY-14'ün notudur, burada yeniden yazılmaz.
  - Kabul: DIY-14 tetik 1 → satır 1; tetik 0 → satır 0. Test: iki sorgu.
  - Bağımlılık: DIY-14, DYL-08. Boyut: S.
  - Dosya: `hafiza_defteri.gd` okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-06:** Kapı kabul/ret her satır değildir.
  - Ne: her kabul/ret deftere düşmez; yalnız DIY-14 işaretlisi ve DYL-08 dönüşü. Aksi halde defter 30 günde okunmaz olur.
  - Kabul: 10 adsız kabul, DIY-14 yok → karar satırı 0. Test: on kabul.
  - Bağımlılık: HFZ-05. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-07:** Divan hükmü karar sayfasına bir satırdır.
  - Ne: CAS-07 hükmü (suçlu/değil, ceza) bir satır; SAB-01 sabah satırı ile aynı olay, iki kopya değil (SAB-01 okunur).
  - Kabul: bir hüküm → karar satırı 1, sabah kopyası 0. Test: hüküm.
  - Bağımlılık: CAS-07, SAB-01. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-08:** Omurga yüzü kararı işaretlenir.
  - Ne: OMR hat yüzü (sancak, tekfur, Moğol, oba) kararı DIY-14 listesine zaten giriyorsa satır "dış hat" etiketi alır; yeni sayaç yok.
  - Kabul: etiket metin, sayı değil. Test: bir yüz.
  - Bağımlılık: OMR-24, HFZ-05. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.

## 39.3 Beyan ve söylenti sayfaları

- [ ] **HFZ-09:** Beyan sayfası DIY-07 defteridir.
  - Ne: bu ziyaretin ve önceki ziyaretlerin beyan satırları; çelişki çifti (DYL-01) işaretli. DIY-07 veri modeli değişmez.
  - Kabul: sayfa DIY-07 kayıt sayısıyla eşit. Test: iki ziyaret.
  - Bağımlılık: DIY-07, DYL-01. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-10:** Söylenti sayfası SOY-29'dur.
  - Ne: canlı söylenti: olay, kaynak, kademe (birkaç / yarı köy / herkes), doğrulandı mı. Ağ kaydı SOY-01'indir.
  - Kabul: sayfa ağ kaydıyla eşit. Test: SOY-29 ile ortak.
  - Bağımlılık: SOY-29. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-11:** Not sayfası son beş ipucudur (OGR-10).
  - Ne: `ogretici.gorulen` son beş kimliğin metni; altıncı düşer.
  - Kabul: altı ipucu sonrası satır 5. Test: OGR-10 ile ortak.
  - Bağımlılık: OGR-10. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.
- [ ] **HFZ-12:** Eş duyumu not veya söylentiye düşer, üçüncü sayfa açmaz.
  - Ne: HAN-21 duyum satırı söylenti sayfasındadır (kaynak = eş); ayrı "Hane" sayfası yoktur.
  - Kabul: sayfa sayısı 4 kalır. Test: sayım.
  - Bağımlılık: HAN-21. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 39.4 Açılış ve gezinme

- [ ] **HFZ-13:** Köy HUD'dan açılır.
  - Ne: köy ekranında tek düğme / kısayol (GIR-03 adı); kapıda sorgu evresinde kapalıdır (sorgu defteriyle karışmasın).
  - Kabul: `evre == sohbet|karar` iken düğme 0; köyde 1. Test: iki ekran.
  - Bağımlılık: GIR-03. Boyut: S.
  - Dosya: `koy_ekrani.gd` tek satır; `kapi_ekrani.gd` çağrı 0.
  - Asset: asset gerekmedi.
- [ ] **HFZ-14:** Duraklat menüsünden açılır.
  - Ne: `ana.gd _duraklat` (satır 149) dördüncü satır "Defter"; mevcut üç satır (devam, ayarlar, menü) yerinde kalır.
  - Kabul: düğme sayısı 4; menüye dönüş 3. sırada kalır. Test: ekran.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `ana.gd` `_duraklat` tek satır.
  - Asset: asset gerekmedi.
- [ ] **HFZ-15:** Sayfa gezinmesi `ui_*` ve kısayoldur.
  - Ne: sekme veya 1–4 (GIR `kisayol_1…4`); `geri` kapatır (`ana.gd:240`).
  - Kabul: `geri` ile kapanır, odak ilk sayfadadır. Test: klavye.
  - Bağımlılık: GIR-01. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-16:** Boş sayfa metni vardır.
  - Ne: satır yokken "henüz bir şey yazılmadı" (`hafiza.bos.*`); pembe anahtar yok.
  - Kabul: yeni oyunda dört boş metin CSV'de. Test: `metin_dogrula.py`.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.

## 39.5 Filtre ve okunurluk

- [ ] **HFZ-17:** Satırlar geceden yeniye sıralanır.
  - Ne: varsayılan sıra `gece` azalan; kişi adına göre süzme tek alan.
  - Kabul: süzme sonrası yabancı kişi 0. Test: iki kişi.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `hafiza_defteri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-18:** Okunmuş satır soluk (AYR-10 ile aynı anahtar).
  - Ne: `okunmus_isaret` açıksa görülen satır soluk; kapalıysa hepsi aynı. AYR-10 Söz seçeneği içindir, bu madde defter satırı içindir, aynı ayar anahtarı.
  - Kabul: anahtar kapalıyken soluk 0. Test: iki ayar.
  - Bağımlılık: AYR-10. Boyut: S.
  - Dosya: `hafiza_defteri_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-19:** Metin ölçeği `ayarlar.boyut()` okur.
  - Ne: defter puntoları `tema.gd` + `metin_olcegi`; yerel punto yok.
  - Kabul: ölçek 150'de tarama yerel punto 0. Test: ARY-02 tarama.
  - Bağımlılık: ARY-02. Boyut: S.
  - Dosya: ekran.
  - Asset: asset gerekmedi.

## 39.6 Sabah ve yıl ile sınır

- [ ] **HFZ-20:** SAB-01 sabah satırı deftere kopyalanmaz.
  - Ne: sabah defteri SAB-01 ekranıdır; HFZ onu okur (HFZ-07) ama sabah akışını değiştirmez.
  - Kabul: sabah evresinde HFZ otomatik açılmaz. Test: gece sonu.
  - Bağımlılık: SAB-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-21:** YIL izi defter sayfası değildir.
  - Ne: yılın izi Bölüm 30'dadır; HFZ "mevsim özeti" sayfası açmaz.
  - Kabul: sayfa 4. Test: sayım.
  - Bağımlılık: YIL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-22:** Son ekranı defteri açmaz.
  - Ne: `ana.gd _son_goster` epilog + dört istatistiktir; defter son ekranına gömülmez. İstatistik genişlemesi SRM-08'dedir.
  - Kabul: son ekranında `HafizaDefteriEkrani` 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 39.7 Yazım

- [ ] **HFZ-23:** Satır başlığı kişi adıdır, sistem jargonu değildir.
  - Ne: "DIY-14 tetik" diye yazılmaz; "Hasan — üçüncü gece" yazılır. Anahtar `hafiza.satir.*`.
  - Kabul: oyuncu yüzünde `DIY-` / `HFZ-` 0. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-24:** Ölü / ayrılmış kişi adı çizilmez, satır kalır.
  - Ne: kişi köyden gittiyse ad "gitti" işaretli kalır; uydurma ad yok (BUG-17 kuralı).
  - Kabul: ölü id → ad mevcut kayıt adı, yeni ad 0. Test: ölüm sonrası defter.
  - Bağımlılık: BUG-17. Boyut: S.
  - Dosya: okuyucu.
  - Asset: asset gerekmedi.

## 39.8 Debug ve ölçüm

- [ ] **HFZ-25:** Debug satır enjektörü.
  - Ne: `src/debug/` ile sahte karar satırı; oyuncu sürümünde kapalı (SRM-05).
  - Kabul: debug kapalıyken enjektör 0. Test: tarama.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: yeni: `src/debug/hafiza_enjektoru.gd`.
  - Asset: asset gerekmedi.
- [ ] **HFZ-26:** Defter satır tavanı.
  - Ne: karar sayfası en çok 40 satır (öneri, `data/hafiza.json`); eski satır düşer, kaynak sistem kaydı silinmez.
  - Kabul: 41. satırda görünen 40. Test: enjekte.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `data/hafiza.json`.
  - Asset: asset gerekmedi.

## 39.9 Bağımlı okuyucular — bu bölüm yazmaz

- [ ] **HFZ-27:** OGR-10 yalnız okur.
  - Ne: ipucu kimliği `ipucu_kaydi.gd`'dedir; defter kopyalamaz.
  - Kabul: ipucu yazımı `hafiza_defteri.gd` içinde 0. Test: tarama.
  - Bağımlılık: OGR-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-28:** SOY-29 yalnız okur.
  - Ne: ağ kaydı `soylenti_agi.gd`'dedir.
  - Kabul: söylenti yazımı defterde 0. Test: tarama.
  - Bağımlılık: SOY-29. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-29:** OZL-03 yalnız okur.
  - Ne: kart seçimi olay kaydındadır.
  - Kabul: olay yazımı defterde 0. Test: tarama.
  - Bağımlılık: OZL-03. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 39.10 Sınırlar ve kapanış

- [ ] **HFZ-30:** İlişki barı, kalp, hediye yok.
  - Ne: karar kaydı yasağı; defter sayısal "sevgi" göstermez.
  - Kabul: `kalp|romans|hediye` anahtarı 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HFZ-31:** Çekirdek imzalar.
  - Ne: `oturum.gd`, `karakter_kadrosu.gd`, `kapi_ekrani.gd` değişmez; `ana.gd` yalnız `_duraklat` satırı.
  - Kabul: `api_sozlesmesi.py` farkı yalnız izinli satır. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: baseline.
  - Asset: asset gerekmedi.
- [ ] **HFZ-32:** Kapanış testi.
  - Ne: tek koşu: DIY-14 satırı → defter; boş yeni oyun dört boş sayfa; duraklat açar; kapıda kapalı; eski kayıt alan yok.
  - Kabul: beş iddia. Test: `tests/unit/sistemler/hafiza_defteri_test.gd`.
  - Bağımlılık: HFZ-01…31. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı üç ile dört arasındadır; onuncu madde DIY-07 veya DIY-14 kuralını ikinci kez yazacağı için konmadı. Toplam 32 madde.
