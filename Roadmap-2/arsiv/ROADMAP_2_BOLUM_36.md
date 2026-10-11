# BÖLÜM 36 — Muhafızın kişisel hayatı ve hane içi diyalog

Faz 2–3 (ACL-01…03 ve DYL-07 kapandıktan sonra; Söz motoru DIY-03 çalışır durumda). Zemin:

- Hane kuruluşu ACL-01 (tek ev, yatak 4, muhafız ve eş), eş ACL-02 (`src/koy/hane_esi.gd`, `data/hane_esi.json` meslek listesi: dokumacı/keçeci, ebe/şifacı, fırıncı/aşçı, bostancı, sütçü/yoğurtçu, yün eğirici; kâtiplik yalnız medrese geçmişinde), akşam sohbeti ACL-03 + DYL-07 (`src/koy/aksam_sohbeti.gd`, `data/soz/aksam_konulari.json`, eş hafızası DIY-11'in eş kaydı).
- Kodda hane, eş ve aile verisi yoktur (`rg -w 'hane|eşi'` → yalnız yorum). Var olan: muhafız maaşı `src/koy/muhafiz_maasi.gd` + `data/koy/muhafiz_maasi.json`; nöbet yorgunluğu `src/koy/nobet_yorgunlugu.gd` (UZM-14); cenaze yası `src/koy/cenaze_yasi.gd`; yaş rolleri `src/koy/yas_rolleri.gd` (çocuk/yetişkin/yaşlı); yaşam barları YSM-01…03 (Parça C); muhafız odası `src/dunya/muhafiz_odasi.gd`, vicdan `oda_vicdan_paneli.gd`, terazi `muhafiz_terazisi.gd`.
- Komşu bölümler: MCL-03 (eş meclis sözü), SAB-02 (hükümlünün hanesi), KAP-18 yetimler, SEV (köyde tekrar görme), Bölüm 37 söylenti.

Bu bölüm akşam sohbetini yeniden kurmaz. Hanenin günün geri kalanını yazar: sabah, sofra, eşin işi, misafir, muhafızın bedeni ve eve dönüşü, eşin yokluğu. Ahmet'in kararı bağlayıcıdır: kalp puanı, romans, hediye takvimi yok; eşin mesleği yalnız listeden; eş için ayrı bar açılmaz (YSM-01 köylü barıdır).

Kimlikler HAN-01 … HAN-52. Asset üretilmez; ocak görseli DYL-07 envanterindedir (`DYL07-OCAK`). Seslendirme yok. Yeni dosya + ince adaptör; `koy_ekrani.gd`, `oturum.gd`, `koy_nufusu.gd` değişmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 36.1 Hanenin kaydı ve günü

- [ ] **HAN-01:** Hane tek kayıt alanıdır.
  - Ne: `hane` sözlüğü: ev kimliği, üyeler (muhafız, eş, varsa misafir/yetim), ocak durumu, son sofra günü. Eşin kendi verisi `hane_esi.gd`'de kalır; hane onu okur.
  - Kabul: alan KAY zincirine optional girer; eski kayıtta yoksa ACL-01 kuruluşundan türetilir. Test: KAY birimi.
  - Bağımlılık: ACL-01, KAY-04. Boyut: S.
  - Dosya: yeni: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-02:** Hanenin günü dört andır.
  - Ne: sabah (kapıya çıkmadan), öğle (köy ekranında eş işte), akşam (ACL-03 sohbeti), gece (uyku YSM-03). Yalnız sabah bu bölümün yeni anıdır; diğer üçü var olan sistemlere bağlanır.
  - Kabul: `hane.gd` dört an için dört kanca; sabah dışındakiler mevcut çağrıya tek satırla bağlanır. Test: bir gün dört kanca.
  - Bağımlılık: HAN-01, ACL-03, YSM-03. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-03:** Sabah satırı — eşin tek cümlesi.
  - Ne: kapı açılmadan eş bir cümle söyler: dünkü sohbetin kalıntısı, bugünün havası (`mevsim_yoneticisi`), ambar (`kaynaklar.gd`) ya da köyde duyduğu (HAN-25). Pencere değil, HUD'da tek satır; Söz motoru dalı değil, bağlam sorgusu (DIY-09) seçimli satırdır.
  - Kabul: günde en çok 1; eş ölüyse 0; satır `sohbet.es.sabah.*` anahtarlı ve ≤ 100 karakter. Test: üç durum.
  - Bağımlılık: HAN-02, DIY-09, DIY-10. Boyut: S.
  - Dosya: yeni: `src/koy/sabah_satiri.gd`; yeni: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-04:** Sabah satırı akşam sohbetini tekrarlamaz.
  - Ne: akşam konuşulan konu (`aksam_sohbeti` kaydı) sabah satırında aynı anahtarla gelmez; sabah yalnız "kalıntı" biçimini kullanır ("Dün dediğin aklımda.").
  - Kabul: aynı konu kimliği iki yerde 0. Test: sohbet + sabah.
  - Bağımlılık: HAN-03, DYL-07. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-05:** Sofra günü.
  - Ne: `takvim.hafta_basi` gecesinde hane sofra kurar: ambardan `1 gida` düşer (`tuketim_dengesi.json` üstüne değil, mevcut hane tüketiminin içinden), muhafız moral +1 (YSM-01 köylü barı mantığında muhafızın kendi değeri). Sofra satırı gece raporuna girer.
  - Kabul: hafta başı sofra 1; ambar 0 ise sofra olmaz, satır "boş sofra". Test: iki ambar durumu.
  - Bağımlılık: HAN-01, MEV-01. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-06:** Hane olayları tek günlükte.
  - Ne: sabah satırı, sofra, misafir, yas gibi hane olayları Bölüm 39 defterinin "Hane" sayfasına yazılır.
  - Kabul: her hane olayı bir satır. Test: defter sayfası.
  - Bağımlılık: HFZ-01. Boyut: S.
  - Dosya: `src/koy/hane.gd` → defter adaptörü.
  - Asset: asset gerekmedi.

## 36.2 Eşin işi ve hane ekonomisi

- [ ] **HAN-07:** Eşin işi köy üretimine girer.
  - Ne: ACL-02 meslekleri üretim zincirine (`src/koy/uretim.gd`, `meslek_yapilari.gd`) ince adaptörle bağlanır: ebe → şifahane triyajına +1 kontenjan (`sifahane_kontenjani.gd`), fırıncı → ekmek (`esya_idleri` içinde `ekmek`), dokumacı → kumaş, bostancı → gıda, sütçü → gıda, yün eğirici → kumaş zinciri girdisi.
  - Kabul: her meslek bir çıktı; `hane_esi.json` içinde `uretim` alanı. Test: altı meslek altı çıktı.
  - Bağımlılık: ACL-02. Boyut: M.
  - Dosya: yeni: `src/koy/es_uretimi.gd`; `hane_esi.json` alanı.
  - Asset: asset gerekmedi.
- [ ] **HAN-08:** Eşin işi atama alanında görünür.
  - Ne: `koy_atama_alani.gd` listesinde eş kendi satırında, mesleği ve bugünkü çıktısı yazılı; sürüklenemez (ACL-02 kural 1).
  - Kabul: eş kartı sürükleme kulpu 0. Test: ekran.
  - Bağımlılık: HAN-07. Boyut: S.
  - Dosya: `koylu_karti.gd` adaptörü (ACL-02'de var) tek alan.
  - Asset: asset gerekmedi.
- [ ] **HAN-09:** Muhafız maaşı haneye düşer.
  - Ne: `muhafiz_maasi.gd` maaşı köy kasasından ayrı "hane kesesi"ne yazılır; hane kesesi yalnız HAN maddelerinde harcanır (misafir yemeği, yas). Çift kasa (EKO-01) dokunulmaz.
  - Kabul: maaş günü hane kesesi artar, köy kasası eski kuralla değişir. Test: maaş günü.
  - Bağımlılık: HAN-01. Boyut: S.
  - Dosya: `src/koy/hane.gd` `kese`.
  - Asset: asset gerekmedi.
- [ ] **HAN-10:** Eş kazancı hane kesesine değil köye.
  - Ne: eşin üretimi köy ambarına gider; hane kesesine akçe yazmaz. Madde sınır koyar: hane ayrı ekonomi değildir.
  - Kabul: `es_uretimi.gd` içinde `kese` yazımı 0. Test: tarama.
  - Bağımlılık: HAN-07, HAN-09. Boyut: S.
  - Dosya: `src/koy/es_uretimi.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-11:** Eşin meslek değişimi akşam sohbetinde geçer.
  - Ne: ACL-02 kural 4'teki meslek değişimi oyuncu kararıyla kartta yapılır; eş o akşam bunu bir konu olarak alır (`aksam_konulari.json` ağırlık 2, öneri).
  - Kabul: değişim gecesi konu adayı 1. Test: değişim.
  - Bağımlılık: DYL-07. Boyut: S.
  - Dosya: `data/soz/aksam_konulari.json` satırı.
  - Asset: asset gerekmedi.

## 36.3 Hane misafiri

- [ ] **HAN-12:** Kapıdan gelen bir gece hanede kalabilir.
  - Ne: köyde yatak yoksa (ACL-05 sınırı) kabul edilen kişi bir geceliğine hanenin boş yatağında kalır (ACL-01 yatak 4: iki boş). Oyuncu kararı sorgu sonunda tek seçenek: "bu gece bizde".
  - Kabul: boş hane yatağı varken seçenek 1, yokken 0; misafir ertesi sabah köy listesine düşer. Test: iki durum.
  - Bağımlılık: ACL-05, HAN-01. Boyut: M.
  - Dosya: yeni: `src/koy/hane_misafiri.gd`; kapı karar adaptörüne tek seçenek.
  - Asset: asset gerekmedi.
- [ ] **HAN-13:** Misafir eşle konuşur.
  - Ne: misafir gecesi akşam sohbeti (ACL-03) üç ağızlı olur: eş, misafir, muhafız. Misafirin repliği kendi Söz dosyasından (kişi hafızası DIY-11 kaydı) tek dal.
  - Kabul: misafir gecesi sohbet katılımcı 3. Test: misafir.
  - Bağımlılık: HAN-12, DYL-07, DIY-11. Boyut: S.
  - Dosya: `src/koy/aksam_sohbeti.gd` tek satır; misafir dalı Söz dosyasında.
  - Asset: asset gerekmedi.
- [ ] **HAN-14:** Misafir bir şey bırakır.
  - Ne: misafir sabah giderken heybesinden bir eşya (`esya_idleri`) ya da bir haber (Bölüm 37) bırakabilir; olasılık `data/hane.json`.
  - Kabul: 100 misafirde bırakma oranı tabloya ±%5. Test: simülasyon.
  - Bağımlılık: HAN-12, SOY-03. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-15:** Misafir çalabilir.
  - Ne: `yalan_olasiligi` (oyun.tres 0.35) tabanlı küçük olasılıkla misafir hane kesesinden akçe götürür; sabah satırı bunu söyler. Hırsızlık olayı (`hirsizlik.tres`) yeniden kurulmaz; bu hanenin kendi satırıdır.
  - Kabul: çalma olasılığı tabloda; çalınca kese düşer, defter satırı yazılır. Test: enjekte.
  - Bağımlılık: HAN-09, HAN-12. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-16:** Yetim hanede kalabilir.
  - Ne: KAP-18 yetimi oyuncu haneye alabilir; hane üyesi olur, yaş rolü `cocuk` (`yas_rolleri.gd`), işe atanmaz, ambardan köylü tüketimi düşer. Evlat edinme töreni, ad verme ve ilişki sayacı yoktur.
  - Kabul: hanede en çok 2 yetim (boş yatak); yetim köy listesinde `hane` etiketiyle. Test: üçüncü yetim reddedilir.
  - Bağımlılık: KAP-18, HAN-01. Boyut: M.
  - Dosya: `src/koy/hane.gd` `uye_ekle`.
  - Asset: asset gerekmedi.
- [ ] **HAN-17:** Hanedeki çocuk büyür.
  - Ne: `yas_rolleri` çocuk → yetişkin geçişi (R1 kuralı) hanedeki yetimde de işler; yetişkin olunca haneden çıkar, köylü olur, bir sabah satırı alır.
  - Kabul: geçiş gününde hane üyesi −1, köylü +1. Test: zaman makinesi.
  - Bağımlılık: HAN-16. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.

## 36.4 Eşin gözü — köyde duyulan

- [ ] **HAN-18:** Eş günde bir şey duyar.
  - Ne: DYL-07 kural 4'ün köy tarafı: eşin mesleğine göre bir kaynak (ebe → hastalar, fırıncı → ambar ve kuyruk, dokumacı → kadınlar arası söz, bostancı → tarla, sütçü → ağıl, yün eğirici → pazar) günde en çok bir "duyum" üretir. Duyum Bölüm 37 söylenti ağına bir düğüm olarak girer.
  - Kabul: günde ≤ 1 duyum; kaynak mesleğe bağlı tabloda. Test: altı meslek.
  - Bağımlılık: SOY-02, ACL-02. Boyut: M.
  - Dosya: yeni: `src/koy/es_duyumu.gd`; `data/hane.json` tablo.
  - Asset: asset gerekmedi.
- [ ] **HAN-19:** Duyum akşam ya da sabah söylenir.
  - Ne: duyum ağır karar yoksa akşam sohbetinin gündelik satırı, ağır karar varsa ertesi sabah satırı olur. İki yerde birden gelmez.
  - Kabul: aynı duyum kimliği bir kez. Test: iki gece.
  - Bağımlılık: HAN-03, HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-20:** Duyum yanlış olabilir.
  - Ne: duyumun doğruluk oranı Bölüm 37 kuralına bağlıdır; eş kendi kaynağını söyler ("Fatma dedi"). Oyuncu doğrulamadan kullanırsa sonucu üstlenir.
  - Kabul: yanlış duyum oranı SOY tablosundan. Test: simülasyon.
  - Bağımlılık: SOY-05. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-21:** Duyum ertesi günün sorgusunda ipucu olur.
  - Ne: duyum bir kapı ziyaretçisini anıyorsa (`durumlar[id]`), o kişinin sorgusunda bağlam sorgusu (DIY-09) `es_duyumu` anahtarını açar; muhafız "Eşim seni anlattı" diyebilir (DYL-01 çelişki yolu).
  - Kabul: duyumlu kişide dal 1, duyumsuzda 0. Test: iki ziyaret.
  - Bağımlılık: HAN-18, DIY-09, DYL-01. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd` → bağlam sözlüğüne tek anahtar.
  - Asset: asset gerekmedi.
- [ ] **HAN-22:** Eşin söylediği defterde kaynaklıdır.
  - Ne: Bölüm 39 defterinde duyum satırı "eş, kaynak, gün" ile yazılır; doğrulanınca işaretlenir.
  - Kabul: defter satırında üç alan. Test: defter.
  - Bağımlılık: HFZ-01, HAN-18. Boyut: S.
  - Dosya: defter adaptörü.
  - Asset: asset gerekmedi.

## 36.5 Muhafızın bedeni

- [ ] **HAN-23:** Muhafızın uykusu nöbet yorgunluğuna bağlıdır.
  - Ne: `nobet_yorgunlugu.gd` (UZM-14) değeri muhafızın kendisine de uygulanır: oyuncu gece nöbeti kendisi tutarsa (NBT-09) ertesi gün yorgunluk; evde uyursa sıfırlanır. Yeni bar açılmaz; UZM-14 değeri okunur.
  - Kabul: kendi nöbetinde yorgunluk +1, evde uyku sonrası 0. Test: iki gece.
  - Bağımlılık: NBT-09, UZM-14. Boyut: S.
  - Dosya: yeni: `src/koy/muhafiz_bedeni.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-24:** Yorgun muhafızın zarı.
  - Ne: yorgunluk ≥ 2 iken görünür zar değiştiricisi −1 (ZAR-04 yaklaşım değiştiricileri tablosuna bir satır). Oyuncu zar panelinde "yorgun" etiketini görür.
  - Kabul: değiştirici tabloda; yorgunluk 0'da 0. Test: iki durum.
  - Bağımlılık: ZAR-04, HAN-23. Boyut: S.
  - Dosya: ZAR-04 değiştirici tablosu satırı.
  - Asset: asset gerekmedi.
- [ ] **HAN-25:** Muhafız hastalanabilir.
  - Ne: salgın (`saglik_yoneticisi.gd`, `kis_hastaligi.gd`) muhafızı da aday sayar; hastaysa gün kapıda `azami_soru` −1 ve eş ebe ise iyileşme 1 gün erken. Yeni hastalık sistemi yok.
  - Kabul: hasta muhafızda soru hakkı 3; ebe eşle süre −1. Test: enjekte hastalık.
  - Bağımlılık: HAN-07, KRI. Boyut: S.
  - Dosya: `src/koy/muhafiz_bedeni.gd`; sağlık yöneticisine tek satır (aday listesi).
  - Asset: asset gerekmedi.
- [ ] **HAN-26:** Kavgada yaralanan muhafız.
  - Ne: CAT-03 yaralının tedavisi muhafıza da uygulanır; yaralıyken heybe araması yapılamaz (eğilemez), hekim yoksa 2 gün.
  - Kabul: yaralı muhafızda arama düğmesi 0. Test: CAT-01 sonrası.
  - Bağımlılık: CAT-03. Boyut: S.
  - Dosya: `src/koy/muhafiz_bedeni.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-27:** Beden durumu HUD'da tek simgedir.
  - Ne: yorgun/hasta/yaralı üç durum kapı HUD'unda tek satırlık etiket; bar değil.
  - Kabul: durum yokken etiket 0. Test: ekran.
  - Bağımlılık: HAN-23…26. Boyut: S.
  - Dosya: yeni: `src/arayuz/kapi/beden_etiketi.gd`.
  - Asset: asset gerekmedi.

## 36.6 Eve dönüş ve vicdan

- [ ] **HAN-28:** Eve dönüş anı.
  - Ne: kapı günü bitince (`ana.gd` köy geçişi, `oturum_fazi.gd`) kısa bir "eve dönüş" satırı: günün en ağır kararının tek cümlelik yankısı (DYL-07 ağırlık tablosundan en yüksek). Sohbet değil, geçiş satırı.
  - Kabul: ağır karar varsa satır 1, yoksa 0. Test: iki gün.
  - Bağımlılık: DYL-07, HAN-02. Boyut: S.
  - Dosya: yeni: `src/koy/eve_donus.gd`; faz geçişine tek satır.
  - Asset: asset gerekmedi.
- [ ] **HAN-29:** Eşin terazi görüşü.
  - Ne: muhafız terazisi (`muhafiz_terazisi.gd`) kademe değiştirince eş bunu akşam sohbetinde bir konu olarak alır (ağırlık 4, öneri). Eş teraziyi "yozlaşma" diye değil kendi diliyle söyler (USLUP).
  - Kabul: kademe değişim gecesi konu adayı 1. Test: enjekte terazi.
  - Bağımlılık: DYL-07, ODA-12. Boyut: S.
  - Dosya: `data/soz/aksam_konulari.json` satırı.
  - Asset: asset gerekmedi.
- [ ] **HAN-30:** Vicdan paneli eşin sözünü hatırlar.
  - Ne: `oda_vicdan_paneli.gd` son üç akşam sohbetinin eş cümlesini gösterir (DIY-11 eş kaydından). Yeni kayıt yok.
  - Kabul: panelde ≤ 3 satır. Test: ekran.
  - Bağımlılık: DYL-07. Boyut: S.
  - Dosya: yeni: `src/arayuz/oda_es_sozu.gd`; vicdan paneline tek satır.
  - Asset: asset gerekmedi.
- [ ] **HAN-31:** Rüşvet eve girmez.
  - Ne: rüşvet akçesi (`rusvet_akce`) hane kesesine değil muhafızın gizli kasasına (ODA kasa, `oda_kasasi_paneli.gd`) gider. Eş fark ederse (olasılık terazi kademesine bağlı) konu olur.
  - Kabul: rüşvet sonrası hane kesesi değişmez; fark olasılığı tabloda. Test: rüşvet.
  - Bağımlılık: ODA-04, HAN-09. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-32:** Susmak da kaydedilir.
  - Ne: DYL-07 kural 6 "kaçtı" kaydı üst üste üç gece olursa sabah satırı bunu söyler; ceza yok.
  - Kabul: üç "kaçtı" sonrası sabah satırı 1. Test: üç gece.
  - Bağımlılık: DYL-07, HAN-03. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.

## 36.7 Hane ve köy

- [ ] **HAN-33:** Komşu hane.
  - Ne: köyde ev sayısı ≥ 2 olunca en yakın ev "komşu" etiketlenir (`izgara.gd` komşuluğu). Komşu hanenin bir üyesi eşin duyum kaynaklarına eklenir.
  - Kabul: komşu 1, ev yoksa 0. Test: iki harita.
  - Bağımlılık: HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-34:** Eş çınarda söz alır (MCL-03'ün hane tarafı).
  - Ne: eş meclis sözü aldığı gece akşam sohbeti yerine meclis repliği gelir; iki sahne üst üste binmez.
  - Kabul: meclis gecesi akşam sohbeti 0. Test: MCL gecesi.
  - Bağımlılık: MCL-03, ACL-03. Boyut: S.
  - Dosya: `src/koy/aksam_sohbeti.gd` tek koşul.
  - Asset: asset gerekmedi.
- [ ] **HAN-35:** Hükümlünün hanesi eşin gözündedir (SAB-02 ile bağ).
  - Ne: SAB-02 "evde kalanlar" eşin duyum kaynağına girer; eş ebe ya da dokumacıysa hükümlünün eşini anar.
  - Kabul: SAB-02 kaydı varken duyum adayı 1. Test: hüküm sonrası.
  - Bağımlılık: SAB-02, HAN-18. Boyut: S.
  - Dosya: `src/koy/es_duyumu.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-36:** Cenaze yası haneye de düşer.
  - Ne: `cenaze_yasi.gd` köy yası haneyi de kapsar: cenaze günü sofra kurulmaz (HAN-05), sabah satırı yas cümlesi.
  - Kabul: cenaze haftasında sofra 0. Test: cenaze.
  - Bağımlılık: KRI-05, HAN-05. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-37:** Sevilen yüz haneye uğrar (SEV-02 ile bağ).
  - Ne: SEV-02 ateşe gelen tanıdık yüz, boş günde (KAP-16) hanenin ocağına da gelebilir; o gece HAN-13 üç ağızlı sohbet olur.
  - Kabul: boş günde SEV-02 kişisi varsa misafir seçeneği 1. Test: boş gün.
  - Bağımlılık: SEV-02, HAN-13. Boyut: S.
  - Dosya: `src/koy/hane_misafiri.gd`.
  - Asset: asset gerekmedi.

## 36.8 Eşin yokluğu

- [ ] **HAN-38:** Eş ölünce hane susar.
  - Ne: ACL-02 kural 5 ağır yas: akşam sohbeti, sabah satırı ve duyum kapanır; sofra kurulmaz; hane sayfasında tek satır yas. Yeni son yok.
  - Kabul: ölüm sonrası dört kanca 0. Test: ölüm enjeksiyonu.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-39:** Yas süresi sonrası tek satır.
  - Ne: 7 gün (öneri; `cenaze_yasi.gd` süresiyle aynı) sonra sabah satırı yerine muhafızın kendi tek cümlesi gelir (ACL-06 geçmişine göre). Yeni eş, evlilik, romans yoktur.
  - Kabul: yas sonrası satır muhafızın; `hane_esi` alanı boş kalır. Test: 8. gün.
  - Bağımlılık: HAN-38. Boyut: S.
  - Dosya: `src/koy/sabah_satiri.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-40:** Eş kaçırılabilir ya da hastalanabilir, ölmeden.
  - Ne: çete baskını (`husumet_baskini.gd`) ve salgın eşi geçici alabilir: hasta eş 3 gün sohbet etmez, duyum vermez; "kaçırılma" yoktur (yeni hat açılmaz), yalnız hastalık.
  - Kabul: hasta eşte üç kanca 0, iyileşince döner. Test: enjekte.
  - Bağımlılık: KRI, HAN-02. Boyut: S.
  - Dosya: `src/koy/hane.gd`.
  - Asset: asset gerekmedi.
- [ ] **HAN-41:** Eşin ölümü omurgaya yansır.
  - Ne: eş ölümü `uc_tutundu` sonunun yüzünü (OMR-15) kaldırır; epilog ağır yas dalıyla gelir (ACL-02 kural 5).
  - Kabul: eş ölüyken `uc_tutundu` yüzü 0, epilog dalı 1. Test: son.
  - Bağımlılık: OMR-15. Boyut: S.
  - Dosya: `data/omurga.json`.
  - Asset: asset gerekmedi.

## 36.9 Yazım ve ses kartı

- [ ] **HAN-42:** Eşin ses kartı tek kaynaktır.
  - Ne: YAZ-03 ses kartı eş için meslek varyantlarını da kapsar; sabah satırı, duyum, misafir sohbeti aynı karttan yazılır.
  - Kabul: kartta altı meslek için altı "ağız notu". Test: kart.
  - Bağımlılık: YAZ-03. Boyut: S.
  - Dosya: YAZ-03 kart dosyası.
  - Asset: asset gerekmedi.
- [ ] **HAN-43:** Sabah satırı havuzu.
  - Ne: 6 meslek × 4 kaynak (hava, ambar, duyum, kalıntı) × 2 varyant = 48 satır (öneri); hepsi USLUP §7 denetiminden geçer.
  - Kabul: `sabah_satirlari.json` ≥ 48 satır; yapaylık taraması 0 ihlal. Test: tarama.
  - Bağımlılık: HAN-03, YAZ-10. Boyut: M.
  - Dosya: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-44:** Hitap kuralı.
  - Ne: eş muhafıza adıyla değil USLUP §3 hitap türlerinden biriyle seslenir; hitap ACL-06 geçmişine göre seçilir ve değişmez.
  - Kabul: eş satırlarında muhafız adı 0. Test: tarama.
  - Bağımlılık: YAZ-02. Boyut: S.
  - Dosya: `data/soz/sabah_satirlari.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-45:** Kör okuma testi eşi kapsar.
  - Ne: DYL-11 kör okuma setine eşin satırları girer; eş ile diğer kadın karakterler ayrışmalı.
  - Kabul: eş doğru tanıma ≥ %70 (öneri). Test: DYL-11.
  - Bağımlılık: DYL-11. Boyut: S.
  - Dosya: DYL-11 test seti.
  - Asset: asset gerekmedi.
- [ ] **HAN-46:** Çocuk ağzı ayrıdır.
  - Ne: hanedeki yetimin tek satırları (sabah, veda) çocuk ağzıyla; USLUP yaş kuralı.
  - Kabul: çocuk satırlarında yetişkin kalıbı 0. Test: inceleme.
  - Bağımlılık: HAN-16, YAZ-02. Boyut: S.
  - Dosya: `data/soz/sabah_satirlari.json` çocuk bölümü.
  - Asset: asset gerekmedi.

## 36.10 Sınırlar ve kapanış

- [ ] **HAN-47:** Kalp puanı, romans, hediye yok.
  - Ne: hane sözlüğünde `sevgi`, `kalp`, `hediye`, `iliski` anahtarı yoktur; eş morali YSM-01 köylü barıdır.
  - Kabul: `rg -i 'kalp|hediye|romans|iliski' src/koy/hane*.gd` → 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/godot_script_taramasi.py` tek kural.
  - Asset: asset gerekmedi.
- [ ] **HAN-48:** Eşin mesleği yalnız listeden.
  - Ne: ACL-02 listesi tek kaynaktır; bu bölüm liste eklemez.
  - Kabul: `hane_esi.json` meslek sayısı ACL-02 ile aynı (6 + kâtip). Test: sayım.
  - Bağımlılık: ACL-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HAN-49:** Eş için ikinci oynanabilir gövde yok.
  - Ne: oyuncu eşi yönetmez; eş sürüklenmez, kapıya gitmez (ACL-01 uç durum).
  - Kabul: eşte `yuru()` çağrısı yalnız rutin (`koy_halk_hareketi`). Test: tarama.
  - Bağımlılık: ACL-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HAN-50:** Hane sahnesi yoktur.
  - Ne: ev içi 3B sahne, oda kamerası veya ayrı ekran açılmaz; hane HUD satırı ve akşam kadrajıdır (DYL-07 `DYL07-OCAK`).
  - Kabul: `hane_sahnesi`, `ev_ici` adlı sahne 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **HAN-51:** Çekirdek imzalar.
  - Ne: `koy_nufusu.gd`, `oturum.gd`, `koy_ekrani.gd` değişmez; hane kancaları adaptördür.
  - Kabul: `api_sozlesmesi.py` farkı 0. Test: araç.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tools/api_sozlesmesi_baseline.json`.
  - Asset: asset gerekmedi.
- [ ] **HAN-52:** Kapanış testi.
  - Ne: tek koşu: üç gün hane döngüsü (sabah satırı, iş çıktısı, sofra, misafir, duyum → ipucu), eş ölümü sonrası dört kanca 0, kayıt KAY zincirinden geçer.
  - Kabul: üç iddia tek testte. Test: `tests/unit/koy/hane_test.gd`.
  - Bağımlılık: HAN-01…51. Boyut: M.
  - Dosya: yeni: `tests/unit/koy/hane_test.gd`.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı dört ile altı arasındadır; onuncu madde her yerde ACL-02/03 ya da DYL-07'de duran bir kuralı ikinci kez yazacağı için konmadı. Toplam 52 madde.
