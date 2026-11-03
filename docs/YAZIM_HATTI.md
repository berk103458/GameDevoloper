# Söz Yazım Hattı ve Üretim Rehberi (YAZ-04)

Bu doküman, Kapı Muhafızı diyaloglarının üretim, doğrulama, inceleme ve onay sürecini belirler.

---

## 1. Yazım Hattı Aşamaları (YAZ-04)
1. **Karakter Ses Kartı (YAZ-03):** Yazıma başlamadan önce karakterin mesleği, korkusu, sırrı ve örnek cümleleri `data/karakter_ses_kartlari.json` içinde tanımlanır.
2. **Doğaçlama ve Taslak:** Metin sesli okuma ve Üslup Rehberi kurallarıyla kurgulanır; yapay formüller (`çünkü`, `alarm`, `aslında`) reddedilir.
3. **Şema Doğrulaması (DIY-01a):** `SozSemasi.dogrula()` ile düğüm derinliği (max 12), tekil giriş, tekil seçenekler ve izinli etki anahtarları denetlenir.
4. **Kadro Özgünlük Denetimi (YAZ-09):** Sır çekirdeklerinin kadrodaki oranı denetlenir (sır evresi %50 kotasını aşamaz).
5. **Altın Test ve Onay (DYL-16):** Karakterin tüm yolları ve sonları `tests/soz/altin/` kayıtlarıyla doğrulanır.

---

## 2. Temel Kurallar
- **Eski Diyalog Taşınmaz (YAZ-39):** Eski `acilis` kalıpları ve robotik soru-cevaplar yeni motora taşınmaz; baştan doğal dille yazılır.
- **Kişi Adları Çevrilmez (YAZ-79):** Karakter adları evrensel Türkçe kimlikleriyle kalır, yerelleştirmede çevrilmez.
- **Kayıt Metin Gömmez (YAZ-87):** Kayıt dosyaları ham metin değil, durum ve anahtar kaydeder.
