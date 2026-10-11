# ADM-16 — Oyun Köprüsü (Tester Bridge)

Amaç: tester kendi kararlarıyla gerçek oyuncu yolundan oynar. Oturum ekonomisi, RNG,
kapı kuyruğu ve gece hesaplaşması UI tarafından yürütülür. Köprü kaynak eklemez,
NPC çağırmaz, kapıyı atlamaz, zamanı/modeli doğrudan ilerletmez. Asset gerekmedi.

## Açılış ve taşıma

```powershell
& $godot --path . --audio-driver Dummy -- --bridge-port 9316
# ya da önce $env:BRIDGE_PORT = '9316'
```

Yalnız `OS.get_cmdline_user_args()` içindeki `--bridge-port <1..65535>` veya
`BRIDGE_PORT` köprüyü açar. Komut satırı ortamın önüne geçer; bozuk/eksik port
köprüyü açmaz. Normal oyunda düğüm/soket yoktur. Autoload ve project.godot değişmez.
TCP yalnız `127.0.0.1` üzerinde dinler. `bridge/godot/bridge.gd` taşıma,
`src/debug/oyun_koprusu.gd` oyuncu komut işleyicisidir.

Her satır UTF-8 JSON nesnesi; istek kimliği yanıtla aynıdır:

```json
{"id":1,"cmd":"get_state","args":{}}
{"id":1,"ok":true,"result":{"ekran":"menu","hazir":true,"mesgul":false,"secenekler":[],"rapor_satirlari":[]}}
{"id":2,"cmd":"kapi_karar","args":{"karar":"kabul"}}
{"id":2,"ok":false,"error":"Kapı karar ekranı gerekli."}
```

`run_command` daima Dictionary döndürür; hata `{"error":"açıklama"}` olur.
Geçersiz tür/indeks, yanlış ekran, kapalı karar, modal kart veya gece kilidi
açıklayıcı hata verir. Eylem yanıtı animasyonun bittiği anlamına gelmez:
sonrasında `get_state` oku, `hazir=true` ve `mesgul=false` bekle.
Python istemcisi kayıp yanıt sonrası komutu otomatik tekrar göndermez; sonuç
belirsizse durumu yeniden okuyarak karar ver.

## Komut sözleşmesi

| Komut | args | Oyuncu yolu / sonuç |
| --- | --- | --- |
| `ping` | `{}` | `{pong:true,surum:1}` |
| `get_state` | `{}` | Aşağıdaki salt okunur durum |
| `yeni_oyun` | `{tohum:11}` | Menü/son ekranından `Ana.yeni_oyun`; 0 oyunun rastgele tohumu |
| `soru_sor` | `{indeks:0}` | Görünür sohbet panelindeki etkin düğmeye basar |
| `kapi_karar` | `{karar:"kabul"}` | Karar ekranındaki aynı düğmeye iki basış; `kabul`, `ret`, `rusvet`, `kisla`; UI sunuyorsa `harc`, `elkoy` de geçerli |
| `koy_eylem` | `{tur:"insa",bina:"tarla",hucre:[9,8],yon:0}` | UI inşa kipi + hücre tıklaması; maliyet/yerleşim kuralları aynı; yon 0 veya 1 |
| `koy_eylem` | `{tur:"ata",koylu:1,bina:3}` | Bina bilgi panelindeki boşta köylünün atama düğmesi |
| `koy_eylem` | `{tur:"kaldir",koylu:1,bina:3}` | Aynı çalışan satırındaki **Çıkar**; işten çıkarır, binayı yıkmaz |
| `koy_eylem` | `{tur:"kaldir",bina:3}` | Köylü belirtilmezse bina bilgi panelinin **Yık** düğmesi; normal iade/çalışan kuralları |
| `gece_bitir` | `{}` | Köy **Geceye Geç** düğmesi; gün bir kez artar, rapor açılır |
| `devam` | `{indeks:0}` | Açık rapor/olay/son/perde/inceleme paneli veya kapı sıra seçeneğinin etkin düğmesi; mini oyunda bir `bas()` girdisi |
| `devam` | `{alan:"eylem",indeks:1}` | Kapı defterinin altındaki etkin eylem; ör. **Kararını ver**, inceleme |
| `kaydet` | `{}` | Mevcut UI **Kayıt noktası al**: ayrı snapshot slotu, kapı kişi/kuyruk/sohbet ve köy korunur |
| `yukle` | `{}` | Mevcut UI **Kayıt noktasına dön**; rapor/geçişte kilitli; normal faz kaydı da güncellenir |
| `screenshot` | `{yol:"work/tester/kapi.png"}` | Pencereli viewport PNG; headless açıklayıcı hata verir |
| `quit` | `{}` | Yanıt sonrası mevcut `Ses.cik` kapanışı |

