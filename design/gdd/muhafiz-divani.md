# Muhafız Divanı / meydan duruşması — CAS-05

## Overview
Tek mevcut KoyYonetimSahnesi meydanında açılan divan sahnesi, yalnız CAS gözlenmiş fiil tutanaklarını okur.

## Player Fantasy
Muhafız olarak meydanda duruşma açmak, isimli kişinin gerçek tutanağını incelemek ve hüküm vermeden ertelemek.

## Detailed Rules
Mevcut sağ köy eylemlerinde tek Muhafız Divanı düğmesi. Aynı gece/olay kartı/terminal oturum sırasında açılmaz; ikinci divan oluşturulamaz. Scene src/kapi/divan_ekrani.tscn tek modal Control, aynı köy görüntüsü üzerinde. Meydandaki geçici masa ve iki sıra yalnız BoxMesh; yeni köy/insan/ekonomi simülasyonu yok. Var olan seçili kişinin görseli masanın önüne geçici getirilir; görev/rota değişmez, eski dönüşüm kapanışta korunur, yeni figür yok. Kamera mevcut meydan noktasını panelin solunda gösterir, önceki hedef/uzaklık ve oyun hızı/pausa kapanınca geri gelir.

Duruşma adayları yaşayan mevcut köylüler arasından CAS01 acik_izler gerçek gözleminde bulunan kişilerdir. Gizli zehir/kundak hedefi, gözlenmemiş gerçek fiil ve niyet tek başına burada görünmez. Aynı kişinin birçok gözlenmiş fiili tek aday altında. Tutanağı seçmek yalnız kişi/inceleme_gunu makbuzunu kaydeder; stok/akçe/sağlık/RNG değişmez. Sorgu/kanıt itirafı CAS06, ceza hükmü CAS07 sorumluluğunda; bu madde duruşma sahnesini ve başlangıç incelemesini tamamlar.

## Formulas
Kararlı kişi kimliği sırası; ayrı suç/kanıt/RNG hesabı yok. Kamera uzaklık22, mevcut meydan merkezi + ofset. Tek masa/iki sıra, merkez JSON boyut/renk.

## Edge Cases
Eski optional kayıt kişi−1; bozuk/sınırsız sayılar elenir. Dead/ayrılmış/terminal kişi yeni duruşma adayı olmaz. Boş divan açıkça gözlenmiş fiil olmadığını söyler. Eski seçim hâlâ mevcut aday ise restore/reopen aynı tutanağı gösterir. Kanıtlar aynı CAS geçmişi sınırında (7 gece/100 kayıt); kopya kanıt deposu kurulmaz. Süresi dolmuş kayıtta UI güncel adayları kullanır. Duruşmanın ertelenmesi suç kaydını silmez ve hüküm verilmiş sayılmaz. Modal klavye olayları köy kısayollarına gitmez; Button odağı klavyeyle kullanılabilir. Kapanma veya queue_free aynı temizleme hookunu çalıştırır, geçici meydan kutuları kaldırılır.

## Dependencies
DivanOturumu yeni dar model, CasusGeceTakibi tek açık fiil kaynağı. DivanEkrani yeni tscn/gd; DivanBaglantisi köyde tek kur çağrısı; DivanMeydani tek geçici kutu grubu. KoyYonetimi optional save/load iki ince çağrı. Mevcut Tema, hız kontrolü, kamera, köylü kimliği ve meydan.

## Tuning Knobs
Data/divan_meydani.json ofset, masa/sira boyutu, renk, kamera_uzaklik ve kamera_sag_kaydir. Yeni asset üretimi/indirme yok. Masa/sıra model ihtiyacı G CAS05-DIVAN satırında; kutuların tek değiştirme noktası DivanMeydani.kur/_kutu.

## Acceptance Criteria
Gerçek/gizli/niyet/dead aday ayrımı; tek kişinin çok fiili tek aday, copy query, seçim JSON; kasa/stok/RNG korunur. Gerçek KoyEkrani divan aç/reopen/close, ikinci modal reddi, eski olay sırasında red, hız2 ve kamera restore, üç kutu temizliği. Native/headless sahne ve iki ds kopyası; CAS/CHR/kayıt/kriz/sağlık/gece/20 gece regresyonu.
