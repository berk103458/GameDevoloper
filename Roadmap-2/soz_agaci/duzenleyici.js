// DYL-15: Söz ağacı görsel web düzenleyicisi
// Tarayıcı tabanlı düğüm ekleme, sid üretimi ve şema doğrulama

class SozDuzenleyici {
  constructor() {
    this.dugumler = {};
    this.gecmis = [];
  }

  dugumEkle(id, satir, sid) {
    if (!sid) {
      sid = "sid_" + Math.random().toString(36).substring(2, 9);
    }
    this.dugumler[id] = { id, satir, sid, secenekler: [] };
    return this.dugumler[id];
  }

  baglantiKur(kaynakId, hedefId, secenekId, metin) {
    if (!this.dugumler[kaynakId] || !this.dugumler[hedefId]) {
      return false; // Hedefi olmayan bağlantı kurulamaz (Kural 2)
    }
    this.dugumler[kaynakId].secenekler.push({
      id: secenekId,
      hedef: hedefId,
      metin: metin
    });
    return true;
  }
}

if (typeof module !== 'undefined') {
  module.exports = SozDuzenleyici;
}
