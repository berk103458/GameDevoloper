# BUG-19 — Sıra olayı kişi uyumu (Kalfa)

Beş olayın metni `{kisi}` kullanır. Aynı `SiraOlayiKisisi.indeks` canlandırılan modeli seçer: kavga ilk, bayılma üçüncü (iki kişide ikinci), diğerleri son kişi. UI kişi çevirisini bir kez tutar, sonuçta da aynı kişiyi anlatır. Olay kaynağı değiştirilmez; RNG ve kayda yeni kişi listesi eklenmez.

Cinsiyet mevcut CHR model tanımlarından alınan JSON metadatasıdır. Yaş mevcut `YasRolleri.kaynak` ile belirlenir. `Dunya3B.karakter` yalnız gerçekten yüklediği modelde bu bilgiyi kurar; yedek kapsüle varsayılan cinsiyet atamaz. Eksik/bilinmeyen cinsiyette “biri”, çocukta “bir çocuk” kullanılır; yaşlı kadın ve yaşlı adam ayrı anahtardır. Kuyruk boş/tek modelse olay ve RNG yok; köy nüfusu sıfır olsa da gerçek kuyruk varsa olay gelebilir.

Kırmızı test mevcut beş olayın kişi şablonu içermediğini gösterdi. Yeni birim test beş olayda 100'er, toplam 500 deneme yapar; kişi, animasyon indeksi, yaş/cinsiyet, sonuç şablonu, boş kuyruk ve kapsül sınırlarını denetler. Gerçek sıra-atlama sahnesi yüklenmiş model metadatası ve nesne kimliğini de denetler. CSV doğrulaması, Python testleri ve ilgili kuyruk/çeviri testleri hedefli çalışır. Nihai tam sanity: 331 PASS / 0 hata / 20 gece; loglar `work/sanity-bug19-final`. Aynı anda tek koşu çalıştı; test kodunda `res://work` yolu yok.

Asset gerekmedi. JSON model bilgisidir; model/texture/ses üretilmedi veya indirilmedi. `Roadmap-2/arsiv/` değişmedi. ds ayna bu bilgisayarda bulunmadığı için eşitlenemedi.

Festive entegrasyonu: uygulama commit d1e851e sonrası 14 commit merge edildi. CSV'nin kişi, kaynak ve taş yatağı anahtarlarının tamamı korundu. Merge sonrası 11 hedefli kontrol 0 hata: CSV/Python/import, BUG-19, fırtına kuyruğu, eksik sınıf nüfusu, taş yatağı, oyun köprüsü birimleri ve gerçek sıra/taş/köprü sahneleri. 331 kontrolün tam koşusu merge öncesindeki uygulamayı doğrular; yeni festive'nin tamamına ait yeni bir tam koşu değildir.
