# SOY-SON-01: Bayraklar ve Durum Geçişleri

## 1. Girdi Bayrakları (Söylenti Ağının Yaydığı Ön Bayraklar)
- `soylenti_degirmen_un_caliyor` (int, 1-3 gün)
- `soylenti_kuyuya_zehir_atildi` (int, 1-3 gün)
- `soylenti_tekfurun_altin_arabasi` (int, 1-3 gün)
- `soylenti_mogol_casusu_dolasiyor` (int, 1-3 gün)
- `soylenti_vebali_kumas_var` (int, 1-3 gün)

## 2. Kapanış ve Çözüm Bayrakları (Sonuç Bayrakları)
- `soylenti_degirmen_cozuldu` (bool): Değirmenci iftiradan kurtarıldı veya cezalandırıldı.
- `soylenti_kuyu_aklandi` (bool): Kuyu suyu temizlendi, panik dindi.
- `soylenti_tekfur_araba_sonuc` (bool): Katırcı olayı çözüldü, dedikodu bitti.
- `soylenti_casus_yakalandi` (bool): Samanlıktaki kaçak borçlu vakası kapandı.
- `soylenti_kumas_temiz` (bool): Kumaşlar aklandı, iftiracı cezalandırıldı.

## 3. Sistem Entegrasyonu
- Bu sonuç bayrakları `soylenti_agi.gd` içindeki aktif fısıltı listesinden ilgili konuyu otomatik olarak siler (`soylenti_sil(id)`).
