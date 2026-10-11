# TEK-16 — sıfır SCRIPT ERROR bütçesi (Kalfa)

11 Ekim 2026. Sahiplik fcec33e. TEK-01, testx tarafından kapalıdır; eksik sınıf nüfus kontrolü son tam koşuda geçti. Başka ajan imzası değiştirilmedi.

Kanıt: `work/sanity-tek131415-final` içinde 343 kontrol logu; tam koşu exit 0 ve 20 GECE DUMAN: GEÇTİ. Logların tamamında SCRIPT ERROR **0**, Parse Error **0**, Failed to load script **0**, satır başı ERROR **0**, KALDI **0**.

Koşunun kaynak/test/ayar ağacı a33c874 içinde commitlidir. `git diff a33c874 HEAD -- src data tests tools` boş: bu denetimde yalnız belge ve ROADMAP sahipliği değişti. Az önce tamamlanan 343/0/20 gece tam koşu bu maddenin temiz tur kanıtıdır; aynı kaynak için tekrar koşu başlatılmadı.

Mevcut `tools/sanity_check.py` hata regex'i ve başarısız koşuda exit 1 davranışı korunur. SCRIPT ERROR veya Failed to load script için tolerans/istisna eklenmedi. Önceden bulunan ortam sertifika deposu istisnası oyun script hatası değildir; bu temiz koşuda o istisnaya ihtiyaç olmadı. İkinci doğrulayıcı yazılmadı. Asset gerekmedi.

Zorunlu ds yerel ayna bu bilgisayarda erişilemiyor; eşitlenemedi.
