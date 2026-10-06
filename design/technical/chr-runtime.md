# CHR runtime — Codex uygulaması

`tools/chr_parser.py`, 30 CHR kaynak sayfasını doğrular ve `data/chr_runtime/CHR_XXX.tres` üretir. Kaynak dosyalarındaki alan/kimlik adları korunur; başlangıç tansiyonu Ahmet'in kararıyla 1–3 kabul edilir. Harici takip kimlikleri kaynak sayfası bulunmadığında uyarı olarak sayılır; yeni NPC uydurulmaz.

## Veri ve runtime sınırı

`KarakterVerisi` mevcut katalog alanlarını korur. Yeni kimlik/tur alanları eski API'ye adaptördür. Şecere, nesneler, görsel izler, düğümler, beş statlı karar matrisi, gecikmeli olaylar ve spawn zincirleri yeni kaynakta bulunur. Metinler Resource içinde tutulur; SYS-09 PR #2 birleşene kadar CSV yazılmaz.

`Gelen.chr_sorgusu()` adlı CHR ziyaretinde bağımsız `ChrSorgusu` oluşturur. `ChrKapiAdaptoru` kapı ekranına sorgu ve 2D inceleme yüzeyini bağlar; mevcut JSON diyalog dosyası değişmez. Sorguda açılan tüm sır bayrağı, mevcut köy sisteminin gizli karakter bayraklarına ince adaptörle aktarılır. Portre incelemesi mevcut rol portresini kullanır; kaynakta tarif edilen fiziksel iz açıklaması tıklamada gösterilir.

KVR-07/08/09 **veri şeması** maddeleridir: beş stat etkileri, gecikmeli olay ve takip zinciri verileri derlenmiştir. Gecikmeli olayların gece motorunda uygulanması, harici takip NPC'lerinin içerik üretimi ve CHR bina türleri bu paketin dışındaki runtime/olay paketlerine aittir. Köyün mevcut dört bar uyumluluk köprüsü silinmemiştir.

Rüşvet yalnız kişisel kasaya/eşyalara yazılır. CHR rüşveti kaynak karar matrisinden, eski ziyaretçi rüşveti seçilmiş heybe eşyalarından okunur. Kamu kasasının eski `akce` API'si korunur; müsadere ve harç kamu geliridir.

## CHR bina adları

`BinaKatalogu.chr_hedef_turleri(ad)` kaynak konumu ayrı sözlükle katalog türlerine bağlar. Ağıl ve Ahır iki hedefe açılır; tanımsız ad boş dizi döndürür. Mevcut ambar/tarla verileri aynen korunur; Şifahane, Muhafız Kışlası gibi yeni türler yalnız `chr_hedef` kayıtlarıdır ve `kurulabilir=false` taşır. Bu sözlük inşa/üretim sistemini uygulamaz; bedelsiz bina yaratmaz. 30 CHR kaynağının tüm gecikmeli hedefleri birim testinde katalogla doğrulanır.

## Kayıt

Oturum sürümü 3: v2→v3 göçü kişisel kasa/envanter, tecrübe, takvim ve yeni bina alanlarını ekler; köy, kadro ve RNG verisini korur. Köy verisi olmayan v1 dört bar kayıtları ve gelecekteki sürümler güvenle reddedilir; kullanıcı dosyası dönüştürülerek ezilmez.

`AtomikJsonKaydi`: flush → tmp geri okuma/JSON doğrulama → sağlam eski ana kayıt için bak.tmp → bak rename → tmp → ana rename. Bozuk ana dosya sağlam yedeği ezmez. `GuvenliKayit` ve eski `KayitDeposu` aynı yolu kullanır.

## Doğrulama

- `python -B tools/chr_parser.py --check`
- `python -B -m unittest discover -s tests/tools -p test_chr_parser.py`
- Godot `--headless --path . --editor --import --quit`
- Godot `--headless --path . -s tests/unit/kvr/<test>.gd`: kvr_test, chr_derleme_test, chr_sorgu_test, cift_kasa_test, kayit_gocu_test, atomik_kayit_test.
- Godot `--headless --path . tests/oto/chr_kapi_kontrol.tscn`: gerçek kapı UI'sında kanıt/panik/kabul kısıtı; kullanıcı kayıt dosyasına dokunmaz.
- Yerel birim testler: heybe, kapı kararları/kuyruğu/manzarası, karakter sayfaları, köy rotası/yönetimi, mini oyun, ses.

Altı yeni SFX özgün prosedürel foley'dir; `tools/chr_sfx_uret.py` tekrar üretir. Blöf/ikna dengesi `data/chr_runtime/sorgu_kurallari.tres` ile ayarlanır.
