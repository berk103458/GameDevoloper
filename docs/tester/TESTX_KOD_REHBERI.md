# testx Kod Rehberi — ROADMAP 2'de kod yazmak

**testx** = EVREN üzerinde çalışan DeepSeek ajanı (eski adıyla "Tester"). 11 Ekim 2026'dan itibaren iki işi birlikte yaparsın:

1. **Kod:** ROADMAP 2 maddelerini uygularsın. **12 Ekim 2026'dan itibaren Codex durduruldu; kod tarafında tek uygulayıcı sensin** (Kalfa ayrı ajandır, Faz 0'da). Claude sana madde verir; yazarsın, test yazarsın, hedefli testleri koşarsın, teslim edersin; tam sanity'yi Claude koşar.
2. **Oyun:** Yazılan her şeyi (seninki, Codex'inki, Kalfa'nınki) oyunda **canavar gibi** test edersin. `TESTER_REHBERI.md` §10–§14 aynen geçerlidir.

Yöneten Claude'dur. Bu rehber `AGENTS.md`'nin altındadır; çelişirse `AGENTS.md` geçerlidir.

---

## 1. İş akışı (her madde)

```
Claude: maddeyi seçer → ROADMAP_2.md'de "[/] (testx)" yapar → push
        → ~/.codex-tester/gorev.md'ye görevi yazar
testx:  kopyan GitHub'dan güncellenmiş gelir → gorev.md'yi oku → maddenin tam metnini (Amaç, Kurallar,
        Uç durumlar, Kabul, Bağımlılık, Dosya, Asset) ROADMAP_2.md'den oku → bağımlı maddeleri ve
        ROADMAP 1'deki ilgili sistemi (ROADMAP.md + design/gdd/) oku → kodu yaz → testleri yaz →
        ETKİLENEN TEST TARAMASI (aşağıda) → hedefli testleri koş → work/testx/teslim.json yaz
Claude: diff'i inceler → kendi sanity'sini koşar → commit "(testx)" → [x] (testx) → push
        → sorun varsa gorev.md'ye "DÜZELT:" notu yazar, sen düzeltirsin
```

- **Sen git commit/push yapamazsın** (sandbox). Bu normal; yayını Claude yapar.
- **Başka ajanın `[/]` maddesine dokunmazsın.** Kalfa Faz 0'da çalışıyor; Codex de ayrı maddeler alır. Yalnız `gorev.md`'de sana verilen madde.
- **Kapsamı genişletmezsin.** Maddede yazmayan özellik yok. "Şunu da ekleyeyim" yok; gerekiyorsa `teslim.json` → `oneriler` alanına yaz.
- **Silme ve geri dönüşü zor değişiklikler (TEK-02 dersi, 11 Ekim):** maddenin "Ne" ve "Dosya" alanında yazılanın dışındaki hiçbir dosyayı silme. "Kaynağı yok" ≠ "kullanılmıyor": TEK-02'de 226 `.import` silindi, 182'si Godot önbelleğine yönlendiren dosyalardı; `kapi.glb` yüklenemedi ve kapı sahnesi çöktü. Silmeden önce ve sonra en az bir gerçek oyun akış testi (ör. `tests/oto/oyun_koprusu_kontrol.tscn`) koş; farkı `teslim.json`'a yaz.
- **Etkilenen test taraması (TEK-07 dersi, 12 Ekim):** bir fonksiyonun/sınıfın **davranışını** değiştirdiysen (ör. `KrizEnjektoru.gece` artık herkese `hasta` vermiyor), eski davranışı bekleyen testler kırılır. Teslimden önce değiştirdiğin her sınıf/fonksiyon adını `rg -n "<Ad>" tests/` ile ara ve çıkan **bütün** testleri koş. TEK-07'de bu yapılmadı; `saglik_yoneticisi_test` yalnız Claude'un tam sanity'sinde yakalandı. Eskiyen bir iddiayı bulursan testi silme/gevşetme: iddianın korumak istediği **kuralı** bul ve onu yeni davranışla sınayacak şekilde güncelle; gerekçeyi `teslim.json` → `notlar`'a yaz.
- Belirsizlik: önce maddenin "Uç durumlar"ı, sonra `design/gdd/`, sonra `ROADMAP.md`. Hâlâ belirsizse **varsayım yapma**, `teslim.json` → `sorular` alanına yaz ve o kısmı yazmadan bırak.

