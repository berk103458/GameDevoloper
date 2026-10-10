(function () {
  const { SozMotoru, kenarlar, dogrula, ES_MESLEKLERI, YAKLASIMLAR } = window.SozMotoruApi;
  const { metinler, denetle, KURALLAR } = window.Yapaylik;
  const sahne = Object.values(window.SAHNELER)[0];
  const $ = (id) => document.getElementById(id);
  const el = (tag, cls, html) => {
    const e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html != null) e.innerHTML = html;
    return e;
  };
  const kacis = (t) => String(t).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
  const dizi = (x) => (x == null ? [] : Array.isArray(x) ? x : [x]);

  const EVRE_RENK = {
    varis: "#d6a85a", selam: "#c9b26b", ikram: "#7fa865", konular: "#6f9fc4", konu: "#5d84a3",
    heybe: "#b08a5a", yuzlesme: "#c25b4a", sir: "#a58bc9", ikilem: "#d07a9c", karar: "#e0a040", son: "#8d8170",
  };
  const EVRE_AD = {
    varis: "Varış", selam: "Selam", ikram: "İkram", konular: "Konu merkezi", konu: "Konu", heybe: "Heybe",
    yuzlesme: "Yüzleşme", sir: "Sır", ikilem: "İkilem", karar: "Karar", son: "Son",
  };
  const KIM = { karakter: sahne.karakter.ad, muhafiz: "Sen", anlati: "", sezgi: "Sezgi", es: "Eşin", sira: "Sıra", beyan: "", hatirla: "", zar: "", sistem: "" };
  const BAGLAM_AD = { mevsim: "Mevsim", sifahane: "Köyde şifahane", haber_sivas: "Sivas haberi duyuldu", asker: "Yanında asker" };
  const DEGER_AD = { yaz: "yaz", kis: "kış", true: "var", false: "yok" };

  // ---------------- metin yardımcıları ----------------
  const ipucuAd = (x) => sahne.ipuclari[x] || x;
  const dugumAd = (id) => (sahne.dugumler[id] ? sahne.dugumler[id].baslik : id);

  function kosulParca(a, v) {
    switch (a) {
      case "ipucu": return dizi(v).map((x) => "İpucu: " + ipucuAd(x));
      case "beyan": return dizi(v).map((x) => "Beyan: " + x);
      case "bayrak": return dizi(v).map((x) => "Bayrak: " + x);
      case "bayrak_yok": return dizi(v).map((x) => "Bayrak yok: " + x);
      case "tansiyon_min": return ["Tansiyon ≥ " + v];
      case "tansiyon_max": return ["Tansiyon ≤ " + v];
      case "guven_min": return ["Güven ≥ " + v];
      case "guven_max": return ["Güven ≤ " + v];
      case "soylenen": return dizi(v).map((x) => "Sen söyledin: " + x);
      case "sabir_max": return ["Sabır ≤ " + v];
      case "tecrube_min": return ["Muhafız tecrübesi ≥ " + v];
      case "es_meslek": return ["Eşin mesleği: " + dizi(v).map((x) => ES_MESLEKLERI[x] || x).join(" / ")];
      case "baglam": return Object.entries(v).map(([k, d]) => (BAGLAM_AD[k] || k) + ": " + (DEGER_AD[d] || d));
    }
    return [a + ": " + JSON.stringify(v)];
  }
  const kosulYazi = (k) => (k ? Object.entries(k).flatMap(([a, v]) => kosulParca(a, v)) : []);
  const eksikYazi = (eksik) => eksik.flatMap((e) => (e.a === "baglam" ? kosulParca("baglam", { [e.x]: e.d }) : kosulParca(e.a, e.x)));

  function etkiYazi(e) {
    if (!e) return [];
    const p = [];
    const isaret = (n) => (n > 0 ? "+" + n : "−" + Math.abs(n));
    if (e.tansiyon) p.push("Tansiyon " + isaret(e.tansiyon));
    if (e.guven) p.push("Güven " + isaret(e.guven));
    if (e.sabir) p.push("Sabır " + isaret(e.sabir));
    dizi(e.soylenen).forEach((x) => p.push("Söylediğin kayda geçer: " + x.id));
    dizi(e.beyan).forEach((b) => p.push("Beyan: " + b.id));
    dizi(e.ipucu).forEach((x) => p.push("İpucu: " + ipucuAd(x)));
    dizi(e.bayrak).forEach((x) => p.push("Bayrak: " + x));
    for (const [r, n] of Object.entries(e.kaynak || {})) p.push(r + " " + isaret(n));
    dizi(e.hatirla).forEach((x) => p.push("Hatırlanır: " + x));
    dizi(e.dedikodu).forEach((x) => p.push("Dedikodu: " + x));
    if (e.karar) p.push("Karar: " + e.karar);
    return p;
  }
  const zarYazi = (z) => (YAKLASIMLAR[z.yaklasim] || z.yaklasim) + " · " + sahne.karakter.zar + " · " + (z.tur === "tek_sans" ? "tek şans" : "tekrar edilebilir");

  // ---------------- motor ve bağlam ----------------
  const baglam = { mevsim: "yaz", es_meslek: "sifaci", tecrube: 2, sifahane: false, haber_sivas: true, asker: false };
  const motor = new SozMotoru(sahne, baglam);
  let zarBekleyen = null;
  let yazarModu = true;
  let kilitliGoster = true;

  $("sahneAdi").textContent = sahne.baslik + " · " + sahne.karakter.ad + ", " + sahne.karakter.yas + " · " + sahne.karakter.zar + ", değer " + sahne.karakter.sorgu_degeri;

  const esSec = $("bEs");
  for (const [k, v] of Object.entries(ES_MESLEKLERI)) esSec.append(new Option(v, k));
  esSec.value = baglam.es_meslek;
  const bagla = (id, alan, oku) => $(id).addEventListener("input", (ev) => {
    baglam[alan] = oku(ev.target);
    ciz();
  });
  bagla("bMevsim", "mevsim", (t) => t.value);
  bagla("bEs", "es_meslek", (t) => t.value);
  bagla("bTecrube", "tecrube", (t) => +t.value);
  bagla("bSifahane", "sifahane", (t) => t.checked);
  bagla("bHaber", "haber_sivas", (t) => t.checked);
  bagla("bAsker", "asker", (t) => t.checked);
  $("basaDon").onclick = () => yenidenBasla();

  function yenidenBasla(dugum) {
    zarBekleyen = null;
    motor.sifirla(dugum);
    gosterilenHatirla = 0;
    ciz();
  }

  // ---------------- oyna sekmesi ----------------
  function toast(m) {
    const t = $("toast");
    t.textContent = "Bu hatırlanacak — " + m;
    t.classList.add("gor");
    clearTimeout(toast.z);
    toast.z = setTimeout(() => t.classList.remove("gor"), 2600);
  }

  const KONUSAN = new Set(["karakter", "muhafiz", "anlati", "sezgi", "es", "sira"]);
  let gosterilenHatirla = 0;

  function logCiz() {
    const kap = $("kayit");
    const log = motor.s.log;
    kap.innerHTML = "";
    let sonDugum = null;
    for (const x of log) {
      if (x.dugum !== sonDugum && x.k !== "muhafiz" && x.k !== "zar") {
        sonDugum = x.dugum;
        const d = sahne.dugumler[x.dugum];
        if (d) kap.append(el("div", "ayrac", kacis((EVRE_AD[d.evre] || d.evre) + " · " + d.baslik)));
      }
      const isaret = x.id && inceleme[x.id] ? " i-" + inceleme[x.id].durum : "";
      const s = el("div", "satir " + x.k + (x.k === "zar" && !x.basari ? " basarisiz" : "") + (x.kesme ? " kesen" : "") + isaret);
      const kim = KIM[x.k];
      if (kim) s.append(el("div", "kim", kacis(kim) + (x.kesme ? " · sözünü keser" : "")));
      let m = x.m;
      if (x.k === "beyan") m = "Beyan defterine yazıldı: " + m;
      if (x.k === "hatirla") m = "Bu hatırlanacak. (" + x.not + ")";
      if (x.kesildi && x.k === "karakter") m = m.replace(/[.…]+$/, "") + "—";
      const mEl = el("div", "m", kacis(m));
      if (x.id && KONUSAN.has(x.k)) mEl.append(isaretDugmeleri(x.id, () => logCiz()));
      s.append(mEl);
      kap.append(s);
    }
    const hat = log.filter((x) => x.k === "hatirla");
    for (; gosterilenHatirla < hat.length; gosterilenHatirla++) toast(hat[gosterilenHatirla].not);
    kap.scrollTop = kap.scrollHeight;
  }

  function yanCiz() {
    const s = motor.s;
    const kd = motor.kademe();
    const ust = sahne.kurallar.tansiyon_ust;
    $("tansiyonYazi").textContent = s.tansiyon + " / " + ust + " · " + kd.ad + " (+" + kd.ek + ")";
    const tc = $("tansiyonCubuk");
    tc.style.width = Math.min(100, (s.tansiyon / ust) * 100) + "%";
    tc.style.background = kd.ek === 0 ? "var(--yesil)" : kd.ek === 1 ? "var(--altin)" : "var(--kirmizi)";
    const gu = sahne.kurallar.guven_ust || 10;
    $("guvenYazi").textContent = s.guven + " / " + gu;
    const gc = $("guvenCubuk");
    gc.style.width = Math.min(100, (s.guven / gu) * 100) + "%";
    gc.style.background = "var(--mor)";
    $("sabirYazi").textContent = Math.max(0, s.sabir) + " / " + sahne.baslangic.sabir;
    const sc = $("sabirCubuk");
    sc.style.width = Math.max(0, (s.sabir / sahne.baslangic.sabir) * 100) + "%";
    sc.style.background = s.sabir > 3 ? "var(--mavi)" : "var(--kirmizi)";
    $("bTecrubeYazi").textContent = baglam.tecrube;
    const liste = (id, arr) => {
      const u = $(id);
      u.innerHTML = arr.map((x) => "<li>" + kacis(x) + "</li>").join("");
      u.classList.toggle("bos", !arr.length);
    };
    liste("beyanlar", s.beyan.map((b) => b.metin));
    liste("ipuclari", s.ipucu.map(ipucuAd));
    liste("hatirlananlar", s.hatirla);
    liste("soylenenler", s.soylenen.map((x) => x.metin));
    liste("dedikodular", s.dedikodu);
    const kaynak = Object.entries(s.kaynak).map(([r, n]) => r + " " + (n > 0 ? "+" : "") + n);
    $("bayraklar").innerHTML = s.bayrak.concat(kaynak).map((b) => '<span class="etiket">' + kacis(b) + "</span>").join("") || '<span class="etiket">—</span>';
  }

  function secimlerCiz() {
    const kap = $("secimler");
    kap.innerHTML = "";
    const arac = el("div", "ust-arac");
    arac.innerHTML =
      '<label><input type="checkbox" id="yazarModu"' + (yazarModu ? " checked" : "") + "> Yazar notlarını göster</label>" +
      '<label><input type="checkbox" id="kilitliGoster"' + (kilitliGoster ? " checked" : "") + "> Kilitli seçenekleri göster</label>" +
      '<span style="margin-left:auto">Kısayol: 1–9</span>';
    kap.append(arac);
    $("yazarModu").onchange = (e) => ((yazarModu = e.target.checked), secimlerCiz());
    $("kilitliGoster").onchange = (e) => ((kilitliGoster = e.target.checked), secimlerCiz());

    if (zarBekleyen) return zarPaneliCiz(kap);

    if (motor.s.bitti) {
      const d = motor.dugum();
      const s = motor.s;
      const k = el("div", "sonuc");
      k.innerHTML =
        "<h4>Sonuç: " + kacis(d.baslik) + "</h4><div>" + kacis(d.sonuc || "") + "</div>" +
        '<div style="margin-top:8px;font-size:13px;color:var(--soluk)">Karar: <b>' + kacis(s.karar || "—") + "</b> · Yol: " + s.yol.length + " düğüm · Son tansiyon " + s.tansiyon +
        (s.hatirla.length ? "<br>Hatırlanacaklar: " + s.hatirla.map(kacis).join(" · ") : "") +
        (s.dedikodu.length ? "<br>Dedikodu: " + s.dedikodu.map(kacis).join(" · ") : "") + "</div>";
      const b = el("button", null, "Baştan başla");
      b.style.marginTop = "10px";
      b.onclick = () => yenidenBasla();
      const a = el("button", null, "Bu yolu ağaçta gör");
      a.style.margin = "10px 0 0 8px";
      a.onclick = () => sekmeAc("agac");
      k.append(b, a);
      kap.append(k);
      return;
    }

    let no = 0;
    for (const x of motor.secenekler()) {
      if (!x.acik && !kilitliGoster) continue;
      if (x.kullanildi && !kilitliGoster) continue;
      const sec = x.sec;
      const tekSans = sec.zar && sec.zar.tur === "tek_sans";
      const b = el("button", "secim" + (x.acik ? "" : " kilitli") + (sec.zar ? (tekSans ? " teksans" : " zarli") : ""));
      const numara = x.acik ? String(++no) : "·";
      if (x.acik) b.dataset.kisayol = numara;
      let html = '<span class="ust"><span class="no">' + numara + '</span><span>' + kacis(sec.metin) + "</span></span>";
      const meta = [];
      if (sec.zar) meta.push("Zar: " + zarYazi(sec.zar));
      if (sec.kesme) meta.push("Sözünü keser");
      if (sec.kesilir) meta.push("Sözün kesilir");
      if (!x.acik) meta.push(x.kullanildi ? "Kilitli: bir kez sorulur, soruldu" : "Kilitli: " + eksikYazi(x.eksik).join(", "));
      if (yazarModu) {
        if (sec.zar) meta.push("→ başarı: " + dugumAd(sec.zar.basari) + " · başarısız: " + dugumAd(sec.zar.basarisiz));
        else meta.push("→ " + dugumAd(sec.hedef));
        meta.push(...etkiYazi(sec.etki));
        if (sec.tukenir) meta.push("bir kez");
        if (sec.tepki) meta.push("Tepki: " + sec.tepki.map((t) => t.m).join(" "));
      }
      if (meta.length || (yazarModu && sec.neden)) {
        html += '<span class="meta">' + meta.map(kacis).join(" · ") + (yazarModu && sec.neden ? '<span class="neden">' + kacis(sec.neden) + "</span>" : "") + "</span>";
      }
      b.innerHTML = html;
      b.disabled = !x.acik;
      b.onclick = () => secimYap(x.i);
      kap.append(b);
    }
  }

  function secimYap(i) {
    const r = motor.sec(i);
    if (r && r.zar) zarBekleyen = r;
    ciz();
  }

  function zarPaneliCiz(kap) {
    const z = zarBekleyen;
    const h = z.zar;
    const sec = motor.secenekler().find((x) => x.i === z.i).sec;
    const p = el("div");
    p.id = "zarPanel";
    const isaret = (n) => (n > 0 ? "+" + n : n < 0 ? "−" + Math.abs(n) : "+0");
    let rows =
      "<tr><td>Karakter değeri</td><td class=s>" + h.deger + "</td></tr>" +
      "<tr><td>Taban</td><td class=s>+1</td></tr>" +
      "<tr><td>Tansiyon eki (" + kacis(h.kademe.ad) + ")</td><td class=s>" + isaret(h.kademe.ek) + "</td></tr>";
    for (const m of h.degistiriciler) rows += "<tr><td>" + kacis(m.ad) + "</td><td class=s>" + isaret(m.deger) + "</td></tr>";
    rows += '<tr class="toplam"><td>Gerekli (zar ≥)</td><td class=s>' + h.gerekli + "</td></tr>";
    p.innerHTML =
      "<div><b>" + kacis(sec.metin) + "</b></div>" +
      '<div style="font-size:13px;color:var(--soluk)">' + kacis(zarYazi(sec.zar)) + " · " + h.N + " gelirse her zaman başarı, 1 gelirse her zaman başarısız</div>" +
      "<table>" + rows + "</table>" +
      '<div style="margin-bottom:10px">Başarı olasılığı: <b>%' + Math.round(h.olasilik * 100) + "</b></div>";
    const yuz = el("span", "zarYuz", "?");
    const at = el("button", null, "Zarı at");
    const vaz = el("button", null, "Vazgeç");
    vaz.style.marginLeft = "8px";
    vaz.onclick = () => ((zarBekleyen = null), ciz());
    const satir = el("div");
    satir.append(yuz, at, vaz);
    p.append(satir);
    at.onclick = () => {
      at.disabled = vaz.disabled = true;
      yuz.classList.add("donuyor");
      const sonuc = 1 + Math.floor(Math.random() * h.N);
      let n = 0;
      const t = setInterval(() => {
        yuz.textContent = 1 + Math.floor(Math.random() * h.N);
        if (++n > 9) {
          clearInterval(t);
          yuz.classList.remove("donuyor");
          yuz.textContent = sonuc;
          const r = motor.zarAt(z.i, sonuc);
          const bil = el("span", null, r.basari ? " Başarı" : " Başarısız");
          bil.style.cssText = "font-size:18px;margin-left:10px;color:" + (r.basari ? "var(--yesil)" : "var(--kirmizi)");
          satir.append(bil);
          const dv = el("button", null, "Devam");
          dv.style.marginLeft = "14px";
          dv.onclick = () => ((zarBekleyen = null), ciz());
          satir.append(dv);
          dv.focus();
        }
      }, 60);
    };
    kap.append(p);
  }

  document.addEventListener("keydown", (e) => {
    if (!$("oyna").classList.contains("etkin") || e.target.tagName === "INPUT" || e.target.tagName === "SELECT") return;
    const b = document.querySelector('#secimler [data-kisayol="' + e.key + '"]');
    if (b) b.click();
  });

  // ---------------- ağaç sekmesi ----------------
  const W = 210, H = 62, KOLON = 400, SATIR = 82, KENAR = 40;
  const tumKenarlar = kenarlar(sahne);
  let yerlesim = null;
  let secili = sahne.baslangic.dugum;
  let olcek = 1;

  function yerlesimHesapla() {
    const ids = Object.keys(sahne.dugumler);
    const cikis = {};
    ids.forEach((id) => (cikis[id] = []));
    tumKenarlar.forEach((e) => cikis[e.from].push(e));
    // DFS: atalara dönen kenarlar geri kenardır (konu merkezine dönüş gibi); ağaçta çizgi yerine rozet olur.
    const durum = {}, sira = [], bitis = [], geri = new Set();
    const gez = (n) => {
      durum[n] = 1;
      sira.push(n);
      for (const e of cikis[n]) {
        if (durum[e.to] === 1) geri.add(e);
        else if (!durum[e.to]) gez(e.to);
      }
      durum[n] = 2;
      bitis.push(n);
    };
    gez(sahne.baslangic.dugum);
    ids.forEach((id) => durum[id] || gez(id));
    const ileri = tumKenarlar.filter((e) => !geri.has(e));
    const kat = {};
    bitis.slice().reverse().forEach((n) => {
      if (kat[n] == null) kat[n] = 0;
      for (const e of ileri) if (e.from === n) kat[e.to] = Math.max(kat[e.to] || 0, kat[n] + 1);
    });
    const kacisId = sahne.kurallar.kacis_dugumu;
    const enSon = Math.max(...Object.values(kat));
    kat[kacisId] = enSon;
    const kolonlar = [];
    sira.forEach((n) => (kolonlar[kat[n]] = kolonlar[kat[n]] || []).push(n));
    const konum = {};
    const yerlestir = () => kolonlar.forEach((k) => k.forEach((n, i) => (konum[n] = i)));
    yerlestir();
    const ort = (n, yon) => {
      const komsu = ileri.filter((e) => (yon ? e.to === n : e.from === n)).map((e) => konum[yon ? e.from : e.to]);
      return komsu.length ? komsu.reduce((a, b) => a + b, 0) / komsu.length : konum[n];
    };
    for (let tur = 0; tur < 4; tur++) {
      for (let c = 1; c < kolonlar.length; c++) {
        kolonlar[c].sort((a, b) => ort(a, true) - ort(b, true));
        yerlestir();
      }
      for (let c = kolonlar.length - 2; c >= 0; c--) {
        kolonlar[c].sort((a, b) => ort(a, false) - ort(b, false));
        yerlestir();
      }
    }
    const enUzun = Math.max(...kolonlar.map((k) => k.length));
    const xy = {};
    kolonlar.forEach((k, c) => {
      const ofset = ((enUzun - k.length) * SATIR) / 2;
      k.forEach((n, i) => (xy[n] = { x: KENAR + c * KOLON, y: KENAR + ofset + i * SATIR }));
    });
    return {
      xy, geri, ileri,
      genislik: KENAR * 2 + (kolonlar.length - 1) * KOLON + W,
      yukseklik: KENAR * 2 + (enUzun - 1) * SATIR + H,
    };
  }

  const NS = "http://www.w3.org/2000/svg";
  const svgEl = (tag, attrs, parent) => {
    const e = document.createElementNS(NS, tag);
    for (const [k, v] of Object.entries(attrs || {})) e.setAttribute(k, v);
    if (parent) parent.append(e);
    return e;
  };
  const kisalt = (t, n) => (t.length > n ? t.slice(0, n - 1) + "…" : t);

  function agacCiz() {
    if (!yerlesim) yerlesim = yerlesimHesapla();
    const { xy, geri, ileri, genislik, yukseklik } = yerlesim;
    const svg = $("agacSvg");
    svg.innerHTML = "";
    svg.setAttribute("width", genislik * olcek);
    svg.setAttribute("height", yukseklik * olcek);
    const g = svgEl("g", { transform: "scale(" + olcek + ")" }, svg);
    const yol = new Set(motor.s.yol);
    const gecis = new Set(motor.s.gecisler.map((p) => p[0] + ">" + p[1]));

    const ciftSay = {};
    const etiketSay = {};
    const kenarG = svgEl("g", {}, g);
    const etiketG = svgEl("g", {}, g);
    for (const e of ileri) {
      const a = xy[e.from], b = xy[e.to];
      const cift = e.from + ">" + e.to;
      const n = (ciftSay[cift] = (ciftSay[cift] || 0) + 1) - 1;
      const x1 = a.x + W, y1 = a.y + H / 2 + (n % 5) * 5 - 10;
      const x2 = b.x, y2 = b.y + H / 2 + (n % 5) * 3 - 6;
      const dx = Math.max(40, (x2 - x1) / 2);
      const d = "M" + x1 + "," + y1 + " C" + (x1 + dx) + "," + y1 + " " + (x2 - dx) + "," + y2 + " " + x2 + "," + y2;
      const ilgili = secili && (e.from === secili || e.to === secili);
      const cls = ["k", e.tur, gecis.has(cift) ? "gidildi" : "", ilgili ? "vurgu" : secili ? "soluk" : ""].join(" ");
      const p = svgEl("path", { d, class: cls }, kenarG);
      svgEl("title", {}, p).textContent = e.sec.metin + (e.tur === "basari" ? " (zar başarılı)" : e.tur === "basarisiz" ? " (zar başarısız)" : "");
      if (ilgili && e.from === secili) {
        const yigin = (etiketSay[e.to] = (etiketSay[e.to] || 0) + 1) - 1;
        const t = svgEl("text", { x: x2 - 6, y: b.y + 12 + yigin * 13, "text-anchor": "end", class: "klabel" }, etiketG);
        t.textContent = (e.tur === "basari" ? "✓ " : e.tur === "basarisiz" ? "✗ " : "") + kisalt(e.sec.metin, 28);
      }
    }

    const geriHedef = {};
    for (const e of geri) (geriHedef[e.from] = geriHedef[e.from] || new Set()).add(e.to);

    for (const [id, d] of Object.entries(sahne.dugumler)) {
      const { x, y } = xy[id];
      const cls = ["dg", yol.has(id) ? "gidildi" : "", motor.s.dugum === id ? "simdi" : "", secili === id ? "secili" : ""].join(" ");
      const ng = svgEl("g", { class: cls, transform: "translate(" + x + "," + y + ")", style: "cursor:pointer" }, g);
      svgEl("rect", { class: "kart", width: W, height: H, rx: 6 }, ng);
      svgEl("rect", { class: "serit", width: 5, height: H, fill: EVRE_RENK[d.evre] || "#888" }, ng);
      const ev = svgEl("text", { x: 14, y: 16, class: "evre" }, ng);
      ev.textContent = (EVRE_AD[d.evre] || d.evre) + (d.son ? " ■" : "");
      const bs = svgEl("text", { x: 14, y: 35 }, ng);
      bs.textContent = kisalt(d.baslik, 26);
      if (geriHedef[id]) {
        const gt = svgEl("text", { x: 14, y: 53, class: "geri" }, ng);
        gt.textContent = "↩ " + kisalt([...geriHedef[id]].map(dugumAd).join(", "), 30);
      } else if (id === sahne.kurallar.kacis_dugumu) {
        const gt = svgEl("text", { x: 14, y: 53, class: "geri" }, ng);
        gt.textContent = "⚡ tansiyon " + sahne.kurallar.tansiyon_ust + "'u aşınca";
      }
      svgEl("title", {}, ng).textContent = id;
      ng.addEventListener("click", (ev) => {
        ev.stopPropagation();
        secili = id;
        agacCiz();
        detayCiz();
      });
    }
  }

  function detayCiz() {
    const kap = $("detay");
    const d = sahne.dugumler[secili];
    if (!d) {
      kap.innerHTML = '<p style="color:var(--soluk)">Bir düğüme tıkla: içindeki satırları, her seçeneğin nereye ve neden gittiğini burada görürsün.</p>';
      return;
    }
    let h = "<h2>" + kacis(d.baslik) + "</h2>";
    h += '<div class="kimlik">' + kacis(secili) + " · " + kacis(EVRE_AD[d.evre] || d.evre) + (d.son ? " · bitiş" : "") + "</div>";
    h += '<button id="buradanOyna">Buradan oyna</button>';

    const gelen = tumKenarlar.filter((e) => e.to === secili);
    if (secili === sahne.kurallar.kacis_dugumu) h += "<h3>Buraya nasıl gelinir</h3><div class='dsatir'>Herhangi bir anda tansiyon " + sahne.kurallar.tansiyon_ust + "'u aşarsa otomatik.</div>";
    if (gelen.length) {
      h += "<h3>Buraya gelenler</h3>";
      for (const e of gelen) {
        const t = e.tur === "basari" ? " (zar başarılı)" : e.tur === "basarisiz" ? " (zar başarısız)" : "";
        h += '<div class="dsatir"><span class="kim">' + kacis(dugumAd(e.from)) + "</span><br>" + kacis(e.sec.metin) + kacis(t) + "</div>";
      }
    }

    h += "<h3>Satırlar</h3>";
    for (const s of d.satirlar || []) {
      h += '<div class="dsatir"><span class="kim">' + kacis(KIM[s.k] || s.k || "anlatı") + "</span>";
      if (s.kosul) h += ' <span class="etiket">' + kacis(kosulYazi(s.kosul).join(", ")) + "</span>";
      h += "<br>" + kacis(s.m);
      for (const v of s.varyant || []) h += '<br><span class="etiket">varyant · ' + kacis(kosulYazi(v.kosul).join(", ")) + "</span> " + kacis(v.m);
      if (s.etki) h += '<br><span class="etiket">etki · ' + kacis(etkiYazi(s.etki).join(", ")) + "</span>";
      h += "</div>";
    }
    if (d.etki) h += '<div class="dsatir"><span class="kim">Girişte</span><br>' + kacis(etkiYazi(d.etki).join(" · ")) + "</div>";

    if (d.son) {
      h += "<h3>Sonuç</h3><div class='dsatir'>" + kacis(d.sonuc || "") + "</div>";
    } else {
      h += "<h3>Seçenekler</h3>";
      (d.secenekler || []).forEach((sec) => {
        h += '<div class="dsec"><div class="metin">' + kacis(sec.metin) + "</div>";
        if (sec.zar) {
          h += '<div class="yon">Zar: ' + kacis(zarYazi(sec.zar)) + '<br><span class="bas">✓ başarı →</span> <a data-git="' + sec.zar.basari + '">' + kacis(dugumAd(sec.zar.basari)) + "</a>" +
            '<br><span class="bsz">✗ başarısız →</span> <a data-git="' + sec.zar.basarisiz + '">' + kacis(dugumAd(sec.zar.basarisiz)) + "</a> (" +
            kacis(etkiYazi(sec.zar.basarisiz_etki || sahne.kurallar.varsayilan_basarisiz_etki).join(", ")) + ")</div>";
        } else {
          h += '<div class="yon">→ <a data-git="' + sec.hedef + '">' + kacis(dugumAd(sec.hedef)) + "</a></div>";
        }
        const kos = kosulYazi(sec.kosul);
        h += '<div class="kural">Görünür: ' + kacis(kos.length ? kos.join(", ") : "her zaman") + (sec.tukenir ? " · bir kez" : "") + "</div>";
        const et = etkiYazi(sec.etki);
        if (et.length) h += '<div class="kural">Etki: ' + kacis(et.join(", ")) + "</div>";
        if (sec.kesme) h += '<div class="kural">Söz kesme: muhafız karakterin sözünü keser.</div>';
        if (sec.kesilir) h += '<div class="kural">Karakter sözü keser; ekranda "' + kacis(sec.kesilir) + '—" görünür.</div>';
        for (const t of sec.tepki || []) h += '<div class="kural">Tepki (' + kacis(KIM[t.k] || t.k || "anlatı") + "): " + kacis(t.m) + "</div>";
        if (sec.neden) h += '<div class="neden">' + kacis(sec.neden) + "</div>";
        h += "</div>";
      });
      if (d.sonraki) h += '<div class="dsec"><div class="metin">Devam</div><div class="yon">→ <a data-git="' + d.sonraki + '">' + kacis(dugumAd(d.sonraki)) + "</a></div></div>";
    }
    kap.innerHTML = h;
    kap.querySelectorAll("a[data-git]").forEach((a) => (a.onclick = () => {
      secili = a.dataset.git;
      agacCiz();
      detayCiz();
      const p = yerlesim.xy[secili];
      const ag = $("agacKap");
      ag.scrollTo({ left: p.x * olcek - ag.clientWidth / 2 + W / 2, top: p.y * olcek - ag.clientHeight / 2, behavior: "smooth" });
    }));
    $("buradanOyna").onclick = () => {
      yenidenBasla(secili);
      sekmeAc("oyna");
    };
  }

  function lejantCiz() {
    let h = "";
    for (const [k, v] of Object.entries(EVRE_RENK)) h += '<span class="r" style="background:' + v + '"></span>' + EVRE_AD[k];
    h += '<br><span class="cz" style="border-color:var(--yesil);margin-left:0"></span>zar başarılı<span class="cz" style="border-color:var(--kirmizi);border-top-style:dashed"></span>zar başarısız' +
      '<span class="cz" style="border-color:var(--altin)"></span>oynadığın yol<span style="margin-left:10px">↩ geri dönüş</span>';
    $("lejant").innerHTML = h;
  }

  const ag = $("agacKap");
  let surukle = null;
  ag.addEventListener("mousedown", (e) => {
    surukle = { x: e.clientX, y: e.clientY, l: ag.scrollLeft, t: ag.scrollTop, oynadi: false };
    ag.classList.add("surukle");
  });
  window.addEventListener("mousemove", (e) => {
    if (!surukle) return;
    if (Math.abs(e.clientX - surukle.x) + Math.abs(e.clientY - surukle.y) > 3) surukle.oynadi = true;
    ag.scrollLeft = surukle.l - (e.clientX - surukle.x);
    ag.scrollTop = surukle.t - (e.clientY - surukle.y);
  });
  window.addEventListener("mouseup", () => {
    surukle = null;
    ag.classList.remove("surukle");
  });
  $("agacSvg").addEventListener("click", () => {
    secili = null;
    agacCiz();
    detayCiz();
  });
  $("agacBuyut").onclick = () => ((olcek = Math.min(1.6, olcek + 0.15)), agacCiz());
  $("agacKucult").onclick = () => ((olcek = Math.max(0.35, olcek - 0.15)), agacCiz());
  $("agacSigdir").onclick = () => {
    olcek = Math.max(0.35, Math.min(1, ag.clientWidth / yerlesim.genislik, ag.clientHeight / yerlesim.yukseklik));
    agacCiz();
  };

  // ---------------- şablon sekmesi ----------------
  $("kapsamTara").onclick = () => {
    const r = kapsamTara(3000);
    const sonlar = Object.entries(r.sonlar).sort((a, b) => b[1] - a[1]).map(([k, v]) => kacis(dugumAd(k)) + " %" + ((v / r.n) * 100).toFixed(1)).join(" · ");
    $("kapsamSonuc").innerHTML =
      "<b>" + r.n + "</b> rastgele oynanış (bağlam her seferinde değişir). " +
      (r.gorulmeyen.length ? '<span style="color:var(--kirmizi)">Hiç görünmeyen ' + r.gorulmeyen.length + " satır:</span><br>" + r.gorulmeyen.map((x) => kacis(x.id + " — " + x.m)).join("<br>") : '<span style="color:var(--yesil)">Bütün satırlar en az bir kez göründü.</span>') +
      (r.dugumGorulmeyen.length ? '<br><span style="color:var(--kirmizi)">Ulaşılmayan düğüm: ' + r.dugumGorulmeyen.join(", ") + "</span>" : "") +
      '<br><span style="color:var(--soluk)">Sonların dağılımı: ' + sonlar + "</span>";
  };

  function sablonCiz() {
    $("json").value = JSON.stringify(sahne, null, 2);
    const hatalar = dogrula(sahne);
    const dugumSay = Object.keys(sahne.dugumler).length;
    const sonSay = Object.values(sahne.dugumler).filter((d) => d.son).length;
    $("dogrulama").innerHTML = hatalar.length
      ? '<span style="color:var(--kirmizi)">Doğrulama: ' + hatalar.map(kacis).join("<br>") + "</span>"
      : '<span style="color:var(--yesil)">Doğrulama geçti: ' + dugumSay + " düğüm, " + tumKenarlar.length + " geçiş, " + sonSay + " son; bütün hedefler var, her düğüme ulaşılıyor.</span>";
  }
  const indir = (ad, veri) => {
    const a = document.createElement("a");
    a.href = URL.createObjectURL(new Blob([JSON.stringify(veri, null, 2)], { type: "application/json" }));
    a.download = ad;
    a.click();
  };
  $("indir").onclick = () => indir(sahne.id + ".json", sahne);
  $("bosIndir").onclick = () =>
    indir("soz_sablon.json", {
      id: "karakter_id",
      surum: 1,
      baslik: "",
      karakter: { id: "", ad: "", yas: 0, cinsiyet: "", sinif: "", koken: "", zar: "d6", sorgu_degeri: 2, ses_karti: "", sir: "" },
      baslangic: { dugum: "varis", tansiyon: 4, sabir: 10 },
      ipuclari: {},
      kurallar: sahne.kurallar,
      degistiriciler: [],
      dugumler: {
        varis: { evre: "varis", baslik: "Varış", satirlar: [{ k: "anlati", m: "" }, { k: "karakter", m: "Selamün aleyküm." }], secenekler: [{ metin: "Aleyküm selam.", hedef: "konular", neden: "" }] },
        konular: { evre: "konular", baslik: "Konu merkezi", satirlar: [], secenekler: [{ metin: "Nereden geldin?", hedef: "k_nereden", tukenir: true }, { metin: "Yeter. Kararımı vereceğim.", hedef: "karar" }] },
        k_nereden: { evre: "konu", baslik: "Nereden · 1", satirlar: [{ k: "karakter", m: "" }], sonraki: "konular" },
        karar: { evre: "karar", baslik: "Karar", satirlar: [], secenekler: [{ metin: "Gir.", hedef: "son_kabul" }, { metin: "Bu kapı sana kapalı.", hedef: "son_ret" }] },
        son_kabul: { evre: "son", baslik: "Kabul", son: true, satirlar: [], etki: { karar: "kabul" }, sonuc: "" },
        son_ret: { evre: "son", baslik: "Ret", son: true, satirlar: [], etki: { karar: "ret" }, sonuc: "" },
        kacis: { evre: "son", baslik: "Kaçış", son: true, satirlar: [], etki: { karar: "kacti" }, sonuc: "" },
      },
    });

  // ---------------- inceleme ----------------
  const DURUMLAR = { dogal: "Doğal", yapay: "Yapay", yeniden: "Yeniden yaz" };
  const ANAHTAR = "soz_inceleme_" + sahne.id;
  let inceleme = {};
  try {
    inceleme = JSON.parse(localStorage.getItem(ANAHTAR) || "{}");
  } catch (e) {
    inceleme = {};
  }
  const tumMetin = metinler(sahne);
  const metinById = Object.fromEntries(tumMetin.map((x) => [x.id, x]));
  const kaydet = () => {
    try {
      localStorage.setItem(ANAHTAR, JSON.stringify(inceleme));
    } catch (e) {}
  };
  function isaretle(id, durum, not) {
    const eski = inceleme[id] || {};
    const yeni = Object.assign({}, eski, { metin: metinById[id] ? metinById[id].m : eski.metin, zaman: new Date().toISOString() });
    if (durum !== undefined) yeni.durum = eski.durum === durum ? null : durum;
    if (not !== undefined) yeni.not = not;
    if (!yeni.durum && !yeni.not) delete inceleme[id];
    else inceleme[id] = yeni;
    kaydet();
  }
  function isaretDugmeleri(id, sonra) {
    const kap = el("span", "isaret");
    const cur = inceleme[id] && inceleme[id].durum;
    for (const [d, ad] of Object.entries({ dogal: "✓", yapay: "✗", yeniden: "✎" })) {
      const b = el("button", "ib " + d + (cur === d ? " secik" : ""), ad);
      b.title = DURUMLAR[d];
      b.onclick = (e) => {
        e.stopPropagation();
        isaretle(id, d);
        sonra();
      };
      kap.append(b);
    }
    return kap;
  }

  let incelemeFiltre = "hepsi";
  function incelemeCiz() {
    const den = denetle(sahne);
    const kap = $("incelemeListe");
    const say = { dogal: 0, yapay: 0, yeniden: 0, bos: 0, uyari: Object.keys(den.satirlar).length };
    for (const x of tumMetin) {
      const d = inceleme[x.id] && inceleme[x.id].durum;
      if (d) say[d]++;
      else say.bos++;
    }
    $("incelemeOzet").innerHTML =
      "<b>" + tumMetin.length + "</b> satır · " +
      '<span class="ozet dogal">✓ ' + say.dogal + " doğal</span> · " +
      '<span class="ozet yapay">✗ ' + say.yapay + " yapay</span> · " +
      '<span class="ozet yeniden">✎ ' + say.yeniden + " yeniden yaz</span> · " +
      say.bos + " işaretsiz · " + say.uyari + " denetim uyarısı" +
      (den.sahne.length ? '<br><span style="color:var(--kirmizi)">Sahne: ' + den.sahne.map((u) => kacis(KURALLAR[u.kural] + " (" + u.deger + ")")).join(" · ") + "</span>" : "") +
      '<br><span style="color:var(--soluk)">Ölçüm: ' + den.olcum.replik + " replik, konuşma işareti %" + Math.round(den.olcum.dolgu_orani * 100) + ", üç nokta %" + Math.round(den.olcum.uc_nokta_orani * 100) + "</span>";
    kap.innerHTML = "";
    let sonDugum = null;
    for (const x of tumMetin) {
      const i = inceleme[x.id] || {};
      const uy = den.satirlar[x.id] || [];
      const degisti = i.metin && i.metin !== x.m;
      if (incelemeFiltre === "bos" && i.durum) continue;
      if (incelemeFiltre === "sorunlu" && i.durum !== "yapay" && i.durum !== "yeniden") continue;
      if (incelemeFiltre === "uyari" && !uy.length) continue;
      if (incelemeFiltre === "notlu" && !i.not) continue;
      if (incelemeFiltre === "konusma" && !["karakter", "es", "sira", "muhafiz"].includes(x.k)) continue;
      if (x.dugum !== sonDugum) {
        sonDugum = x.dugum;
        const d = sahne.dugumler[x.dugum];
        kap.append(el("div", "igrup", kacis(d ? (EVRE_AD[d.evre] || d.evre) + " · " + d.baslik : "Sıra sabrı olayı") + ' <span class="iid">' + kacis(x.dugum) + "</span>"));
      }
      const row = el("div", "isatir" + (i.durum ? " i-" + i.durum : ""));
      const tur = { satir: "", varyant: "varyant", secenek: "senin seçeneğin", tepki: "tepki" }[x.tur];
      let h = '<div class="ikim">' + kacis(KIM[x.k] || (x.k === "anlati" ? "Anlatı" : x.k)) + (tur ? ' <span class="etiket">' + tur + "</span>" : "") + "</div>";
      h += '<div class="imetin">' + kacis(x.m);
      if (x.kosul) h += ' <span class="etiket">' + kacis(kosulYazi(x.kosul).join(", ")) + "</span>";
      for (const k of uy) h += ' <span class="uyari" title="' + kacis(KURALLAR[k]) + '">' + kacis(k.replace(/_/g, " ")) + "</span>";
      if (degisti) h += ' <span class="uyari" title="İşaretlendikten sonra metin değişti">metin değişti</span>';
      h += "</div>";
      row.innerHTML = h;
      const sag = el("div", "isag");
      sag.append(isaretDugmeleri(x.id, incelemeCiz));
      const not = el("input");
      not.placeholder = "not…";
      not.value = i.not || "";
      not.onchange = () => (isaretle(x.id, undefined, not.value.trim()), incelemeCiz());
      sag.append(not);
      row.append(sag);
      kap.append(row);
    }
  }
  $("incelemeFiltre").onchange = (e) => ((incelemeFiltre = e.target.value), incelemeCiz());
  $("incelemeDisa").onclick = () =>
    indir("inceleme_" + sahne.id + ".json", {
      sahne: sahne.id,
      surum: sahne.surum,
      tarih: new Date().toISOString(),
      isaretler: tumMetin
        .filter((x) => inceleme[x.id])
        .map((x) => Object.assign({ id: x.id, dugum: x.dugum, konusan: x.k, metin: x.m }, { durum: inceleme[x.id].durum || null, not: inceleme[x.id].not || "" })),
    });
  $("incelemeIce").onchange = (e) => {
    const f = e.target.files[0];
    if (!f) return;
    f.text().then((t) => {
      const v = JSON.parse(t);
      for (const x of v.isaretler || []) inceleme[x.id] = { durum: x.durum, not: x.not, metin: x.metin, zaman: v.tarih };
      kaydet();
      incelemeCiz();
    });
  };
  $("incelemeTemizle").onclick = () => {
    if (!confirm("Bütün işaretler ve notlar silinsin mi?")) return;
    inceleme = {};
    kaydet();
    incelemeCiz();
  };

  // ---------------- kapsam ----------------
  function kapsamTara(n) {
    const meslekler = Object.keys(ES_MESLEKLERI);
    const gorulen = new Set(), dugum = new Set(), sonlar = {};
    for (let k = 0; k < n; k++) {
      const b = { mevsim: k % 2 ? "kis" : "yaz", es_meslek: meslekler[k % meslekler.length], tecrube: k % 6, sifahane: k % 4 === 0, haber_sivas: k % 3 === 0, asker: k % 5 === 0 };
      const m = new SozMotoru(sahne, b);
      let adim = 0;
      while (!m.s.bitti && adim++ < 300) {
        const a = m.secenekler().filter((x) => x.acik);
        if (!a.length) break;
        const x = a[Math.floor(Math.random() * a.length)];
        const r = m.sec(x.i);
        if (r && r.zar) m.zarAt(x.i);
      }
      m.s.log.forEach((l) => l.id && gorulen.add(l.id));
      m.s.yol.forEach((y) => dugum.add(y));
      sonlar[m.s.dugum] = (sonlar[m.s.dugum] || 0) + 1;
    }
    return { gorulmeyen: tumMetin.filter((x) => !gorulen.has(x.id)), dugumGorulmeyen: Object.keys(sahne.dugumler).filter((x) => !dugum.has(x)), sonlar, n };
  }

  // ---------------- sekmeler ----------------
  function sekmeAc(ad) {
    document.querySelectorAll("nav button").forEach((b) => b.classList.toggle("etkin", b.dataset.sekme === ad));
    document.querySelectorAll(".sekme").forEach((s) => s.classList.toggle("etkin", s.id === ad));
    if (ad === "agac") {
      if (secili == null) secili = motor.s.dugum;
      agacCiz();
      detayCiz();
    }
    if (ad === "sablon") sablonCiz();
    if (ad === "inceleme") incelemeCiz();
  }
  document.querySelectorAll("nav button").forEach((b) => (b.onclick = () => sekmeAc(b.dataset.sekme)));

  function ciz() {
    logCiz();
    yanCiz();
    secimlerCiz();
  }

  lejantCiz();
  ciz();
})();