İndeksler sıfırdan başlar ve **son get_state içindeki görünür/etkin düğme listesinin**
indeksidir; veri dosyasındaki kalıcı soru ID'si değildir. Ekran/sohbet değişince
yeniden oku. CHR'de “Devam et/Kararını ver” düğmesi de sohbet listesindedir.
Tester olay veya mini oyun sonucu seçimini köprünün otomatik çözmesini beklemez.

## Durum alanları

- `ekran`, `faz`: `menu|kapi|koy|rapor|son`; perde geçişi ve açık köy kartları `rapor`.
- `gun`, `tamamlanan_gece`: tamamlanan gece sayısı, 0'dan; `gece`: ekranda görünen
  sonraki nöbet, `gun+1`; `perde`: 1/2; `tohum`: hassasiyet kaybetmeyen string.
- `barlar`: `{halk,soylular,tuccarlar,ordu}`, mevcut `Oturum.gosterge` 0–10 API'si
  (huzur, adalet, kamu akçesi, güvenlik karşılıkları). Yeni bar sistemi oluşturulmaz.
- `akce:{koy,muhafiz}`, `erzak` (gıda), `ambar` (stok sözlüğü),
  `rusvet_keseleri:{kisisel_akce,alinan_rusvet_sayisi}`. Eski tüketilebilir dört kese
  mekaniği mevcut oyunda yok; kişisel kese ve gerçek rüşvet sayısı gösterilir.
- Kapıda `evre`, `kisi:{ad,sinif,gorunen_ipuclari,konusma,kalan_soru_hakki,
  kararlar,sorular,sirada}`. Yalnız görünen yazı ve etkin kararlar; gizli karakter
  bayrakları/heybe astarı/gelecek sonuçlar açığa çıkarılmaz. CHR soru kotası
  kullanmadığından `kalan_soru_hakki=-1`; seçenek ağacı UI listesiyle izlenir.
- `secenekler:[{indeks,metin}]`, kapıda ayrıca `eylemler`: tester seçimini kendisi yapar.
- Köyde `koy:{nufus,yatak,binalar,bosta,kurulabilir}`; bina ID, tür, hücre, hazır
  durumu, çalışan/slot ve yatak; boşta köylü ID/ad/sınıf ve atama önizlemesi;
  kurulabilir türlerin maliyetleri ve ilk 16 yasal hücre (sınırlı önizleme; diğer
  hücreler de inşa komutuyla mevcut yerleşim kurallarına göre denenebilir).
- `rapor_satirlari`: açık kartın görünen metinleri; `son:{kimlik,baslik,metin}`:
  gerçek son sinyali + mevcut nihai son/epilog seçimi.

## Python tester

```powershell
python -B tools/tester_oyuncu.py --godot <godot_console> --headless --tohum 11 --politika temkinli --gece 10 --cikti work/tester/oyun_11.jsonl
# --headless çıkarılırsa pencereli; politikalar: rastgele | temkinli | rusvetci
# --zaman-asimi 1800 --bekle 0.15 --port 9316 (0: boş port seç)
```

Her adımda JSONL `{adim,sure,state,eylem?,sonuc?,error?}`; sonda konsol ve
`.ozet.json` son, tamamlanan gece, hata, adım ve durma nedenini verir. Godot
çıktısı `.godot.log` dosyasına yazılır. Başlangıç/komut/oyun zaman aşımı ve
`finally` süreç temizliği vardır; Windows console launcher çocukları da kapatılır.
Başarı: son ekranı veya gece sınırı, sıfır hata ve sıfır script/parse hatası.

`BRIDGE_TESTER_DIR` yalnız açık köprüde otomatik faz ve snapshot kayıtlarını ayrı
klasöre yönlendirir. Python araç bunu kendisi ayarlar; Windows APPDATA da koşuya
özeldir. Normal insan kayıtları silinmez. Mevcut snapshot UI yöntemiyle kaydet/yükle
oynanır; kayıt noktası olmayan normal menü devamı `devam` menü seçeneğiyle yapılır.

Kendi yapay zekâ politikan için `bridge/python/bridge_client.py` içindeki `Bridge`
ile **get_state oku → görünen bilgiye göre karar ver → eylem gönder** döngüsü kur.
MCP kullanıyorsan `bridge/python/server.py` içindeki `bridge(cmd,args)` aynı
sözleşmeye erişir; genel şablondaki desteklenmeyen/hile komutları hata döndürür.
