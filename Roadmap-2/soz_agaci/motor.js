// Söz motoru taslağı (DIY-02 için prototip). Arayüzden bağımsızdır; Node ile test edilir.
(function (kok) {
  const dizi = (x) => (x == null ? [] : Array.isArray(x) ? x : [x]);

  const ES_MESLEKLERI = {
    dokumaci: "Dokumacı / keçeci",
    sifaci: "Ebe / şifacı",
    firinci: "Fırıncı / aşçı",
    bostanci: "Bostancı",
    sutcu: "Sütçü / yoğurtçu",
    yun_egirici: "Yün eğirici",
  };

  const YAKLASIMLAR = { ikna: "İkna", gozdagi: "Gözdağı", blof: "Blöf", gonul: "Gönül alma" };

  function kosulSayisi(k) {
    if (!k) return 0;
    let n = 0;
    for (const [a, v] of Object.entries(k)) n += a === "baglam" ? Object.keys(v).length : dizi(v).length;
    return n;
  }

  // Tutmayan koşulların listesini döndürür; boş liste = koşul tutuyor.
  function kosulEksikleri(k, s, b) {
    const eksik = [];
    if (!k) return eksik;
    for (const [a, v] of Object.entries(k)) {
      switch (a) {
        case "ipucu":
          dizi(v).forEach((x) => s.ipucu.includes(x) || eksik.push({ a, x }));
          break;
        case "beyan":
          dizi(v).forEach((x) => s.beyan.some((y) => y.id === x) || eksik.push({ a, x }));
          break;
        case "bayrak":
          dizi(v).forEach((x) => s.bayrak.includes(x) || eksik.push({ a, x }));
          break;
        case "bayrak_yok":
          dizi(v).forEach((x) => !s.bayrak.includes(x) || eksik.push({ a, x }));
          break;
        case "tansiyon_min":
          if (s.tansiyon < v) eksik.push({ a, x: v });
          break;
        case "tansiyon_max":
          if (s.tansiyon > v) eksik.push({ a, x: v });
          break;
        case "guven_min":
          if (s.guven < v) eksik.push({ a, x: v });
          break;
        case "guven_max":
          if (s.guven > v) eksik.push({ a, x: v });
          break;
        case "soylenen":
          dizi(v).forEach((x) => s.soylenen.some((y) => y.id === x) || eksik.push({ a, x }));
          break;
        case "sabir_max":
          if (s.sabir > v) eksik.push({ a, x: v });
          break;
        case "tecrube_min":
          if ((b.tecrube || 0) < v) eksik.push({ a, x: v });
          break;
        case "es_meslek":
          if (!dizi(v).includes(b.es_meslek)) eksik.push({ a, x: v });
          break;
        case "baglam":
          for (const [bk, bv] of Object.entries(v)) if (b[bk] !== bv) eksik.push({ a, x: bk, d: bv });
          break;
        default:
          eksik.push({ a: "bilinmeyen", x: a });
      }
    }
    return eksik;
  }

  class SozMotoru {
    constructor(sahne, baglam) {
      this.sahne = sahne;
      this.baglam = baglam;
      this.dinleyici = null;
      this.sifirla();
    }

    sifirla(baslangicDugumu) {
      const b = this.sahne.baslangic;
      this.s = {
        dugum: null,
        tansiyon: b.tansiyon,
        guven: b.guven || 0,
        sabir: b.sabir,
        beyan: [],
        soylenen: [],
        ipucu: [],
        bayrak: [],
        kullanilan: [],
        hatirla: [],
        dedikodu: [],
        kaynak: {},
        karar: null,
        yol: [],
        gecisler: [],
        log: [],
        bitti: false,
      };
      this.gir(baslangicDugumu || b.dugum);
    }

    dugum(id) {
      return this.sahne.dugumler[id || this.s.dugum];
    }

    kademe(t = this.s.tansiyon) {
      const k = this.sahne.kurallar.tansiyon_kademeleri;
      return k.find((x) => t >= x.min && t <= x.max) || k[k.length - 1];
    }

    tutar(k) {
      return kosulEksikleri(k, this.s, this.baglam).length === 0;
    }

    // Kural tablosu: tutan varyantlar içinde en çok koşullu olan kazanır; hiçbiri tutmazsa taban metin.
    metinSec(satir) {
      let en = -1;
      (satir.varyant || []).forEach((v, j) => {
        if (!this.tutar(v.kosul)) return;
        if (en < 0 || kosulSayisi(v.kosul) > kosulSayisi(satir.varyant[en].kosul)) en = j;
      });
      return en < 0 ? { m: satir.m, vi: -1 } : { m: satir.varyant[en].m, vi: en };
    }

    yaz(k, m, ek) {
      this.s.log.push(Object.assign({ k, m, dugum: this.s.dugum }, ek || {}));
    }

    uygula(e) {
      if (!e) return;
      const s = this.s;
      if (e.tansiyon) s.tansiyon = Math.max(0, s.tansiyon + e.tansiyon);
      if (e.guven) s.guven = Math.max(0, Math.min(this.sahne.kurallar.guven_ust || 10, s.guven + e.guven));
      dizi(e.soylenen).forEach((x) => s.soylenen.some((y) => y.id === x.id) || s.soylenen.push(x));
      if (e.sabir) s.sabir = s.sabir + e.sabir;
      dizi(e.ipucu).forEach((x) => s.ipucu.includes(x) || s.ipucu.push(x));
      dizi(e.bayrak).forEach((x) => s.bayrak.includes(x) || s.bayrak.push(x));
      dizi(e.beyan).forEach((x) => {
        if (!s.beyan.some((y) => y.id === x.id)) {
          s.beyan.push(x);
          this.yaz("beyan", x.metin);
        }
      });
      for (const [r, n] of Object.entries(e.kaynak || {})) s.kaynak[r] = (s.kaynak[r] || 0) + n;
      dizi(e.hatirla).forEach((x) => {
        s.hatirla.push(x);
        this.yaz("hatirla", "Bu hatırlanacak.", { not: x });
      });
      dizi(e.dedikodu).forEach((x) => s.dedikodu.push(x));
      if (e.karar) s.karar = e.karar;
    }

    tansiyonAsti() {
      return this.s.tansiyon > this.sahne.kurallar.tansiyon_ust;
    }

    sabirDenetle() {
      const o = this.sahne.kurallar.sabir_olayi;
      if (!o || this.s.sabir > 0 || this.s.bayrak.includes("sira_ayrildi")) return;
      o.satirlar.forEach((x, i) => this.yaz(x.k, x.m, { id: "_sabir.s" + i }));
      this.uygula(o.etki);
    }

    gir(id) {
      const d = this.sahne.dugumler[id];
      if (!d) throw new Error("Düğüm yok: " + id);
      if (this.s.dugum) this.s.gecisler.push([this.s.dugum, id]);
      this.s.dugum = id;
      this.s.yol.push(id);
      (d.satirlar || []).forEach((satir, i) => {
        if (!this.tutar(satir.kosul)) return;
        const { m, vi } = this.metinSec(satir);
        this.yaz(satir.k, m, { id: id + ".s" + i + (vi >= 0 ? ".v" + vi : "") });
        this.uygula(satir.etki);
      });
      this.uygula(d.etki);
      if (d.son) {
        this.s.bitti = true;
        return;
      }
      if (this.tansiyonAsti()) {
        this.yaz("sistem", "Tansiyon " + this.sahne.kurallar.tansiyon_ust + "'u aştı.");
        this.gir(this.sahne.kurallar.kacis_dugumu);
      }
    }

    secenekler() {
      const d = this.dugum();
      if (d.son) return [];
      const liste = (d.secenekler || []).map((sec, i) => {
        const anahtar = this.s.dugum + "." + i;
        return {
          i,
          sec,
          anahtar,
          kullanildi: this.s.kullanilan.includes(anahtar),
          eksik: kosulEksikleri(sec.kosul, this.s, this.baglam),
        };
      });
      if (d.sonraki) liste.push({ i: -1, sec: { metin: "Devam", hedef: d.sonraki, devam: true }, anahtar: null, kullanildi: false, eksik: [] });
      return liste.map((x) => Object.assign(x, { acik: !x.kullanildi && x.eksik.length === 0 }));
    }

    zarHesabi(sec) {
      const k = this.sahne.karakter;
      const N = parseInt(String(k.zar).replace("d", ""), 10);
      const kd = this.kademe();
      const degistiriciler = (this.sahne.degistiriciler || [])
        .filter((m) => m.yaklasim.includes(sec.zar.yaklasim) && this.tutar(m.kosul))
        .map((m) => ({ ad: m.ad, deger: m.deger }));
      const toplam = degistiriciler.reduce((a, m) => a + m.deger, 0);
      const gerekli = k.sorgu_degeri + 1 + kd.ek + toplam;
      let tutan = 0;
      for (let f = 1; f <= N; f++) if (this.basariMi(f, N, gerekli)) tutan++;
      return { N, deger: k.sorgu_degeri, kademe: kd, degistiriciler, gerekli, olasilik: tutan / N, yaklasim: sec.zar.yaklasim, tur: sec.zar.tur };
    }

    basariMi(yuz, N, gerekli) {
      if (yuz === N) return true;
      if (yuz === 1) return false;
      return yuz >= gerekli;
    }

    // kesme: muhafız karakterin sözünü keser. kesilir: karakter muhafızın sözünü keser.
    muhafizSoyler(sec, anahtar) {
      const id = anahtar ? anahtar.replace(/\.(\d+)$/, ".o$1") : null;
      if (sec.kesme) {
        for (let j = this.s.log.length - 1; j >= 0; j--) {
          if (this.s.log[j].k === "karakter") {
            this.s.log[j].kesildi = true;
            break;
          }
        }
      }
      this.yaz("muhafiz", sec.kesilir ? sec.kesilir + "—" : sec.metin, { id, kesme: !!sec.kesme, kesildi: !!sec.kesilir });
    }

    tepki(sec, anahtar) {
      const id = anahtar ? anahtar.replace(/\.(\d+)$/, ".o$1") : "";
      (sec.tepki || []).forEach((t, j) => this.yaz(t.k, t.m, { id: id + ".t" + j }));
    }

    _kullan(sec, anahtar) {
      if (anahtar && (sec.tukenir || (sec.zar && sec.zar.tur === "tek_sans"))) this.s.kullanilan.push(anahtar);
    }

    sec(i) {
      const x = this.secenekler().find((y) => y.i === i);
      if (!x || !x.acik) throw new Error("Seçenek kapalı: " + i);
      const sec = x.sec;
      if (sec.zar) return { zar: this.zarHesabi(sec), i };
      if (!sec.devam) this.muhafizSoyler(sec, x.anahtar);
      this._kullan(sec, x.anahtar);
      this.uygula(sec.etki);
      this.tepki(sec, x.anahtar);
      this.sabirDenetle();
      if (this.tansiyonAsti()) {
        this.yaz("sistem", "Tansiyon " + this.sahne.kurallar.tansiyon_ust + "'u aştı.");
        this.gir(this.sahne.kurallar.kacis_dugumu);
      } else this.gir(sec.hedef);
      return null;
    }

    zarAt(i, yuz) {
      const x = this.secenekler().find((y) => y.i === i);
      if (!x || !x.acik || !x.sec.zar) throw new Error("Zar seçeneği değil: " + i);
      const sec = x.sec;
      const h = this.zarHesabi(sec);
      if (yuz == null) yuz = 1 + Math.floor(Math.random() * h.N);
      const basari = this.basariMi(yuz, h.N, h.gerekli);
      this.muhafizSoyler(sec, x.anahtar);
      this.yaz("zar", (YAKLASIMLAR[h.yaklasim] || h.yaklasim) + " · d" + h.N + " → " + yuz + " (gerekli " + h.gerekli + ") · " + (basari ? "Başarı" : "Başarısız"), {
        basari,
      });
      this._kullan(sec, x.anahtar);
      this.uygula(sec.etki);
      if (basari) this.uygula(sec.zar.basari_etki);
      else this.uygula(sec.zar.basarisiz_etki || this.sahne.kurallar.varsayilan_basarisiz_etki);
      this.sabirDenetle();
      if (this.tansiyonAsti()) {
        this.yaz("sistem", "Tansiyon " + this.sahne.kurallar.tansiyon_ust + "'u aştı.");
        this.gir(this.sahne.kurallar.kacis_dugumu);
      } else this.gir(basari ? sec.zar.basari : sec.zar.basarisiz);
      return { yuz, basari, hesap: h };
    }
  }

  // Ağaç görünümü ve doğrulayıcı için: düğümler arası bütün kenarlar.
  function kenarlar(sahne) {
    const out = [];
    for (const [id, d] of Object.entries(sahne.dugumler)) {
      (d.secenekler || []).forEach((sec, i) => {
        if (sec.zar) {
          out.push({ from: id, to: sec.zar.basari, i, tur: "basari", sec });
          out.push({ from: id, to: sec.zar.basarisiz, i, tur: "basarisiz", sec });
        } else out.push({ from: id, to: sec.hedef, i, tur: "normal", sec });
      });
      if (d.sonraki) out.push({ from: id, to: d.sonraki, i: -1, tur: "devam", sec: { metin: "Devam" } });
    }
    return out;
  }

  function dogrula(sahne) {
    const hatalar = [];
    const ids = new Set(Object.keys(sahne.dugumler));
    if (!ids.has(sahne.baslangic.dugum)) hatalar.push("Başlangıç düğümü yok: " + sahne.baslangic.dugum);
    if (!ids.has(sahne.kurallar.kacis_dugumu)) hatalar.push("Kaçış düğümü yok");
    for (const e of kenarlar(sahne)) if (!ids.has(e.to)) hatalar.push(e.from + " → bilinmeyen hedef " + e.to);
    for (const [id, d] of Object.entries(sahne.dugumler)) {
      if (!d.son && !(d.secenekler || []).length && !d.sonraki) hatalar.push(id + ": çıkışı yok");
      if (d.son && (d.secenekler || d.sonraki)) hatalar.push(id + ": son düğümde seçenek var");
    }
    const ulasilan = new Set([sahne.baslangic.dugum, sahne.kurallar.kacis_dugumu]);
    const kuyruk = [...ulasilan];
    const ke = kenarlar(sahne);
    while (kuyruk.length) {
      const n = kuyruk.shift();
      for (const e of ke) if (e.from === n && !ulasilan.has(e.to)) ulasilan.add(e.to), kuyruk.push(e.to);
    }
    for (const id of ids) if (!ulasilan.has(id)) hatalar.push(id + ": ulaşılamıyor");
    return hatalar;
  }

  const api = { SozMotoru, kenarlar, dogrula, kosulEksikleri, ES_MESLEKLERI, YAKLASIMLAR };
  kok.SozMotoruApi = api;
  if (typeof module !== "undefined") module.exports = api;
})(typeof window !== "undefined" ? window : globalThis);
