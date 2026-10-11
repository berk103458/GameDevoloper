# Karar kaydı B — katı ayıklama

Kapsam: `ROADMAP_2_B.md` içinde duran ve `KARAR_KAYDI.md` satırı olmayan DYL kimlikleri, artı dosyadan silinmiş olup satırı olmayan DYL-30…56 listesi. Numara yeniden sıralanmaz. Başka dosyadaki hedefe giden madde silinmedi; cümle `TASIMA_LISTESI_B.md` içindedir.

| Kimlik | Karar | Hedef | Gerekçe |
|---|---|---|---|
| DYL-05 | TUT | | `src/soz/verilen_soz.gd` yok; söz listeye düşmüyor, süre dolunca dönüş açılmıyor. |
| DYL-06 | TUT | | `src/soz/dil_engeli.gd` yok; ortak dil yokken kırık satır ve tercüman çağrısı yok. |
| DYL-07 | TUT | | `data/soz/aksam_konulari.json` yok; konu ağırlığı ve meslek cümlesi ACL-03 tetiğinde durmuyor. |
| DYL-08 | TUT | | `src/soz/karar_donusu.gd` yok; karar günler sonra sabah, haberci veya köylü satırı olarak dönmüyor. |
| DYL-09 | TUT | | `src/kapi/denetci_gelisi.gd` yok; yedi ila on günde bir denetçi sahnesi yok. |
| DYL-10 | TUT | | `src/soz/cekirdek_secici.gd` yok; aynı kimlikte tohumla seçilen çekirdek yok. |
| DYL-11 | TUT | | `soz_agaci` sekmelerinde kör okuma yok; `src/debug/soz_onizleme.gd` yok. |
| DYL-12 | TUT | | `data/soz` yok; beş muhafız tipiyle son taraması yok. |
| DYL-13 | TUT | | Prototip incelemesi kelime farkı ve sürüm geçmişi göstermiyor. |
| DYL-14 | TUT | | Kapı Muhafızı'nda `docs/dunya_kitabi/ornek_defteri/` yok. |
| DYL-15 | TUT | | `Roadmap-2/soz_agaci/duzenleyici.js` yok; yerinde düzenleme ve `sid` yok. |
| DYL-16 | TUT | | `tests/soz/altin/` yok; iki motorun aynı kaydı oynattığı dosya yok. |
| DYL-30 | TAŞI | DYL-05 | Söz kimliğinin tekilliği DYL-05 kabulünde: aynı kimlik ikinci kez 1 hata. |
| DYL-31 | TAŞI | DYL-05 | Tutulan sözün ödülü bir kez; ikinci yazım DYL-05 kabulünde yok. |
| DYL-32 | TAŞI | DYL-05 | Tanık varsa dedikodu DYL-05 Ne cümlesinde. |
| DYL-33 | SİL | DYL-06 | Dil engeli DYL-06 gövdesinde; ayrı cümle eklenmedi. |
| DYL-34 | TAŞI | DYL-06 | Tercüman yokken düğme 0, DYL-06 kabulünün ek şartında. |
| DYL-35 | SİL | DYL-06 | Sabır düşüşü DYL-06 kural 4'te ve bölümün ortak kuralında. |
| DYL-37 | SİL | ACL-03 | Akşam açılışı ACL-03'te; gövde geri getirilmedi. |
| DYL-39 | SİL | ACL-03 | Akşam kapanışı ACL-03'te; gövde geri getirilmedi. |
| DYL-40 | SİL | UZM-08 | UZM-08 yol haritası 1'de kapalı; gövde geri getirilmedi. |
| DYL-41 | SİL | DYL-08 | Yeni sahne ve ikinci harita DYL-08 Ne cümlesinde ve kabul ek şartında. |
| DYL-42 | SİL | HFZ-05 | Karar satırı HFZ-05'te DIY-14 ve DYL-08'den okunuyor. |
| DYL-43 | SİL | DYL-09 | Denetçi sahnesi DYL-09 gövdesinde. |
| DYL-45 | TAŞI | DYL-09 | Koşul tutmazsa sahne açılmaz, DYL-09 Ne cümlesinde. |
| DYL-46 | TAŞI | DYL-10 | İkinci karakter kimliği açılmaz, DYL-10 Ne cümlesinde. |
| DYL-47 | SİL | YAZ-09 | Çekirdek kotası YAZ-09'da; DYL-10 onu okur. |
| DYL-48 | SİL | YAZ-03 | Ses kartı YAZ-03'te; DYL-10 ikinci kart açmaz. |
| DYL-49 | TAŞI | DYL-11 | Skor alanı olmayan dosya skor satırı yazmaz; DYL-11 kabul ek şartı. |
| DYL-50 | TAŞI | DYL-11 | Oyun menüsünde kör okuma düğmesi yoktur; DYL-11 kabul ek şartı. |
| DYL-51 | TAŞI | DYL-11 | İki ağızla skor yazılmaz, üç ağız ister; DYL-11 kabul ek şartı. |
| DYL-52 | SİL | DYL-12 | Tip taraması DYL-12'nin kendisi; yazım kapısı değil. |
| DYL-53 | SİL | DEN-05 | Ölçümün gece hesabını ikinci kez çalıştırmaması DEN-05'te. |
| DYL-54 | TAŞI | DYL-13 | Kaydı olmayan taşındı kimliği hazır sayılmaz; DYL-13 kabul ek şartı. |
| DYL-55 | TAŞI | DYL-13 | Eski cümle `data/soz` içine kopyalanmaz; DYL-13 kabul ek şartı. |
| DYL-56 | TAŞI | DYL-13 | Sürüm kaydı iki kişi adı ister; DYL-13 kabul ek şartı. |
| DYL-57 | TAŞI | DYL-14 | İkinci örnek defteri açılmaz; DYL-14 kabul ek şartı. |
| DYL-59 | TAŞI | DYL-14 | Defterdeki köylü adı kadroda yoksa kayıt 1 hata; DYL-14 kabul ek şartı. |
| DYL-61 | TAŞI | DYL-15 | Site `data/soz` yazmaz; DYL-15 kural 6 ve kabul ek şartı. |
| DYL-63 | TAŞI | DYL-16 | `--check` farkı 0 değilse altın kopyası yazılmaz; DYL-16 kabul ek şartı. |
| DYL-64 | SİL | DYL-16 | İki motorun aynı kaydı oynaması DYL-16 kural 2; ikinci seçici DIY-02'de yasak. |
| DYL-65 | SİL | DYL-08 | Yeni sahne yasağı DYL-08'de duruyor; üç boyutlu sonuç sahnesi aynı yasak. |
| DYL-66 | TAŞI | DYL-08 | Aynı karar ikinci sabah yazılmaz ve SAB-01 kancasına düşmez; DYL-08 ek şartı. |
| DYL-67 | TAŞI | DYL-08 | Ayrılan kimlik dönüş sahnesine girmez; DYL-08 ek şartı. |
| DYL-68 | TAŞI | DYL-08 | Aynı dönüş barı bir kez değiştirir; DYL-08 ek şartı. |
| DYL-69 | TAŞI | DYL-08 | Tanıklı dönüş mevcut dedikodu kaydına 1 satır düşer; DYL-08 ek şartı. |
| DYL-72 | SİL | | Bölüm ortak kuralı ses dosyası yoktur; yeni eşik yok. |
| DYL-73 | SİL | ARY-02 | Yerel renk 0 ARY-02 kabulünde. Yeni cümle yok; madde duruyor, hedef başka dosya. |
| DYL-74 | TUT | | Göster ve Bak düğmesi `chr_diyalog_paneli.gd` içinde yok; kapalı sebep, kaydırma ve kod kimliği oyuncuya görünür. |
| DYL-75 | BİRLEŞTİR | DYL-74 | Altı düğme ve yedinci tür yasağı DYL-74 kural 2 ve kabulünde. |
| DYL-76 | TAŞI | GIR-06 | Ok tuşu cümlesi GIR-06'ya gidecek; madde duruyor, hedef başka dosya. |
| DYL-77 | TAŞI | KAP-39 | Heybe kilidi cümlesi KAP-39'a gidecek; madde duruyor, hedef başka dosya. |
| DYL-78 | SİL | KAP-16 | Kuyruk boşken fazın köye geçmesi KAP-16 ek şartında. Yeni cümle yok; madde duruyor. |
| DYL-79 | BİRLEŞTİR | DYL-74 | Kod kimliğinin ekranda 0 olması DYL-74 kabulünde. |
| DYL-81 | TAŞI | KAY-04 | Eski kayıtta boş eylem listesi KAY-04'e gidecek cümle; madde duruyor. |
| DYL-82 | TAŞI | KAY-04 | Yüklemede eylemin yeniden uygulanmaması KAY-04'e gidecek cümle. Ödül tekrarı DYL-05'te. Madde duruyor. |
| DYL-83 | TAŞI | DYL-16 | Aynı tohum ve eylem dizisi aynı dalı seçer; DYL-16 kabul ek şartı. |
| DYL-85 | TAŞI | DEN-05 | Eylem kullanım sayısı ölçüm satırı olarak DEN-05'e gidecek; madde duruyor. |
| DYL-89 | TAŞI | TEK-12 | `eylem_bitti` yasağı TEK-12'ye gidecek. Kodda bu sinyal yok. Madde duruyor. |
| DYL-91 | SİL | | Bölüm kuralı ses dosyası yoktur; `assets/ses` 39 wav, bu madde yenisini istemiyor. |
| DYL-95 | SİL | KLT-23 | `src/` içinde HTTP çağrısı 0 ve KLT-23 bunu yazıyor. Yeni cümle yok; madde duruyor. |
| DYL-96 | SİL | DYL-01 | Altı iddia DYL-01, DYL-03, DYL-06, DYL-08, DYL-11 ve ses kuralında ayrı duruyor. |
