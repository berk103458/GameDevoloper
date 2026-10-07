# EKO-07 — Muhafız maaşları ve güvenlik

## Overview
Hazır Muhafız Kışlası çalışanları ile eski doğrudan muhafız görevi tek bordro/savunma sözleşmesine bağlanır. Her gece kişi başı mevcut 1 kamu akçesi ödenir. Ödeme yoksa savunma personeli görev bırakır, asayiş bozulur ve nöbet hattında rüşvet karşılığı usulsüz geçiş riski doğar.

## Detailed Rules
Kışla 10 odun/6 taş/4 kereste, iki iş yuvası, iki gün; mevcut normal bina görseli kullanılır. Kışla çalışanı erzak üreticisi değildir; gerçek muhafız sayımı, savunma, asayiş ve nöbet yorgunluğuna bağlanır. Yaş kısıtı yetişkin; bina ve eski doğrudan görevin toplamı mevcut muhafiz_azami sınırını paylaşır.

Cari maaş ve kişinin birikmiş maaş borcu kamu kasasından birlikte ödenir; yeterli değilse kısmi kesinti yapılmaz. Ödenmeyen kişinin moralinden mevcut 10 düşer, kişi başına asayiş riski +10 ve borca cari maaş eklenir. Kişi görev bırakır; aynı gecedeki husumet/asayiş/savunma hesaplarında etkin nöbet sayısı azalır. Borçlu kişi yeniden atansa bile borç karşılanana kadar etkin savunmaya katılmaz. Yeniden atayıp ertesi gece cari maaş + eski borç ödeyince görev toparlanır; önceki moral hasarı kendiliğinden silinmez.

Ödenmeyen nöbet hattı kişi başına %25 usulsüz geçiş/rüşvet olayı üretir. Olay gerçekleşirse ilgili muhafızın gizli defterine 2 akçe ve asayişe +8 yazılır; bu dışarıdan alınan rüşvettir, oyuncunun kişisel veya kamu kasasına gelir yazılmaz. Rapor şüpheli geçişi anonim belirtir, oyuncu paneli gizli kişi/miktar bilgisini göstermez. Bu güvenlik olayı kapının karar kuyruğuna yeni bir CHR eklemez; gerçek etkisi mevcut asayiş ve sonraki baskın/kriz hesabındadır. Ödenen bordro RNG tüketmez. Ödenmeyen görevli sivil/boşta çalışmaya geçtiğinde yeni maaş veya tekrar eden rüşvet olayı üretmez.

## Formulas
Gece bedeli = Σ(atanmış muhafızın cari ücreti + eski borcu). Asayiş clamp(0…100), Moral clamp(0…100). Gece başına kişi bir kez işlenir; son_gece kaydı tekrar bordro çağrısını engeller. Kamu isyanı mevcut huzur/moral eşiğinden ilerler; yeni bağımsız isyan sistemi uydurulmaz.

## Edge Cases
Eski kayıtta borç/gizli defter boş; geçmiş ücret borcu çıkarılmaz. Ölen/sürülen kişi bordroya alınmaz. Uyuklayan muhafız yuva ve maaşını korur; etkin savunma kaybı UZM kaza API'sindedir. Sıfır kasada kasayı negatif yapmaz. Eski savunma rezervi maaş için kilit değildir. Mali borç ödenmeden tekrar atama savunmayı açmaz. Bozuk/negatif/kesirli kayıt alanları reddedilir; geçerli kişiler korunur.

## Dependencies
KoyYonetimi kamu akçesi/gece sırası, IsKazalari nöbet sözleşmesi, NobetYorgunlugu; CHR bina adaptörü, gerçek atama/kart önizlemesi, savunma UI, güvenli JSON. CSV ve KAP-01 değişmez.

## Tuning Knobs
Kışla, moral/asayiş kaybı ve rüşvet riski/miktarı data/koy/muhafiz_maasi.json içindedir; günlük ücret mevcut KoyAyarlari.muhafiz_maas alanıdır. Yeni değerler açık denge varsayımıdır.

## Acceptance Criteria
Gerçek kışla ataması savunma sayımı; tam ödenen kamu maaşı ve kişisel kasa ayrımı; ödenmeyen gece gerçek görev/asayiş kaybı; rüşvet dalı ve anonim rapor; tekrar/yeniden atama koruması; kamu borcu ödeyerek toparlanma; yaş/yuva sınırı; eski/yeni/bozuk JSON; gerçek gece ve UI, native görünüm, ayna ve tam regresyon geçmeden ROADMAP kapanmaz.
