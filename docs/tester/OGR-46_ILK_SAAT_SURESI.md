# OGR-46 — İlk altı gecenin süresi

7 Kasım 2026, Godot 4.7.2, Windows, başsız otomatik oyuncu sahnesi. Oyun tohumu 11, otomatik oyuncunun kabul oranı 0,75.

İlk köy ekranından altıncı gece raporuna kadar **187,187 saniye (3 dakika 7,187 saniye)**. Altı gece tamamlandı ve runner bir süre satırı üretti. KOP-03 ve ZAR-05 ile birleşen sürümde ölçüm **187,078 saniye**. İki koşuda da oyun sürecinde script hatası görülmedi. Mevcut eksik metin anahtarı uyarıları çıktı.

ROADMAP’teki 45–75 dakika aralığı oyuncu için önerilen hedeftir. Başsız otomatik oyuncu diyalog ve raporları kendi bekleme süreleriyle geçtiği için bu ölçüm otomasyon taban değeridir.

```powershell
$env:PYTHONUTF8='1'
python -B tools/python_test_runner.py --ilk-saat-suresi --godot 'C:/Users/Ahmet/Desktop/Godot.exe' --tohum 11
```
