# EKO-03 — Çeki hayvanı lojistiği

## Overview

Tomruk üretimi ile ortak ambara teslim ayrı işlemlerdir. Taşıma üretim statını, kritik bonusu, inşaat süresini veya diğer kaynakları çarpmaz.

## Detailed Rules ve Formulas

Denge varsayımları:
- Her kaynak bina için bir gecede 1 birim taşıma zamanı vardır.
- Elle sefer yükü 3 tomruk, sefer süresi 1 gece.
- Hazır ahır ve en az bir öküz/inek varsa sefer yükü 9 tomruk, süre 0.5 gece. Hayvan sayısıyla sınırsız bonus birikmez.
- Kısmi sefer de aynı süreyi kullanır. Büyük yükte elle azami 3, çeki hayvanıyla azami 18 tomruk/gece teslim edilebilir. Kesirli üretim mevcut üretim artığı sisteminde korunur.
- Taşınamayan yük kaynak binanın kuyruğunda kalır. Ambar doluysa yük kaybolmaz; sonraki gece tekrar denenir. Kuyruk ambar stok/kapasitesi değildir ve hızar girdisi olamaz.
- Hazır ahır 2 hayvan barındırır. Ahır maliyeti 12 odun + 8 taş, yapım 2 gün; öküz 40, inek 35 kamu akçesi. Alım yalnız mevcut kervan gününde ve boş yer varsa gerçekleşir.

Hayvan sayısı, bekleyen yük ve kullanılan sefer zamanı `KoyYonetimi.kaydet()` içindeki `lojistik` alanına yazılır. Eski kayıtta alan yoksa hayvan ve kuyruk boş başlar; mevcut kayıt sürümü/API değişmez. Güvenli kayıt dosyası değiştirilmez.

## Dependencies

Uygulama: yeni `src/koy/ceki_lojistigi.gd` ve `src/arayuz/koy_hud/ceki_hayvani_paneli.gd`; katalog, üretim/teslim, JSON ve mevcut pazar için ince adaptörler. CSV değiştirilmez.

TUC-02 özel Celep takvimi, hayvan beslenmesi ve ANI-04 öküzün görsel rota/animasyonu ayrı paketlerdir. Kapı sahnesindeki dekoratif öküz sahiplik sayılmaz.

## Acceptance Criteria

Doğrulama: gerçek gece karşılaştırması, 3/9 sefer yükü ve 1/0.5 süre, iki sefer bütçesi, kuyruk korunumu, dolu ambar, bitmemiş ahır, kamu kasası/alım kapasitesi, eski/yeni JSON ve gerçek pazar düğmesi kontrolleri. Native Vulkan ekran görüntüsü `work/eko03_lojistik.png` dış çalışma klasöründe tutulur.

Denge değerleri dış yapılandırma dosyasında tutulur: `data/koy/ceki_lojistigi.json`.

## Edge Cases

Eksik girdiler stok tüketmeden durur. Eski kayıt kimlikleri ve stoklar korunur. Dolu ambar ve kullanılamayan yapı durumu ilgili model testlerinde doğrulanır; kapsam dışı görsel/gezgin tüccar davranışları tamamlanmış sayılmaz.
