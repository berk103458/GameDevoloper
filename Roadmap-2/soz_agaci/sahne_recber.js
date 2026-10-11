// Söz sistemi taslak sahnesi: Sivaslı reçber Yusuf, ilk karşılaşma.
// Biçim DIY-01a şemasının ilk önerisidir; nihai şema SOZ_SEMASI.md ile kesinleşir.
// Metin kuralları: Roadmap-2/USLUP_REHBERI.md. Denetim: node yapaylik.js
(function (kok) {
  const sahne = {
    id: "recber_yusuf",
    surum: 2,
    baslik: "Sivaslı reçber — ilk karşılaşma",
    karakter: {
      id: "yusuf",
      ad: "Yusuf",
      yas: 38,
      cinsiyet: "erkek",
      sinif: "ciftci",
      koken: "Sivas'ın beri yanı, Yıldız suyu kıyısında bir köy",
      zar: "d6",
      sorgu_degeri: 2,
      cekirdek: "koruma_yalani",
      ses_karti: [
        "Cümleye çoğu zaman \"işte\" ya da \"eh\" ile girer.",
        "\"Ağam\" yalnız bir şey isterken der.",
        "Sıkışınca yoldan, ayağından yakınır, konuyu oraya çeker.",
        "Yer ve insan adlarını dinleyen biliyormuş gibi anar.",
        "Yalanı kısa ve çabuk söyler, sonra konuyu değiştirir. Aynı yalanı iki kez söyler.",
        "\"Neyse\" deyip keser.",
      ],
      istedigi: "Kızıyla birlikte bir çatı altına girmek, köyün tohumunu toprağa vermek.",
      korktugu: "Kızın hasta diye geri çevrilmesi.",
      sir: "Kızı Elif (7) yokuşun dibindeki ardıçlıkta bekliyor; üç gündür ateşli.",
    },
    baslangic: { dugum: "varis", tansiyon: 4, guven: 2, sabir: 10 },

    ipuclari: {
      arkaya_bakti: "Yokuşa dönüp baktı",
      su_sakladi: "Suyun yarısını içmedi",
      ekmek_sakladi: "Ekmeği koynuna sakladı",
      duman: "Üç gecedir ateş yakmamış",
      carik: "Heybede küçük bir çarık",
      sogut: "Heybede söğüt kabuğu",
      yama: "Çarığın tabanı yeni yamanmış",
      agizdan_kacti: "Ağzından \"kız\" kaçtı",
      cabuk_cevap: "Sorunun sonunu beklemeden cevap verdi",
    },

    kurallar: {
      tansiyon_kademeleri: [
        { ad: "Sakin", min: 0, max: 3, ek: 0 },
        { ad: "Gergin", min: 4, max: 7, ek: 1 },
        { ad: "Panik", min: 8, max: 10, ek: 2 },
      ],
      tansiyon_ust: 10,
      guven_ust: 10,
      kacis_dugumu: "kacis",
      varsayilan_basarisiz_etki: { tansiyon: 2, guven: -1 },
      sabir_olayi: {
        satirlar: [
          { k: "sira", m: "Arkadan biri: \"Sabahı mı edeceğiz burada?\"" },
          { k: "anlati", m: "Sıradaki bir kadın çocuğunu sırtına alıp geri dönüyor." },
        ],
        etki: { bayrak: "sira_ayrildi", tansiyon: 1 },
      },
    },

    degistiriciler: [
      { ad: "Sana güveniyor (güven ≥ 6)", kosul: { guven_min: 6 }, deger: -1, yaklasim: ["ikna"] },
      { ad: "Sana hiç güvenmiyor (güven ≤ 1)", kosul: { guven_max: 1 }, deger: 1, yaklasim: ["ikna"] },
      { ad: "Elinde kanıt: yamalı çarık", kosul: { ipucu: "yama" }, deger: -1, yaklasim: ["ikna", "gozdagi"] },
      { ad: "Tohumu zorla aldın", kosul: { bayrak: "tohum_zorla" }, deger: 2, yaklasim: ["ikna"] },
      { ad: "Tohumu zorla aldın, senden korkuyor", kosul: { bayrak: "tohum_zorla" }, deger: -1, yaklasim: ["gozdagi"] },
      { ad: "Yanında asker var", kosul: { baglam: { asker: true } }, deger: -1, yaklasim: ["gozdagi"] },
    ],

    dugumler: {
      // ---------------- VARIŞ VE SELAM ----------------
      varis: {
        evre: "varis",
        baslik: "Varış",
        satirlar: [
          {
            k: "anlati",
            m: "Yokuştan biri çıkıyor. Sırtında bir çuval, göğsünde küçük bir kese tutuyor. Kapıya birkaç adım kala çuvalı yere koyup eğiliyor, soluklanıyor.",
            varyant: [
              {
                kosul: { baglam: { mevsim: "kis" } },
                m: "Yokuştan biri çıkıyor. Kar dizine kadar. Sırtında bir çuval, göğsünde küçük bir kese. Kapıya birkaç adım kala çuvalı bırakıp eğiliyor, soluklanıyor.",
              },
            ],
          },
          { k: "karakter", m: "Selamün aleyküm." },
        ],
        secenekler: [
          {
            metin: "Aleyküm selam. Gel, soluklan.",
            hedef: "selam_su",
            etki: { tansiyon: -1, guven: 1 },
            neden: "Selamı almak usuldür. Korku düşer, güven başlar; karakter isteğini söyler.",
          },
          {
            metin: "Hop, orada dur bakalım. Kimlerdensin?",
            hedef: "selam_sert",
            etki: { tansiyon: 1 },
            neden: "Selamı almamak. Karakter savunmaya geçer, adını hemen söyler, isteğini yutar.",
          },
          {
            metin: "(Sus. Bekle.)",
            hedef: "selam_sessiz",
            neden: "Susmak da cevaptır. Boşluğu karakter doldurur; muhafız onu izleme fırsatı bulur.",
          },
        ],
      },

      selam_su: {
        evre: "selam",
        baslik: "Su isteği",
        satirlar: [
          {
            k: "karakter",
            m: "Eh, Allah razı olsun. Bir tas su olur mu, ağam? Dilim damağıma yapıştı.",
            varyant: [
              { kosul: { baglam: { mevsim: "kis" } }, m: "Allah razı olsun. Bir tas su olur mu, ağam? Bir de şu ateşe biraz yanaşsam… Ellerimi duymuyorum." },
            ],
          },
        ],
        secenekler: [
          {
            metin: "(Testiyi uzat.)",
            hedef: "ikram_su",
            etki: { tansiyon: -1, guven: 1, bayrak: "ikram" },
            neden: "En küçük ikram. Sezgisi olan muhafız suyun yarıda bırakıldığını fark eder.",
          },
          {
            metin: "(Su ile bir dilim ekmek ver.)",
            hedef: "ikram_ekmek",
            etki: { tansiyon: -1, guven: 2, bayrak: ["ikram", "ekmek_verildi"], kaynak: { gida: -1 }, hatirla: "Kapıda ekmek verdin." },
            neden: "Bedeli olan ikram (1 gıda). Güveni daha çok artırır ve hatırlanır.",
          },
          {
            metin: "(Ateş başına çağır.)",
            kosul: { baglam: { mevsim: "kis" } },
            hedef: "ikram_ates",
            etki: { tansiyon: -2, guven: 2, sabir: -1, bayrak: ["ikram", "ates"] },
            neden: "Yalnız kışın. Ateş başı zaman alır (sabır −1) ama üşümüş adamı en çok bu açar.",
          },
          {
            metin: "Su içeride. Önce bir konuşalım.",
            hedef: "ikram_ret",
            etki: { tansiyon: 1, guven: -1 },
            neden: "İkramı şarta bağlamak. Karakter yine konuşur ama ikram ipuçları hiç açılmaz.",
          },
        ],
      },

      selam_sert: {
        evre: "selam",
        baslik: "Sert karşılama",
        satirlar: [
          { k: "karakter", m: "Yusuf derler. Sivas tarafından." },
          { k: "karakter", m: "(Ellerini açıp gösterir.) Bir şeyim yok, bak. Bıçak bile yok. Yolda sattım onu." },
          { k: "anlati", m: "Kesenin olduğu eli göğsünden ayırmıyor." },
        ],
        etki: { beyan: { id: "ad", metin: "Adı Yusuf, Sivas tarafından." } },
        secenekler: [
          {
            metin: "Peki. İç bir su, sonra konuşuruz.",
            hedef: "ikram_su",
            etki: { tansiyon: -1, guven: 1, bayrak: "ikram" },
            neden: "Sert başlayıp ikrama dönmek korkuyu geri alır.",
          },
          {
            metin: "Sorularıma gel.",
            hedef: "konular",
            neden: "İkramsız doğrudan sorgu. İkramla açılan ipuçları kaçar.",
          },
        ],
      },

      selam_sessiz: {
        evre: "selam",
        baslik: "Sessiz karşılama",
        satirlar: [
          { k: "anlati", m: "Bir süre bakışıyorsunuz. Adam gözünü kaçırmıyor. Bir ara dönüp yokuşun dibine bakıyor." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Arkasına baktı. Biri mi var orada?",
            etki: { ipucu: "arkaya_bakti" },
          },
          { k: "karakter", m: "Selamı almadın ama… neyse. Bir tas su verir misin, ağam?" },
        ],
        secenekler: [
          {
            metin: "(Testiyi uzat.)",
            hedef: "ikram_su",
            etki: { tansiyon: -1, guven: 1, bayrak: "ikram" },
            neden: "Susup sonra su vermek: hem izledin hem yumuşattın.",
          },
          {
            metin: "Önce kim olduğunu söyle.",
            hedef: "selam_sert",
            etki: { tansiyon: 1 },
            neden: "Sessizliğin ardından sertlik korkuyu artırır.",
          },
        ],
      },

      // ---------------- İKRAM ----------------
      ikram_su: {
        evre: "ikram",
        baslik: "Su",
        satirlar: [
          { k: "anlati", m: "Testiyi iki eliyle alıyor. Birkaç yudum içiyor, sonra duruyor. Kalanına dokunmadan geri uzatıyor." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 2 },
            m: "Dudakları çatlamış ama içmedi. Kime ayırıyor bunu?",
            etki: { ipucu: "su_sakladi" },
          },
          { k: "karakter", m: "Sağ ol. Sor bakalım ne soracaksan." },
        ],
        sonraki: "konular",
      },

      ikram_ekmek: {
        evre: "ikram",
        baslik: "Ekmek",
        satirlar: [
          { k: "anlati", m: "Ekmeği alıp öpüyor, alnına götürüyor. Bir ısırık alıyor, gerisini koynuna sokuyor." },
          { k: "karakter", m: "Bunu unutmam ben. Sor ne soracaksan." },
        ],
        etki: { ipucu: "ekmek_sakladi" },
        sonraki: "konular",
      },

      ikram_ates: {
        evre: "ikram",
        baslik: "Ateş başı",
        satirlar: [
          { k: "anlati", m: "Ateşe yanaşınca elleri titremeye başlıyor. Bir süre konuşmadan avuçlarını alevin üstünde tutuyor." },
          { k: "karakter", m: "Üç gecedir ateş yakamadım. Duman görünür diye." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Duman görünür diye… Kimden saklanıyor? Yoksa birini mi saklıyor?",
          },
        ],
        etki: { ipucu: "duman" },
        sonraki: "konular",
      },

      ikram_ret: {
        evre: "ikram",
        baslik: "İkram yok",
        satirlar: [
          { k: "karakter", m: "Peki, sen bilirsin." },
          { k: "anlati", m: "Dudaklarını yalayıp çuvalın üstüne çöküyor." },
        ],
        sonraki: "konular",
      },

      // ---------------- KONU MERKEZİ ----------------
      konular: {
        evre: "konular",
        baslik: "Konu merkezi",
        satirlar: [
          {
            k: "anlati",
            m: "Yusuf çuvalın yanında bekliyor.",
            varyant: [
              { kosul: { sabir_max: 3 }, m: "Yusuf çuvalın yanında bekliyor. Arkadakiler söylenmeye başladı." },
              { kosul: { bayrak: "sir_acik" }, m: "Yusuf gözünü yokuştan ayırmıyor." },
            ],
          },
        ],
        secenekler: [
          { metin: "Nereden geldin?", hedef: "k_nereden", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. İlk katman kısa; üstelenirse derinleşir." },
          { metin: "Neden yola düştün?", hedef: "k_neden", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Güven yüksekse ağzından bir şey kaçar; sonunda Yusuf da soru sorar." },
          {
            metin: "Kiminle geldin?",
            kesilir: "Kiminle gel",
            hedef: "k_kiminle",
            tukenir: true,
            etki: { sabir: -1, ipucu: "cabuk_cevap" },
            neden: "Söz kesme: Yusuf sorunun sonunu beklemeden 'Yalnızım' der. Bu çabukluk kendi başına ipucudur.",
          },
          { metin: "Ne iş bilirsin?", hedef: "k_is", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Meslek beyanı ve dolaylı ipucu (söğüt kabuğu)." },
          { metin: "Sırtındaki ne?", hedef: "k_yuk", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Tohum ancak kese sorulursa açılır." },
          { metin: "Yolda ne gördün?", hedef: "k_yol", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Yusuf dağınık anlatır; muhafız sözünü kesebilir." },
          {
            metin: "Sivas'tan ne haber?",
            kosul: { baglam: { haber_sivas: true } },
            hedef: "k_haber",
            tukenir: true,
            etki: { sabir: -1 },
            neden: "Haber konusu yalnız dünya olayı açıksa görünür (DNY).",
          },
          {
            metin: "(Heybesine bak.)",
            hedef: "heybe",
            tukenir: true,
            etki: { tansiyon: 1, guven: -1, sabir: -1 },
            neden: "Aranmak korkuyu artırır, güveni düşürür. Heybedeki eşya beyanla çelişebilir.",
          },
          {
            metin: "(Bekle. Bir şey söyleyecek gibi.)",
            kosul: { guven_min: 7, bayrak_yok: "sir_acik" },
            hedef: "itiraf",
            neden: "Güven yeterince yüksekse karakter sırrını kendisi açar; yüzleşme ve zar gerekmez.",
          },
          {
            metin: "Yalnızım dedin. Bu çarık kimin?",
            kosul: { ipucu: "carik", beyan: "yalniz", bayrak_yok: "sir_acik" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_carik" },
            neden: "Yüzleşme: 'Yalnızım' beyanı ile heybedeki çarık çelişiyor.",
          },
          {
            metin: "Suyu kime ayırdın?",
            kosul: { ipucu: "su_sakladi", beyan: "yalniz", bayrak_yok: "sir_acik" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_su" },
            neden: "Yüzleşme: sezgiyle görülen davranış ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Ekmeği kime sakladın?",
            kosul: { ipucu: "ekmek_sakladi", beyan: "yalniz", bayrak_yok: "sir_acik" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_ekmek" },
            neden: "Yüzleşme: ikram sırasında görülen davranış ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Dumanı kimden saklıyorsun?",
            kosul: { ipucu: "duman", beyan: "yalniz", bayrak_yok: "sir_acik" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_duman" },
            neden: "Yüzleşme: ateş başında söylenen ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Bir kız dedin. Kim o?",
            kosul: { ipucu: "agizdan_kacti", beyan: "yalniz", bayrak_yok: "sir_acik" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_kiz" },
            neden: "Yüzleşme: ağzından kaçan söz ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Kıza bir bakalım.",
            kosul: { bayrak: "sir_acik" },
            hedef: "ikilem",
            neden: "Sır açıldıysa karar ikilem düğümünde verilir.",
          },
          {
            metin: "Tamam. Kararımı vereceğim.",
            kosul: { bayrak_yok: "sir_acik" },
            hedef: "karar",
            neden: "Sır açılmadan karar. Sonuç, kapıda görülmeyen şeye göre sonradan değişir.",
          },
        ],
      },

      // ---------------- KONULAR ----------------
      k_nereden: {
        evre: "konu",
        baslik: "Nereden · 1",
        satirlar: [
          {
            k: "karakter",
            m: "Sivas'tan… Sivas'ın beri yanından. Yıldız suyu var ya, onun kıyısında bir köy.",
            varyant: [{ kosul: { beyan: "ad" }, m: "Dedim ya, Sivas tarafı. Yıldız suyu var ya, onun kıyısında bir köy." }],
          },
          { k: "karakter", m: "Bilmezsin sen orayı." },
        ],
        etki: { beyan: { id: "koken", metin: "Sivas'ın beri yanından, Yıldız suyu kıyısında bir köyden." } },
        secenekler: [
          {
            metin: "Ne oldu köye?",
            hedef: "k_nereden_2",
            etki: { tansiyon: 1, sabir: -1 },
            neden: "Üstelemek ikinci katmanı açar; bedeli korku ve sabır.",
          },
          { metin: "Yorgunsun. Geçelim bunu.", hedef: "konular", etki: { tansiyon: -1, guven: 1 }, neden: "Acıyı kurcalamamak güven verir." },
          { metin: "Başka bir şey soracağım.", hedef: "konular", neden: "Konudan çıkılır." },
        ],
      },
      k_nereden_2: {
        evre: "konu",
        baslik: "Nereden · 2",
        satirlar: [
          { k: "karakter", m: "Ne olacak. Yaktılar." },
          { k: "karakter", m: "Kösedağ'dan sonra asker dağıldı, önlerinde kimse kalmadı. Bizim köye üç gün sonra geldiler." },
          { k: "karakter", m: "Neyse. Sorma gerisini." },
        ],
        etki: { beyan: { id: "mogol", metin: "Köyünü Kösedağ'dan üç gün sonra Moğollar yakmış." } },
        secenekler: [
          { metin: "Sormam.", hedef: "konular", etki: { tansiyon: -1, guven: 1 }, neden: "'Sorma' dediyse bu bir bilgidir. Saygı güven getirir." },
          {
            metin: "Anlat. Bilmem lazım.",
            hedef: "k_nereden_3",
            etki: { tansiyon: 2, guven: -2, sabir: -1 },
            neden: "Üçüncü katman zorla açılır. Acı bir bilgi verir, güveni düşürür, hatırlanır.",
          },
        ],
      },
      k_nereden_3: {
        evre: "konu",
        baslik: "Nereden · 3",
        satirlar: [
          { k: "anlati", m: "Bir süre bir şey demiyor. Gözü kesede." },
          { k: "karakter", m: "Avradım ahırdaydı. Ben tarladaydım. Döndüğümde…" },
          { k: "karakter", m: "Yeter mi bu kadar?" },
        ],
        etki: {
          bayrak: "es_oldu",
          beyan: { id: "dul", metin: "Karısı köy yandığında ölmüş." },
          hatirla: "Acısını zorla söylettin.",
        },
        sonraki: "konular",
      },

      k_neden: {
        evre: "konu",
        baslik: "Neden",
        satirlar: [
          { k: "karakter", m: "Ne yapaydım, külün başında oturup bekleyeyim mi?" },
          {
            k: "karakter",
            m: "Bir de şu tohum var. Güz gelmeden yere girmezse kurt düşer içine, gider.",
            varyant: [
              { kosul: { baglam: { mevsim: "kis" } }, m: "Bir de şu tohum var. Kışı bir çatı altında geçirmezse baharda ekecek bir şey kalmaz." },
              { kosul: { bayrak: "tohum_biliniyor" }, m: "Bir de tohum işte. Söyledim sana." },
            ],
          },
          {
            k: "karakter",
            kosul: { guven_min: 5 },
            m: "Hem kız da… (Durur.) Neyse. Yol işte.",
            etki: { ipucu: "agizdan_kacti" },
          },
          { k: "karakter", m: "Sen? Sen buralı mısın? Bu kapı kimin kapısı?" },
        ],
        secenekler: [
          {
            metin: "Beyin kapısı. Beratı var, sığınana açık.",
            hedef: "konular",
            etki: { soylenen: { id: "berat", metin: "Kapının Bey'in beratıyla sığınana açık olduğunu söyledin." }, guven: 1 },
            tepki: [{ k: "karakter", m: "Beratlı kapı… İyi. Yolda duymuştuk, batıda böyle bir yer var diye." }],
            neden: "Karşı soru: muhafızın söylediği kayda geçer; karar anında Yusuf buna dayanır.",
          },
          {
            metin: "Ben de senin gibi geldim bir zaman. Şimdi kapıyı ben tutuyorum.",
            hedef: "konular",
            etki: { soylenen: { id: "gecmis", metin: "Senin de bir zaman kapıya sığınan biri olduğunu söyledin." }, guven: 2 },
            tepki: [{ k: "karakter", m: "(Yüzüne uzun uzun bakar.) Öyle mi… Eh, o zaman bilirsin sen." }],
            neden: "Kendinden bir şey vermek güveni en çok artıran cevaptır. Dedikoduya karışabilir.",
          },
          {
            metin: "Soruyu ben sorarım.",
            hedef: "konular",
            etki: { guven: -1, tansiyon: 1 },
            tepki: [{ k: "karakter", m: "Peki, peki." }],
            neden: "Karşı soruyu geri çevirmek güveni düşürür.",
          },
          {
            metin: "Hangi tohum?",
            kosul: { bayrak_yok: "tohum_biliniyor" },
            hedef: "k_yuk_tohum",
            etki: { sabir: -1 },
            neden: "Soruyu cevapsız bırakıp ağzından kaçan söze gitmek.",
          },
        ],
      },

      k_kiminle: {
        evre: "konu",
        baslik: "Kiminle",
        satirlar: [
          { k: "karakter", m: "Yalnızım. Yalnız geldim." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 2 },
            m: "Sorunun sonunu bile beklemedi.",
            varyant: [{ kosul: { tecrube_min: 2, ipucu: "arkaya_bakti" }, m: "Sorunun sonunu beklemedi. Az önce de yokuşa bakmıştı." }],
          },
        ],
        etki: { beyan: { id: "yalniz", metin: "Yalnız geldiğini söyledi." } },
        secenekler: [
          {
            metin: "Yolda da mı yalnızdın?",
            hedef: "k_kiminle_2",
            etki: { tansiyon: 1, sabir: -1 },
            neden: "Üstelemek: yalanın etrafına doğru bilgiler eklenir.",
          },
          { metin: "Peki.", hedef: "konular", neden: "Beyan defterde kalır." },
        ],
      },
      k_kiminle_2: {
        evre: "konu",
        baslik: "Kiminle · 2",
        satirlar: [
          { k: "karakter", m: "Yola yedi ev çıktık. Tokat yolunda ayrıldık. Onlar Niksar'a doğru gitti, ben bu yana." },
          { k: "karakter", m: "Hüseyin'in oğlanları da onlarla. Allah bilir şimdi neredeler." },
        ],
        etki: { beyan: { id: "yedi_hane", metin: "Yedi evle yola çıkmış, Tokat yolunda ayrılmışlar." } },
        sonraki: "konular",
      },

      k_is: {
        evre: "konu",
        baslik: "İş",
        satirlar: [
          { k: "karakter", m: "Toprak işte. Darı ekerdik çoğu, biraz da arpa." },
          { k: "karakter", m: "Harman zamanı beni çağırırlardı. Savurmayı bilirim." },
          { k: "sezgi", kosul: { tecrube_min: 1 }, m: "Avuçlarının içi yarık yarık. Bu el toprak eli." },
        ],
        etki: { beyan: { id: "ciftci", metin: "Çiftçi; darı ve arpa ekermiş, harman savurmayı bilirmiş." } },
        secenekler: [
          { metin: "Başka ne bilirsin?", hedef: "k_is_2", etki: { sabir: -1 }, neden: "İkinci katman, dolaylı bir ipucu verir." },
          { metin: "İyi. Tarlaya el lazım.", hedef: "konular", etki: { tansiyon: -1, guven: 1 }, neden: "Değer görmek yumuşatır." },
        ],
      },
      k_is_2: {
        evre: "konu",
        baslik: "İş · 2",
        satirlar: [
          { k: "karakter", m: "Başka ne bileyim… Anam söğüt kabuğu kaynatırdı, ateşi olana içirirdi. Onu bilirim." },
          { k: "karakter", m: "O da iş mi sayılır." },
          { k: "sezgi", kosul: { ipucu: "sogut" }, m: "Heybedeki söğüt kabuğu. Kimin ateşi var?" },
        ],
        etki: { beyan: { id: "sogut_bilgi", metin: "Söğüt kabuğundan ateş ilacı kaynatmayı biliyor." } },
        sonraki: "konular",
      },

      k_yuk: {
        evre: "konu",
        baslik: "Yük",
        satirlar: [
          { k: "karakter", m: "Darı. Yolda yedik yarısını, bu kadar kaldı." },
          { k: "anlati", m: "Göğsündeki keseyi biraz daha sıkıyor." },
        ],
        etki: { beyan: { id: "dari", metin: "Sırtında darı var; yarısını yolda yemişler." } },
        secenekler: [
          {
            metin: "O kesede ne var?",
            kosul: { bayrak_yok: "tohum_biliniyor" },
            hedef: "k_yuk_tohum",
            etki: { sabir: -1 },
            neden: "Görülen davranış (keseyi sıkmak) yeni konu açar.",
          },
          { metin: "Peki.", hedef: "konular", neden: "Konudan çıkılır." },
        ],
      },
      k_yuk_tohum: {
        evre: "konu",
        baslik: "Tohum",
        satirlar: [
          { k: "karakter", m: "Tohum o. (Keseye bakar.) Benim değil ama. Köyün." },
          { k: "karakter", m: "Çıkarken her ev bir avuç koydu. \"Yusuf, sen götür, bir yer bulursan ek\" dediler. Eh, söz verdik bir kere." },
        ],
        etki: { bayrak: "tohum_biliniyor", beyan: { id: "tohum", metin: "Kesede köyün ortak tohumu var; ekip geridekilerle paylaşacağına söz vermiş." } },
        secenekler: [
          {
            metin: "İçeri girersen o tohum ambara girer.",
            hedef: "tohum_ambar",
            neden: "Pazarlık: karakter şart koşar, muhafızdan söz ister.",
          },
          {
            metin: "Söz verdiysen tut.",
            hedef: "konular",
            etki: { tansiyon: -1, guven: 2, hatirla: "Tohumuna dokunmadın." },
            neden: "Sözüne saygı. Güven artar, hatırlanır; dönüş olayında karşılığı olur.",
          },
          {
            metin: "O keseyi burada bırakırsın, yoksa giremezsin.",
            zar: { yaklasim: "gozdagi", tur: "tek_sans", basari: "tohum_alindi", basarisiz: "tohum_direnc", basarisiz_etki: { tansiyon: 2, guven: -2 } },
            neden: "Gözdağı, tek şans. Başarırsa tohum alınır ama güven çöker, dedikodu doğar.",
          },
        ],
      },
      tohum_ambar: {
        evre: "konu",
        baslik: "Tohum pazarlığı",
        satirlar: [
          { k: "anlati", m: "Bir süre düşünüyor." },
          { k: "karakter", m: "Ambara koyayım, peki. Ama ilk ekimi ben yaparım. Geridekiler gelirse onların payı ayrılır. Sözün olsun bu." },
        ],
        secenekler: [
          {
            metin: "Sözüm olsun.",
            hedef: "konular",
            etki: { bayrak: "tohum_soz", guven: 2, hatirla: "Yusuf'a tohum için söz verdin." },
            tepki: [{ k: "karakter", m: "Eh. Tamam o zaman." }],
            neden: "Söz kişi hafızasına yazılır; tutulmazsa dönüşte hesabı sorulur.",
          },
          {
            metin: "Söz veremem. Ambar köyün.",
            hedef: "konular",
            etki: { tansiyon: 2, guven: -1 },
            tepki: [{ k: "anlati", m: "Başını sallıyor, bir şey demiyor." }],
            neden: "Köyün çıkarı önde; güven düşer.",
          },
        ],
      },
      tohum_alindi: {
        evre: "konu",
        baslik: "Tohum zorla",
        satirlar: [
          { k: "anlati", m: "Keseyi yere koyuyor. Elleri titriyor." },
          { k: "karakter", m: "Al bakalım. Geridekilere ne diyeceğim ben şimdi?" },
        ],
        etki: {
          bayrak: "tohum_zorla",
          guven: -3,
          kaynak: { tohum: 1 },
          hatirla: "Tohumu zorla aldın.",
          dedikodu: "Muhafız bir garibin tohumunu kapıda aldı.",
        },
        sonraki: "konular",
      },
      tohum_direnc: {
        evre: "konu",
        baslik: "Tohum direnci",
        satirlar: [{ k: "karakter", m: "Yok. Bunu vermem. Döner giderim, yine vermem." }],
        sonraki: "konular",
      },

      k_yol: {
        evre: "konu",
        baslik: "Yol",
        satirlar: [
          { k: "karakter", m: "Ne göreceğim, yanık köy. Bir de… Kızılca yokuşunu çıkınca bir han var ya, onun önünde üç adam asmışlar. Biri bizim köyden Ömer'in damadıydı galiba, tam seçemedim. Kaçtı diye asmışlar. Hancı dedi ki…" },
        ],
        etki: { beyan: { id: "yol", metin: "Yolda, Kızılca yokuşundaki hanın önünde kaçak diye asılmış adamlar görmüş." } },
        secenekler: [
          {
            metin: "Tamam, tamam. Anladım.",
            kesme: true,
            hedef: "konular",
            etki: { sabir: 1, guven: -1 },
            tepki: [{ k: "karakter", m: "Eh… peki." }],
            neden: "Söz kesme: sıra sabrını kurtarır ama karakter susturulduğunu hisseder ve hancının sözünü duymazsın.",
          },
          { metin: "Ne dedi hancı?", hedef: "k_yol_2", etki: { sabir: -1, guven: 1 }, neden: "Dinlemek: zaman alır, güven verir, berat bilgisine bağlanır." },
        ],
      },
      k_yol_2: {
        evre: "konu",
        baslik: "Yol · 2",
        satirlar: [
          { k: "karakter", m: "Dedi ki batıda bir bey kapısını açmış, kaçan gelsin demiş. Gidin oraya dedi." },
          { k: "karakter", m: "Biz de geldik işte." },
        ],
        etki: { beyan: { id: "hanci", metin: "Hancı, batıdaki bir beyin kapısını kaçanlara açtığını söylemiş." } },
        sonraki: "konular",
      },
      k_haber: {
        evre: "konu",
        baslik: "Haber",
        satirlar: [
          { k: "karakter", m: "Duydum duymasına. Şehirliler altın verip kurtarmışlar kendilerini." },
          { k: "karakter", m: "Bize soran olmadı tabii." },
        ],
        etki: { beyan: { id: "haber", metin: "Sivas'ın fidyeyle kurtulduğunu, köylere soran olmadığını söyledi." } },
        sonraki: "konular",
      },

      // ---------------- HEYBE ----------------
      heybe: {
        evre: "heybe",
        baslik: "Heybe",
        satirlar: [
          { k: "anlati", m: "Heybede kuru ekmek kırıntısı, bir çakmak taşı, bir avuç söğüt kabuğu var." },
          { k: "anlati", m: "Bir de küçük bir çarık. Çocuk ayağı kadar." },
          { k: "karakter", m: "O mu? Yolda buldum. Yanmış bir evin önündeydi, aldım işte. Belki lazım olur dedim." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Çarığın tabanı yeni yamanmış. Yolda bulunan çarığa kim yama vurur?",
            etki: { ipucu: "yama" },
          },
        ],
        etki: { ipucu: ["carik", "sogut"], beyan: { id: "carik_yol", metin: "Çarığı yolda yanmış bir evin önünde bulduğunu söyledi." } },
        sonraki: "konular",
      },

      // ---------------- YÜZLEŞME ----------------
      yuzles: {
        evre: "yuzlesme",
        baslik: "Yüzleşme",
        satirlar: [
          {
            k: "anlati",
            m: "Yusuf bir şey demiyor. Yokuşun dibine bakıyor.",
            varyant: [{ kosul: { ipucu: "yama", bayrak: "yuz_carik" }, m: "Yusuf bir şey demiyor. Gözü senin elindeki çarıkta." }],
          },
          { k: "karakter", kosul: { tansiyon_min: 8 }, m: "Bırak beni. Giderim ben, kapına gelmedim say." },
        ],
        secenekler: [
          {
            metin: "Doğruyu söylersen kapıyı kapatmam. Söz.",
            zar: { yaklasim: "ikna", tur: "tekrar", basari: "sir_acildi", basarisiz: "yuzles_inkar" },
            neden: "İkna, tekrar denenebilir. Başarı sırrı güvenle ve tam açar. Her başarısızlık korkuyu artırır.",
          },
          {
            metin: "Söylemezsen ne olacağını biliyorsun.",
            zar: {
              yaklasim: "gozdagi",
              tur: "tek_sans",
              basari: "sir_acildi_korku",
              basarisiz: "yuzles_inkar",
              basarisiz_etki: { tansiyon: 3, guven: -2 },
            },
            neden: "Gözdağı, tek şans. Sır korkuyla açılır ve eksik açılır: hastalığı saklar.",
          },
          {
            metin: "(Sus. Bekle.)",
            kosul: { tansiyon_max: 3 },
            hedef: "sir_acildi",
            tukenir: true,
            neden: "Susmak cevaptır: karakter sakinse sessizlik itiraf getirir, zar gerekmez.",
          },
          {
            metin: "(Sus. Bekle.)",
            kosul: { tansiyon_min: 4 },
            hedef: "yuzles_sessiz",
            tukenir: true,
            etki: { tansiyon: 1 },
            neden: "Aynı sessizlik gergin karaktere tehdit gibi gelir: kapanır.",
          },
          {
            metin: "İstemiyorsan söyleme.",
            hedef: "konular",
            etki: { tansiyon: -1, guven: 1 },
            neden: "Geri çekilmek güven verir; güven 7'ye çıkarsa karakter kendisi anlatır.",
          },
        ],
      },
      yuzles_sessiz: {
        evre: "yuzlesme",
        baslik: "Kapanma",
        satirlar: [{ k: "karakter", m: "Ne bakıyorsun öyle? Yalnızım dedim ya." }],
        sonraki: "yuzles",
      },
      yuzles_inkar: {
        evre: "yuzlesme",
        baslik: "İnkâr",
        satirlar: [{ k: "karakter", m: "Dedim ya sana. Daha ne diyeyim?" }],
        sonraki: "yuzles",
      },

      // ---------------- SIR ----------------
      itiraf: {
        evre: "sir",
        baslik: "Kendiliğinden itiraf",
        satirlar: [
          { k: "anlati", m: "Eğilip çarığının bağını çözüyor, yeniden bağlıyor." },
          { k: "karakter", m: "Ağam… sana bir şey diyeceğim de. Kızmazsan." },
        ],
        etki: { hatirla: "Yusuf sırrını sana kendisi açtı." },
        sonraki: "sir_acildi",
      },
      sir_acildi: {
        evre: "sir",
        baslik: "Sır: Elif",
        satirlar: [
          { k: "anlati", m: "Omuzları düşüyor." },
          { k: "karakter", m: "Kızım var. Elif. Yedisine bastı bu bahar." },
          { k: "karakter", m: "Aşağıda, ardıçların orada bekliyor. Üç gündür ateşi var, yürüyemedi." },
          {
            k: "karakter",
            m: "Hasta dersem almazsın diye…",
            varyant: [{ kosul: { bayrak: "es_oldu" }, m: "Anası gitti zaten. Bir o kaldı bana." }],
          },
        ],
        etki: {
          bayrak: ["sir_acik", "ates_biliniyor"],
          tansiyon: -2,
          guven: 1,
          beyan: { id: "kizi_var", metin: "Kızı Elif (7) ardıçlıkta bekliyor; üç gündür ateşli." },
        },
        sonraki: "ikilem",
      },
      sir_acildi_korku: {
        evre: "sir",
        baslik: "Sır: korkuyla, eksik",
        satirlar: [
          { k: "anlati", m: "Dizlerinin üstüne çöküyor." },
          { k: "karakter", m: "Kızım… Aşağıda, ardıçların orada. Yoruldu, yürüyemedi. Bir şey yapma ona." },
          { k: "sezgi", kosul: { tecrube_min: 3 }, m: "\"Yoruldu\" derken sesi titredi. Yorgunluktan fazlası var." },
        ],
        etki: {
          bayrak: ["sir_acik", "korkuyla"],
          tansiyon: 1,
          beyan: { id: "kizi_var", metin: "Kızı ardıçlıkta bekliyor; yorulduğunu söyledi." },
          hatirla: "Sırrını korkutarak aldın.",
          dedikodu: "Muhafız bir babayı kapıda dize getirdi.",
        },
        sonraki: "ikilem",
      },

      // ---------------- İKİLEM VE KARAR ----------------
      ikilem: {
        evre: "ikilem",
        baslik: "İkilem: aşağıdaki çocuk",
        satirlar: [
          {
            k: "anlati",
            m: "Aşağıda bir çocuk bekliyor. Babası \"yoruldu\" diyor.",
            varyant: [
              { kosul: { bayrak: "ates_biliniyor" }, m: "Ateşli bir çocuk. Köyde öksürük başlarsa kış uzun geçer. Ama aşağıda, ardıçların altında bir gece daha…" },
            ],
          },
          {
            k: "es",
            kosul: { es_meslek: "sifaci" },
            m: "(Yanına gelmiş.) Çocuğu bir görsem iyi olur.",
            varyant: [{ kosul: { es_meslek: "sifaci", bayrak: "ates_biliniyor" }, m: "(Yanına gelmiş.) Ateşi görmeden bir şey diyemem. Getirsinler, bakarım." }],
          },
          {
            k: "es",
            kosul: { es_meslek: ["dokumaci", "firinci", "bostanci", "sutcu", "yun_egirici"], bayrak: "ates_biliniyor" },
            m: "(Yanına gelmiş.) Çocuğu dışarıda bırakma. Ama köyde şifa bilen yok, onu da düşün.",
          },
        ],
        secenekler: [
          {
            metin: "Getir çocuğu, bir göreyim.",
            kosul: { bayrak_yok: "ates_biliniyor" },
            hedef: "cocuk_gorulur",
            tukenir: true,
            neden: "Korkuyla açılan eksik sırrı gözle tamamlamak.",
          },
          {
            metin: "İkiniz de girin. Kızı doğru eşime götürün.",
            kosul: { es_meslek: "sifaci" },
            hedef: "son_kabul_es",
            neden: "Eşin şifacıysa açılır: risk en az, bedel eşin iki günü.",
          },
          {
            metin: "İkiniz de girin. Kız şifahanede yatsın.",
            kosul: { baglam: { sifahane: true }, bayrak: "ates_biliniyor" },
            hedef: "son_kabul_sifahane",
            neden: "Köyde şifahane varsa ve hastalık biliniyorsa açılır.",
          },
          { metin: "İkiniz de girin.", hedef: "son_kabul_risk", neden: "Merhamet; köye hastalık riski girer. Ateş bilinmiyorsa risk gizli girer." },
          {
            metin: "Kız üç gece ahırın yanında ayrı yatsın, sonra girer.",
            kosul: { bayrak: "ates_biliniyor" },
            hedef: "son_karantina",
            neden: "Orta yol: risk yok, güven orta. Hastalık bilinmeden bu seçenek akla gelmez.",
          },
          { metin: "Sen girebilirsin. Kız giremez.", hedef: "son_bol", neden: "Aileyi bölmek. Karakter kabul etmez; dedikodu doğar." },
          {
            metin: "Tohumun yarısını verirsen ikiniz de girersiniz.",
            kosul: { bayrak: "tohum_biliniyor", bayrak_yok: "tohum_zorla" },
            hedef: "son_rusvet",
            neden: "Rüşvet: köy tohum kazanır, muhafız terazisi yozlaşmaya kayar.",
          },
          { metin: "İkinizi de alamam. Yolunuz açık olsun.", hedef: "son_ret", neden: "Köyün güvenliği önde." },
          { metin: "Dur. Bir şey daha soracağım.", hedef: "konular", neden: "Karar ertelenir; sır açıkken konular farklı tonla sürer." },
        ],
      },
      cocuk_gorulur: {
        evre: "ikilem",
        baslik: "Çocuğu görmek",
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşu koşarak iniyor, kucağında bir kızla dönüyor. Kızın yanakları kıpkırmızı, dudakları kuru." },
          { k: "anlati", m: "Elini alnına koyunca sıcaklığı parmaklarına vuruyor." },
          { k: "karakter", m: "Yorgun işte… (Gözünü kaçırır.)" },
        ],
        etki: { bayrak: "ates_biliniyor" },
        sonraki: "ikilem",
      },

      karar: {
        evre: "karar",
        baslik: "Karar (sır açılmadan)",
        satirlar: [
          { k: "anlati", m: "Yusuf çuvalı omuzlamaya hazır, bekliyor." },
          { k: "karakter", kosul: { soylenen: "berat" }, m: "Beratlı kapı dedin. Ona güvenip geldim." },
        ],
        secenekler: [
          { metin: "Gir. Sana da yer var.", hedef: "son_kabul_yalniz", neden: "Kabul; ama kapıda görülmeyen kız gece gelir." },
          {
            metin: "Tohumun yarısını ver, kapı açılsın.",
            kosul: { bayrak: "tohum_biliniyor", bayrak_yok: "tohum_zorla" },
            hedef: "son_rusvet_yalniz",
            neden: "Rüşvet, sır bilinmeden.",
          },
          {
            metin: "Olmaz. Bu kapıdan giremezsin.",
            hedef: "son_ret_bilmeden",
            neden: "Ret; neyin geri çevrildiği sonradan görülür. Berat söylendiyse sözün çiğnenmiş olur.",
          },
          { metin: "Dur. Bir şey daha soracağım.", hedef: "konular", neden: "Konu merkezine dönülür." },
        ],
      },

      // ---------------- SONLAR ----------------
      son_kabul_es: {
        evre: "son",
        baslik: "Kabul · eşin bakar",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşu koşarak iniyor. Az sonra kucağında küçük bir kızla dönüyor." },
          { k: "es", m: "(Akşam.) Ateşi yüksek ama geçer bence. Babası yolda söğüt kabuğu kaynatmış, iyi etmiş." },
        ],
        etki: { karar: "kabul", hatirla: "Elif'i eşin iyileştirdi." },
        sonuc: "Yusuf ve Elif köyde. Eşin iki gün şifacılıkla meşgul. Yusuf'un sadakati yüksek. Tohum için söz verildiyse ilk ekimde tohum ambara girer.",
      },
      son_kabul_sifahane: {
        evre: "son",
        baslik: "Kabul · şifahane",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşu koşarak iniyor. Az sonra kucağında küçük bir kızla dönüyor. Kızı doğruca şifahaneye götürüyorlar." },
          { k: "es", m: "(Akşam.) Şifahanede yatırdılar. Sabaha bir de ben bakarım." },
        ],
        etki: { karar: "kabul", hatirla: "Elif'i köye aldın." },
        sonuc: "Yusuf ve Elif köyde; Elif üç gün şifahanede. Hastalık riski yok. Yusuf'un sadakati yüksek.",
      },
      son_kabul_risk: {
        evre: "son",
        baslik: "Kabul · risk",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşu koşarak iniyor. Az sonra kucağında küçük bir kızla dönüyor." },
          { k: "anlati", kosul: { bayrak_yok: "ates_biliniyor" }, m: "Gece kızın öksürüğü kapının dibine kadar geliyor." },
          {
            k: "es",
            m: "(Akşam.) İyi ettin de… çocuk öksürüyor. Komşular duyarsa laf çok olur.",
            varyant: [{ kosul: { es_meslek: "sifaci" }, m: "(Akşam.) Gittim baktım çocuğa. Ateşi düşer. Ama ayrı yatsınlar biraz." }],
          },
        ],
        etki: { karar: "kabul", bayrak: "hastalik_riski", hatirla: "Elif'i köye aldın." },
        sonuc: "Yusuf ve Elif köyde. İki gün içinde hastalık krizi olasılığı artar; ateş kapıda bilinmiyorsa kriz habersiz başlar. Yusuf'un sadakati yüksek.",
      },
      son_karantina: {
        evre: "son",
        baslik: "Ayrı tutma",
        son: true,
        satirlar: [
          { k: "karakter", m: "Üç gece… Olur. Ben de yanında yatarım." },
          { k: "es", m: "(Akşam.) Bir kap çorba götürdüm onlara. Kız uyuyordu." },
        ],
        etki: { karar: "kabul_bekletme" },
        sonuc: "Üç gece sonra köye girerler. Hastalık riski yok. Yusuf'un güveni orta.",
      },
      son_bol: {
        evre: "son",
        baslik: "Aileyi bölme",
        son: true,
        satirlar: [
          { k: "anlati", m: "Bir süre yüzüne bakıyor." },
          { k: "karakter", m: "Olmaz öyle. Ben de girmem o zaman." },
          { k: "anlati", m: "Çuvalı omzuna alıp yokuşu iniyor." },
          { k: "es", m: "(Akşam.) Babayı kızından mı ayıracaktın? Kimseye söyleme bunu." },
        ],
        etki: {
          karar: "ret",
          hatirla: "Bir babayı kızından ayırmak istedin.",
          dedikodu: "Muhafız bir babayı kızından ayırmak istedi.",
        },
        sonuc: "Ret sayılır. Aileyi bölme girişimi dedikoduya girer (tanık varsa). Muhafız vicdanı düşer.",
      },
      son_rusvet: {
        evre: "son",
        baslik: "Rüşvet: tohum",
        son: true,
        satirlar: [
          { k: "anlati", m: "Keseyi açıyor, avucunu iki kez dolduruyor. Elleri titriyor." },
          { k: "karakter", m: "Al. Geridekiler gelirse ne diyeceğim ben onlara…" },
          { k: "es", m: "(Akşam.) Tohum ambarda. Ama adamın yüzüne bakamadım." },
        ],
        etki: {
          karar: "rusvet",
          bayrak: "rusvet",
          kaynak: { tohum: 1 },
          hatirla: "Tohumun yarısını aldın.",
          dedikodu: "Muhafız kapıyı tohumla açtı.",
        },
        sonuc: "Yusuf ve Elif köyde; rüşvet sayacı +1, terazi yozlaşmaya kayar. Yedi ev sonradan gelirse 'pay sorusu' dönüş olayı açılır.",
      },
      son_ret: {
        evre: "son",
        baslik: "Ret",
        son: true,
        satirlar: [
          { k: "anlati", m: "Bir şey diyecek gibi oluyor, demiyor. Çuvalı omuzluyor." },
          { k: "karakter", m: "Hadi, kal sağlıcakla." },
          { k: "anlati", m: "Yokuşu iniyor. Ardıçların oradan küçük biri kalkıp babasının eteğine yapışıyor." },
          { k: "es", m: "(Akşam.) O çocuk aklımdan çıkmıyor." },
        ],
        etki: { karar: "ret", hatirla: "Ateşli bir çocuğu geri çevirdin." },
        sonuc: "Ret. Köy güvende; vicdan düşer. Yusuf ileride dönerse selamı ret varyantıyla gelir.",
      },
      son_kabul_yalniz: {
        evre: "son",
        baslik: "Kabul · sır kapıda kaldı",
        son: true,
        satirlar: [
          { k: "karakter", m: "Allah razı olsun." },
          { k: "anlati", m: "Gece yarısı nöbetçi, Yusuf'un kapının dibinden yokuşa doğru süzüldüğünü görüyor. Sabaha karşı kucağında bir çocukla dönüyor." },
        ],
        etki: { karar: "kabul", bayrak: ["gizli_cocuk", "hastalik_riski"] },
        sonuc: "Ertesi sabah 'gizli çocuk' olayı açılır: ateşli bir çocuk köye habersiz girdi. Hastalık riski var; muhafızın kapıdaki itibarı sınanır.",
      },
      son_rusvet_yalniz: {
        evre: "son",
        baslik: "Rüşvet · sır kapıda kaldı",
        son: true,
        satirlar: [
          { k: "anlati", m: "Keseyi açıp avucunu iki kez dolduruyor." },
          { k: "karakter", m: "Al bakalım. Yeter mi?" },
          { k: "anlati", m: "Gece yarısı yokuşa süzülüyor. Sabaha karşı kucağında bir çocukla dönüyor." },
        ],
        etki: { karar: "rusvet", bayrak: ["rusvet", "gizli_cocuk", "hastalik_riski"], kaynak: { tohum: 1 }, dedikodu: "Muhafız kapıyı tohumla açtı." },
        sonuc: "Rüşvet sayacı +1. Ertesi sabah 'gizli çocuk' olayı açılır.",
      },
      son_ret_bilmeden: {
        evre: "son",
        baslik: "Ret · bilmeden",
        son: true,
        satirlar: [
          {
            k: "karakter",
            m: "Peki. Kal sağlıcakla.",
            varyant: [{ kosul: { soylenen: "berat" }, m: "Beratlı kapıymış… (Güler, acı acı.) Peki. Kal sağlıcakla." }],
          },
          { k: "anlati", m: "Yokuşu iniyor. Aşağıda, ardıçların orada küçük biri ayağa kalkıyor." },
          { k: "sira", m: "Nöbetçi: \"Muhafız… çocuk varmış yanında.\"" },
        ],
        etki: { karar: "ret", hatirla: "Neyi geri çevirdiğini sonradan gördün." },
        sonuc: "Ret. Muhafız gerçeği kapı kapandıktan sonra görür; vicdan düşer. Berat söylendiyse dedikodu 'sözünü tutmayan kapı' diye yayılır.",
      },
      kacis: {
        evre: "son",
        baslik: "Kaçış (tansiyon > 10)",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf çuvalı bırakıp keseyi kapıyor, yokuşa koşuyor." },
          { k: "anlati", m: "Aşağıdan bir çocuk sesi geliyor. Sonra ikisi birden ağaçların arasında kayboluyor." },
        ],
        etki: { karar: "kacti", kaynak: { gida: 2 }, hatirla: "Yusuf kapından kaçtı." },
        sonuc: "Tansiyon 10'u aştı (ZAR-03). Darı çuvalı kapıda kaldı (+2 gıda). Kaçış kişi hafızasına yazılır.",
      },
    },
  };

  kok.SAHNELER = kok.SAHNELER || {};
  kok.SAHNELER[sahne.id] = sahne;
  if (typeof module !== "undefined") module.exports = sahne;
})(typeof window !== "undefined" ? window : globalThis);