### teslim.json (zorunlu, EN SON adım)
```json
{"madde": "BUG-19", "durum": "bitti",
 "dosyalar": ["src/kapi/sira_kisi_adaptoru.gd", "data/sira_kisi.json", "tests/unit/kapi/sira_kisi_test.gd"],
 "cekirdek_degisiklik": {"src/arayuz/kapi_ekrani.gd": "2 satır: preload + çağrı"},
 "testler": {"sira_kisi_test": "GEÇTİ", "sira_atlama_kontrol": "GEÇTİ"},
 "sanity": "Sanity: 0 failed (331 PASS)",
 "kabul_kontrol": ["Kabul iddia 1 → test X satır Y", "..."],
 "sorular": [], "oneriler": [], "asset": "asset gerekmedi"}
```
`durum`: `bitti` | `yarim` (neden yarım kaldığını `notlar`'a yaz). Erken `durum: "yarim"` ile yaz, sonda güncelle (tur koparsa iş kaybolmaz).

---

## 2. Mimari kuralları (ihlal = teslim reddi)

- **Yeni özellik = yeni dosya + ince adaptör.** Mantık yeni dosyada (`src/koy/…`, `src/kapi/…`, `src/sistemler/…`). Mevcut dosyaya yalnız 1–3 satırlık bağlantı: `const X := preload("res://…")` + çağrı. Dosyayı baştan yazmak yasak.
- **Korumalı çekirdek dosyalar** (`AGENTS.md` §2): `ana.gd`, `koy_ekrani.gd`, `tema.gd`, `hud.gd`, `karakter_model.gd`, `koy_yonetim_sahnesi.gd`, `oturum.gd`, `ses.gd`, `koy_nufusu.gd`, `guvenli_kayit.gd`, `metinler.csv`, `otomatik_oyuncu.gd`. Bunlara dokunacaksan **en az satır**, ve `teslim.json` → `cekirdek_degisiklik`'te satır satır gerekçe.
- **Yasaklar:** `koy_sahnesi` / statik `KoyYerlesimi` geri getirilmez; yeni autoload eklenmez; `project.godot` değişmez; ROADMAP 1 sistemi yeniden yazılmaz (adaptörle okunur); aynı `class_name` iki anlam taşımaz.
- **Veri koddan ayrı:** sayılar `data/…json` ya da `.tres`'te; kodda sabit denge sayısı yok (maddeler bunu sık şart koşar: "kod sabiti değildir").
- **Metin:** oyuncunun gördüğü her cümle `data/metin/metinler.csv` anahtarıdır; kodda düz Türkçe cümle yok. CSV'ye yalnız **anahtar bazlı satır ekleme** (dosyayı yeniden yazma). Anahtar biçimi: noktalı küçük harf (`koy.kaynak.tomruk`). Ekledikten sonra `python -B tools/metin_dogrula.py`.
- **Kayıt uyumu:** kayda yeni alan **isteğe bağlı** (optional) eklenir; eski kayıtta alan yoksa varsayılanla açılır, çökmez, uydurma değer üretmez. Her yeni kayıt alanı için "eski kayıt" testi yaz. `KAYIT_SURUMU` değişmez.
- **Gece raporu satırı:** `IflasYoneticisi.olay_metin` ile, olay **Dictionary** olarak.
- **Rastgelelik:** `Oturum`/`KoyYonetimi`'nin tohumlu RNG'si; `randf()` / `randi()` (genel RNG) oyun mantığında yasak — aynı tohum aynı sonucu vermeli (maddeler "ikiz/aynı tohum" testi ister).
- **Asset:** **Asset kuralı (Berk, 11 Ekim 2026):** (1) Asset **üretilmez** (yapay zekâ ile görsel/ses/model/doku üretmek, script ile sentezlemek yok). (2) İnternette oyunumuza **uygun ve lisansı açık** bir asset bulunursa eklenebilir: yalnız CC0 / kamu malı ya da atıfla serbest (CC-BY) lisanslar; kaynak bağlantısı, yazar ve lisans `docs/EKSIK_ASSET_ENVANTERI.md`'deki ilgili satıra yazılır (atıf gerektiren lisansta atıf metni de). Ticari kullanımı yasak, belirsiz ya da "yalnız kişisel" lisanslı asset alınmaz; lisansı doğrulayamıyorsan alma. Dönem ve üsluba uymayan (modern, çizgi film, uyumsuz stil) asset alınmaz. (3) Uygun asset bulunamazsa yer tutucu kullanılır (3B: düz renk `BoxMesh`/`CapsuleMesh`; 2B: düz renk kutu) ve **oyunda kısa bir isim etiketiyle görünür**; gereken asset `docs/EKSIK_ASSET_ENVANTERI.md`'ye (madde, ad, tür, yer tutucu yolu, TR+EN arama kelimeleri, öncelik, ekleyen) yazılır. Yer tutucu tek yerden değiştirilebilir kurulur. Asset gerekmiyorsa `teslim.json` → `"asset": "asset gerekmedi"`; eklediysen `"asset": "eklendi: <ad> · <lisans> · <kaynak>"`.

## 3. GDScript (Godot 4.7.2) — bu projede ısıran tuzaklar

- **Tip çıkarımı:** `var x := sozluk.get("a")` → "Cannot infer the type" parse hatası ve **bütün bağımlı betikler derlenmez** (10 Ekim'de 4 test birden düştü). Variant dönen ifadede tipi yaz: `var x: int = int(sozluk.get("a", 0))`, `var b: bool = …`.
- **Null güvenliği:** `yonetim.koylu(id)` ölmüş/gönderilmiş kişide `null` döner (BUG-0017: kare başı 500 SCRIPT ERROR). Döngüde her aramadan sonra `if k == null: continue`.
- **await sonrası geçerlilik:** `await` ile beklerken ekran/düğüm silinmiş olabilir → `if not is_instance_valid(x): return/continue` (otomatik oyuncu iki kez bu yüzden dondu).
- **Girinti:** dosya neyse ona uy (çoğu sekme; bazı küçük dosyalar tek boşluk). Karışık girinti parse hatası verir.
- **`class_name`** eklediysen `.gd.uid` dosyası import sırasında oluşur; teslim listesine ekle.
- Değiştirdiğin her `.gd` için önce import: `<godot_console> --headless --editor --import --quit --path .` — `SCRIPT ERROR`/`Parse Error` görürsen teslim etme.

## 4. Test yazma (her madde en az bir test)

- **Birim testi:** `tests/unit/<alan>/<ad>_test.gd`, `extends SceneTree`; sanity bunları **otomatik bulur** (`*test.gd`). Kalıp (gerçek örnek `tests/unit/kvr/chr_kilit_cikisi_test.gd`):
```gdscript
extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	# kur → çalıştır → _kontrol(...)
	_kontrol(1 + 1 == 2, "açıklayıcı Türkçe mesaj")
	await process_frame
	print("ADIM ADI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
```
- **Akış testi** (gerçek UI yolu): `tests/oto/<ad>_kontrol.gd` + `.tscn`, `extends Node`; gerçek `Ana`/`Oturum` kurar, ekranı sürer, sonda `GEÇTİ`/`KALDI` basar. Örnek `tests/oto/sinsi_gece_kontrol.gd`. **`tools/sanity_check.py`'deki listeye adını eklemen gerekir** (otomatik bulunmaz).
- **Her Kabul iddiası bir `_kontrol` satırıdır.** Maddenin "Kabul" cümlelerini tek tek teste çevir; `teslim.json` → `kabul_kontrol`'de eşle.
- Eski kayıt, aynı tohum (ikiz), sıfır/boş durum, sınır değer — maddede yazıyorsa test et.
- **Bilinen ortam sorunu (BUG-0020, açık):** `.godot` önbelleği sıfırdan kurulmuş bir kopyada `kuyu_kirliligi_kontrol`, `kitlik_isyani_kontrol`, `kriz_kenetlenmesi_kontrol`, `diyalog_sirasi_kontrol` GEÇTİ bastığı hâlde çıkışta 6 satır `RID allocations ... leaked at exit` verir. Bunu senin maddene ait sanma, ama kendi testinde yeni bir `leaked`/`still in use` satırı görürsen o senindir.
- Çıkışta `ERROR: N resources still in use` çıkarsa sanity bunu hata sayar: nesneleri `free()`/`null`la, sonda `await process_frame` ×2 + kısa `create_timer`.
- Testi geçirmek için kodu değil **testi** gevşetmek yasak.

## 5. Komutlar

```
G=C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe
$G --headless --editor --import --quit --path .                     # önce
$G --headless --path . -s tests/unit/<alan>/<ad>_test.gd            # birim
$G --headless --path . tests/oto/<ad>_kontrol.tscn                  # akış
python -B tools/metin_dogrula.py                                     # CSV
python -B tools/python_test_runner.py                                # python
python -B tools/sanity_check.py --godot $G --logs work/testx/sanity  # TAM (teslimden önce)
```
**Bellek kuralı (11–12 Ekim):** makinede aynı anda yalnız **bir** tam sanity koşar (iki tam sanity birlikte belleği bitirdi, işler durduruldu). Sen de aynı anda **tek bir Godot süreci** çalıştır: testleri arka arkaya koş, paralel/arka planda Godot başlatma; her test bitmeden sonrakini açma. Sen teslimden önce import + hedefli testleri koşarsın; tam sanity'yi `gorev.md`'de "SANITY SENDE" yazıyorsa koşarsın, yoksa Claude sırayla koşar. Testlerin dosya yolu `res://work/...` olmasın: temiz kopyada `work/` yoktur, test düşer (ADM-16 akış testi bu yüzden kırıldı) — test kayıtları `user://` altına.

Kayıt dosyası testlerin `user://`'ını bozmasın: komutlardan önce `APPDATA` ve `LOCALAPPDATA`'yı **mutlak** yolla `work/testx/appdata` altına yönlendir (göreli yol kayıt yazımını kırar). Pencereli Godot açarsan `--audio-driver Dummy`. Başka Godot süreçlerini ADIYLA kapatma — yalnız kendi PID'ini.

## 6. Kalite çıtası (Claude'un teslim kontrol listesi)
- [ ] Maddenin bütün Kabul iddiaları testte
- [ ] Yeni dosya + ince adaptör; çekirdek değişikliği gerekçeli ve en az satır
- [ ] Kodda sabit denge sayısı ve düz Türkçe cümle yok
- [ ] Kayıt alanı optional + eski kayıt testi
- [ ] Tohumlu RNG; aynı tohum aynı sonuç
- [ ] Import temiz, hedefli testler + etkilenen test taraması GEÇTİ (tam sanity'yi Claude koşar; yeni düşüş = teslim reddi)
- [ ] `teslim.json` eksiksiz; asset durumu yazılı
- [ ] Kapsam dışı hiçbir şey yok

## 7. Oyun tarafı: canavar tester olarak kalırsın
Her teslim edilen ve yayımlanan madde (kim yazarsa yazsın) için bir sonraki boş turunda: maddeyi **oyunda** kenar durumlarla dene (`TESTER_REHBERI.md` §12–§14; köprü `tools/tester_oyuncu.py` ve kendi stratejist oyuncun), bulguyu `BULGULAR.md`'ye yaz. Kendi yazdığın kodu da aynı acımasızlıkla test et — "ben yazdım, doğrudur" yok. Bir maddeyi kod olarak bitirmek ile oyunda çalıştığını kanıtlamak ayrı iştir; ikisi de senin.
