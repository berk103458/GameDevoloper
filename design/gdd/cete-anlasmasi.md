# Dağ çetesiyle süreli anlaşma — HAR-08

## Overview
Mevcut Pazar kartında 10 kamu akçesi karşılığı 30 günlük çete ganimeti koruması. Aynı husumet baskını/sızması çalışır; yeni saldırı veya ödeme döngüsü yoktur.

## Player Fantasy
Muhafız kamu parasını ambarı korumak için kullanır; insanlara yönelik tehlike ve diğer krizler sürer. Süre ve bedel açıkça görünür.

## Detailed Rules
Aktif anlaşma tekrar satın alınamaz/uzatılamaz. Başlangıç günü dahil, bitiş günü hariç. Geçerli süre boyunca çete baskınının gıda/odun, sızmasının gıda/alet ganimeti sıfırdır. Yaralanma zarları, moral/asayiş, husumet sönümü ve Karaboran intikamı mevcut akışta kalır. Sürü/lojistik sayıları korunur; mevcut çete baskını zaten sürü sayısını azaltmıyordu, bu paket yeni hayvan saldırısı icat etmez. Kurt/hastalık/sabotaj/yangın veya gece tüketimi anlaşma kapsamında değildir. Süre bitince otomatik ödeme yok; yeniden oyuncu seçer.

## Formulas
Ödeme uygunsa: kamu_akçe-=bedel; makbuz={gun:gerçek gün,bitis:gun+sure}. Aktif=yaşayan köy && gun<=gerçek gün<bitis. Ganimet aktifse[0,0]; değilse mevcut baskın gıda%30/odun%20 ve sızma max(3,gıda/6)/alet1. Aynı mevcut RNG diğer sonuçlar için korunur.

## Edge Cases
Eksik kamu parası kişisel keseden tamamlanmaz. Aktif süre/terminal/eksik kasa atomik ret. JSON makbuzu korur, legacy boş makbuz, geçersiz/tam sayı olmayan veya sure ile uyuşmayan sınırsız tarih elenir. Gelecekte başlayan makbuz aktif değildir. Son korunan gün29, gün30'da koruma kalkar; yeni ödeme30→60. Çete tamamen dost/savaşsız sayılmaz; anlaşma ambar ganimeti içindir.

## Dependencies
CeteAnlasmasi ve dış JSON. HusumetBaskini ganimette tek helper; KoyYonetimi sızma ganimeti/save/load ince adaptörleri. Metadata aynı gerçek köy kaydına yazılır. CeteAnlasmaPaneli mevcut Pazar adaptöründe tek çağrı, ikinci HUD yok. Oturum/koy_halk_hareketi/kasa motoru/CSV/CHR değişmez, kayıt sürümü3.

## Tuning Knobs
Aylık ödeme soyutlaması sure30 gerçek gece ve bedel10 kamu akçesidir; kaynakta takvim vadesi belirtilmediği için denge varsayımı olarak dış JSON'dadır. Bu süre mevsim/yıl uzunluğu ile karıştırılmaz. Yeni asset gerekmedi; mevcut metin/düğme, envanter G kontrol edilir. Asset üretimi/indirme yok.

## Acceptance Criteria
Kişisel/kamu kasa ayrımı, atomik ödeme/tekrar/JSON/legacy/bozuk süre/29–30–60 sınırı, aynı gerçek baskın ve sızma stok sonucu, normal kayıp karşılaştırması, korunmuş sürü/RNG/yaralanma/sosyal sonuç. Gerçek Pazar düğmesi/disabled/yükleme ve native/headless/ayna; husumet/Karaboran/kayıt/kapı/köy/pazar regresyonu.
