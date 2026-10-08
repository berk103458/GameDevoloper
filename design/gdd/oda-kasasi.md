# Gizli zemin kasası — ODA-02

## Overview
Odanın kasa kapağı açılınca mevcut KeseGostergesi kişisel akçeyi, aynı Oturum envanterinin toplamını gösterir. EKO-01/EKO-11 cüzdanı kullanılır, ayrı kasa hesabı yoktur.

## Player Fantasy
Muhafız, kamu hazinesinden ayrı rüşvet gelirlerini gizli zemin kasasında görür.

## Detailed Rules
Oda ilk açılışta kasa kapalıdır; düğme ile mevcut kutu kapağı kalkar ve kişisel kese/ eşya toplamı görünür. Kapatma bilgiyi gizleyip kapağı geri koyar. Her açılış tek Oturum.muhafiz_akce ve muhafiz_esyalari kaynağını yeniden okur. Kamu parası ve stok bu panelde gösterilmez, harcanmaz veya taşınmaz. Kapağı kapatmak içerikleri silmez ve gelecekteki teftişten muafiyet sağlamaz.

## Formulas
Gösterilen akçe = muhafiz_akce; eşya toplamı = toplam max(0, adet). Açma/kapama ve yeniden girişte kasa, envanter, kayıt, RNG değişimi sıfır.

## Edge Cases
Sıfır akçe/eşya gerçek sıfır görünür. Tekrarlı açma/kapama eşya çoğaltmaz; kapak başlangıç transformuna döner. JSON kayıt dönüşü mevcut EKO alanlarını kullanır. Oda kapanınca görünüm düğümleri silinir, kasa parası silinmez. Teftiş ODA-07/13 ayrı mekaniktir; bu yüzey yalnız gizli kasa sunumudur.

## Dependencies
OdaKasasiPaneli yeni helper, MuhafizOdasiEkrani içinde tek çağrı. KeseGostergesi yeniden kullanılır. Mevcut rüşvet dağıtımı/kişisel karaborsa/JSON kayıt alanlarına yazılmaz. ODA-03 kişisel eşya sergisi ve ODA-14 ortak gösterge denetimi ayrı maddelerdir.

## Tuning Knobs
data/muhafiz_odasi.json kasa_acik_aci/kasa_acik_y yalnız kutu kapağı sunumu. Envanter G ODA01-KASA mevcut model ihtiyacıdır, yeni asset gerekmedi.

## Acceptance Criteria
Gerçek CHR rüşveti sonrası mevcut kişisel akçe açılan kasada görünür, kamu hesapları korunur. Aç/kapat/yeniden aç, kapak restore, JSON devam, sıfır kayıt ve native oda testi; mevcut EKO/ODA/divan/gece testleri geçer.
