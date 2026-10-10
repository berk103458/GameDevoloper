// Söz sistemi taslak sahnesi: Sivaslı reçber Yusuf, ilk karşılaşma.
// Biçim DIY-01a şemasının ilk önerisidir; nihai şema SOZ_SEMASI.md ile kesinleşir.
(function (kok) {
  const sahne = {
    id: "recber_yusuf",
    surum: 1,
    baslik: "Sivaslı reçber — ilk karşılaşma",
    karakter: {
      id: "yusuf",
      ad: "Yusuf",
      yas: 38,
      cinsiyet: "erkek",
      sinif: "ciftci",
      koken: "Sivas yakası, Yıldız suyu kıyısında bir köy",
      zar: "d6",
      sorgu_degeri: 2,
      ses_karti:
        "Kısa konuşur. Yorgun ama kaba değil. Acıyı adlandırmaz, susar. 'Ağam' der. Yemin etmez, 'Hak görür' der. Yalanı beceriksizdir: hızlı söyler, sonra konuyu değiştirir.",
      sir: "Kızı Elif (7) yokuşun dibindeki ardıçlıkta bekliyor; üç gündür ateşli. Hasta dersem kapı kapanır diye saklıyor.",
    },
    baslangic: { dugum: "varis", tansiyon: 4, sabir: 10 },

    ipuclari: {
      arkaya_bakti: "Yokuşa dönüp baktı",
      su_sakladi: "Suyun yarısını içmedi",
      ekmek_sakladi: "Ekmeği koynuna sakladı",
      duman: "Üç gecedir ateş yakmamış",
      carik: "Heybede küçük bir çarık",
      sogut: "Heybede söğüt kabuğu",
      yama: "Çarığın tabanı yeni yamanmış",
    },

    kurallar: {
      tansiyon_kademeleri: [
        { ad: "Sakin", min: 0, max: 3, ek: 0 },
        { ad: "Gergin", min: 4, max: 7, ek: 1 },
        { ad: "Panik", min: 8, max: 10, ek: 2 },
      ],
      tansiyon_ust: 10,
      kacis_dugumu: "kacis",
      varsayilan_basarisiz_etki: { tansiyon: 2 },
      sabir_olayi: {
        satirlar: [
          { k: "sira", m: "Sıradan bir ses: \"Sabahı mı edeceğiz, muhafız?\"" },
          { k: "anlati", m: "Arkadaki bir kadın çocuğunu sırtına alıp yola döner." },
        ],
        etki: { bayrak: "sira_ayrildi", tansiyon: 1 },
      },
    },

    degistiriciler: [
      { ad: "Ekmek verdin", kosul: { bayrak: "ekmek_verildi" }, deger: -1, yaklasim: ["ikna"] },
      { ad: "Ateş başına çağırdın", kosul: { bayrak: "ates" }, deger: -1, yaklasim: ["ikna"] },
      { ad: "Elinde kanıt: yamalı çarık", kosul: { ipucu: "yama" }, deger: -1, yaklasim: ["ikna", "gozdagi"] },
      { ad: "Tohum için söz verdin", kosul: { bayrak: "tohum_soz" }, deger: -1, yaklasim: ["ikna"] },
      { ad: "Tohumu zorla aldın", kosul: { bayrak: "tohum_zorla" }, deger: 2, yaklasim: ["ikna"] },
      { ad: "Acısını zorla söylettin", kosul: { bayrak: "es_oldu" }, deger: 1, yaklasim: ["ikna"] },
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
            m: "Yokuşun başında biri görünür. Sırtında darı çuvalı, göğsüne bastırdığı küçük bir kese. Kapıya on adım kala durur, çuvalı yere bırakır, soluklanır.",
            varyant: [
              {
                kosul: { baglam: { mevsim: "kis" } },
                m: "Yokuşun başında biri görünür. Sakalını kırağı tutmuş; sırtında darı çuvalı, göğsüne bastırdığı küçük bir kese. Kapıya on adım kala durur, çuvalı karın üstüne bırakır, soluklanır.",
              },
            ],
          },
          { k: "karakter", m: "Selamün aleyküm, ağam." },
        ],
        secenekler: [
          {
            metin: "Aleyküm selam. Gel, soluklan.",
            hedef: "selam_su",
            etki: { tansiyon: -1 },
            neden: "Selamı almak usuldür. Tansiyon düşer; karakter isteğini söyler.",
          },
          {
            metin: "Dur orada. Kimsin, nesin?",
            hedef: "selam_sert",
            etki: { tansiyon: 1 },
            neden: "Selamı almamak ayıptır. Karakter savunmaya geçer, adını hemen söyler, isteğini yutar.",
          },
          {
            metin: "(Sus. Bekle.)",
            hedef: "selam_sessiz",
            neden: "Susmak da cevaptır. Boşluğu karakter doldurur; muhafız onu izleme fırsatı bulur (sezgi satırı açılabilir).",
          },
        ],
      },

      selam_su: {
        evre: "selam",
        baslik: "Su isteği",
        satirlar: [
          {
            k: "karakter",
            m: "Bir tas su verir misin? Sonra ne sorarsan sor.",
            varyant: [
              { kosul: { baglam: { mevsim: "kis" } }, m: "Bir tas su… ya da ateşin başında bir soluk. Sonra ne sorarsan sor." },
            ],
          },
        ],
        secenekler: [
          {
            metin: "(Testiyi uzat.)",
            hedef: "ikram_su",
            etki: { tansiyon: -1, bayrak: "ikram" },
            neden: "En küçük ikram. Tansiyon düşer; sezgisi olan muhafız suyun yarıda bırakıldığını fark eder.",
          },
          {
            metin: "(Su ile bir dilim ekmek ver.)",
            hedef: "ikram_ekmek",
            etki: { tansiyon: -2, bayrak: ["ikram", "ekmek_verildi"], kaynak: { gida: -1 }, hatirla: "Kapıda ekmek verdin." },
            neden: "Ekmek bedeli olan ikramdır (1 gıda). Daha çok yumuşatır, ikna zarını kolaylaştırır ve hatırlanır.",
          },
          {
            metin: "(Ateş başına çağır.)",
            kosul: { baglam: { mevsim: "kis" } },
            hedef: "ikram_ates",
            etki: { tansiyon: -2, sabir: -1, bayrak: ["ikram", "ates"] },
            neden: "Yalnız kışın açılır. Ateş başı zaman alır (sabır −1) ama karakter üşümüşken konuşturan en güçlü ikramdır.",
          },
          {
            metin: "Su kapının içinde. Önce sorularım.",
            hedef: "ikram_ret",
            etki: { tansiyon: 1 },
            neden: "İkramı şarta bağlamak. Tansiyon artar; karakter yine konuşur ama ikram ipuçları hiç açılmaz.",
          },
        ],
      },

      selam_sert: {
        evre: "selam",
        baslik: "Sert karşılama",
        satirlar: [
          { k: "karakter", m: "(Elini göğsündeki keseye götürür.) Yusuf derler. Toprak adamıyım, ağam. Silahım yok, bak." },
          { k: "anlati", m: "Kollarını açar. Kesenin olduğu eli ise göğsünden ayırmaz." },
        ],
        etki: { beyan: { id: "ad", metin: "Adı Yusuf; toprak adamı olduğunu söyledi." } },
        secenekler: [
          {
            metin: "Peki. Su iç, sonra konuşuruz.",
            hedef: "ikram_su",
            etki: { tansiyon: -1, bayrak: "ikram" },
            neden: "Sert başlayıp ikrama dönmek tansiyonu geri alır.",
          },
          {
            metin: "Sorularıma geç.",
            hedef: "konular",
            neden: "İkramsız doğrudan sorguya geçilir. İkramla açılan ipuçları kaçar.",
          },
        ],
      },

      selam_sessiz: {
        evre: "selam",
        baslik: "Sessiz karşılama",
        satirlar: [
          { k: "anlati", m: "Bir süre bakışırsınız. Adam gözünü kaçırmaz; yalnız bir kez dönüp yokuşun dibine bakar." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Arkasına baktı. Kovalanan mı, bekleyen mi?",
            etki: { ipucu: "arkaya_bakti" },
          },
          { k: "karakter", m: "Selam almayan kapıya su sormak ayıp. Ben yine de sorayım: bir tas su?" },
        ],
        secenekler: [
          {
            metin: "(Testiyi uzat.)",
            hedef: "ikram_su",
            etki: { tansiyon: -1, bayrak: "ikram" },
            neden: "Susup sonra su vermek: hem izledin hem yumuşattın.",
          },
          {
            metin: "Önce kim olduğunu söyle.",
            hedef: "selam_sert",
            etki: { tansiyon: 1 },
            neden: "Sessizliğin ardından sertlik tansiyonu artırır.",
          },
        ],
      },

      // ---------------- İKRAM ----------------
      ikram_su: {
        evre: "ikram",
        baslik: "Su",
        satirlar: [
          { k: "anlati", m: "Testiyi iki eliyle alır. Birkaç yudum içer, sonra durur; kalanını içmeden geri verir." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 2 },
            m: "Susuz bir adam testiyi yarıda bırakmaz. Birine saklıyor.",
            etki: { ipucu: "su_sakladi" },
          },
          { k: "karakter", m: "Hak razı olsun. Ocağın tütsün. Sor, ağam." },
        ],
        sonraki: "konular",
      },

      ikram_ekmek: {
        evre: "ikram",
        baslik: "Ekmek",
        satirlar: [
          { k: "anlati", m: "Ekmeği öper, alnına koyar. Bir lokma ısırır; kalanını koynuna saklar." },
          { k: "karakter", m: "Bunu unutmam, ağam. Sor ne sorarsan." },
        ],
        etki: { ipucu: "ekmek_sakladi" },
        sonraki: "konular",
      },

      ikram_ates: {
        evre: "ikram",
        baslik: "Ateş başı",
        satirlar: [
          { k: "anlati", m: "Ateşe yaklaşınca elleri titremeye başlar. Uzun süre bir şey demez; avuçlarını alevin üstünde tutar." },
          { k: "karakter", m: "Üç gecedir ateş yakmadım. Duman görünür diye." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Duman kimden saklanır? Kovalayandan… ya da yerini belli etmek istemediği birinden.",
          },
        ],
        etki: { ipucu: "duman" },
        sonraki: "konular",
      },

      ikram_ret: {
        evre: "ikram",
        baslik: "İkram yok",
        satirlar: [
          { k: "karakter", m: "Peki. Kuru boğazla da konuşulur." },
          { k: "anlati", m: "Dudaklarını yalar, çuvalın üstüne çöker." },
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
              { kosul: { sabir_max: 3 }, m: "Yusuf çuvalın yanında bekliyor. Sıradakiler homurdanmaya başladı." },
              { kosul: { bayrak: "sir_acik" }, m: "Yusuf yokuşun dibine bakıp duruyor." },
            ],
          },
        ],
        secenekler: [
          { metin: "Nereden geldin?", hedef: "k_nereden", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. İlk katman kısa; üstelenirse derinleşir." },
          { metin: "Neden yola düştün?", hedef: "k_neden", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Cevap mevsime göre değişir." },
          { metin: "Kiminle geldin?", hedef: "k_kiminle", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Cevap 'Yalnızım' beyanını deftere yazar; yüzleşmelerin anahtarı budur." },
          { metin: "Ne iş bilirsin?", hedef: "k_is", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Meslek beyanı ve dolaylı ipucu (söğüt kabuğu)." },
          { metin: "Yükün ne?", hedef: "k_yuk", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Tohum burada ancak kese sorulursa açılır." },
          { metin: "Yolda ne gördün?", hedef: "k_yol", tukenir: true, etki: { sabir: -1 }, neden: "Ortak konu. Dünya bilgisi verir." },
          {
            metin: "Sivas'tan haber var mı?",
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
            etki: { tansiyon: 1, sabir: -1 },
            neden: "Aranmak tansiyonu artırır. Heybedeki eşya, beyanla çelişebilir.",
          },
          {
            metin: "Yalnızım dedin. Bu çarık kimin?",
            kosul: { ipucu: "carik", beyan: "yalniz" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_carik" },
            neden: "Yüzleşme: 'Yalnızım' beyanı ile heybedeki çarık çelişiyor.",
          },
          {
            metin: "Suyu kime saklıyorsun?",
            kosul: { ipucu: "su_sakladi", beyan: "yalniz" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_su" },
            neden: "Yüzleşme: sezgiyle görülen davranış ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Ekmeği kime saklıyorsun?",
            kosul: { ipucu: "ekmek_sakladi", beyan: "yalniz" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_ekmek" },
            neden: "Yüzleşme: ikram sırasında görülen davranış ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Dumanını kimden saklıyorsun?",
            kosul: { ipucu: "duman", beyan: "yalniz" },
            hedef: "yuzles",
            tukenir: true,
            etki: { bayrak: "yuz_duman" },
            neden: "Yüzleşme: ateş başında söylenen ile 'Yalnızım' beyanı çelişiyor.",
          },
          {
            metin: "Kızın için kararımı vereceğim.",
            kosul: { bayrak: "sir_acik" },
            hedef: "ikilem",
            neden: "Sır açıldıysa karar ikilem düğümünde verilir.",
          },
          {
            metin: "Yeter. Kararımı vereceğim.",
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
          { k: "karakter", m: "Sivas yakasından. Yıldız suyunun kıyısında bir köy." },
          { k: "anlati", m: "Susar." },
          { k: "karakter", m: "Köy yandı." },
        ],
        etki: { beyan: { id: "koken", metin: "Sivas yakasından, Yıldız suyu kıyısındaki köyü yanmış." } },
        secenekler: [
          {
            metin: "Kim yaktı?",
            hedef: "k_nereden_2",
            etki: { tansiyon: 1, sabir: -1 },
            neden: "Üstelemek ikinci katmanı açar; bedeli tansiyon ve sabır.",
          },
          { metin: "Başın sağ olsun.", hedef: "konular", etki: { tansiyon: -1 }, neden: "Acıya saygı tansiyonu düşürür." },
          { metin: "Başka bir şey soracağım.", hedef: "konular", neden: "Konudan çıkılır." },
        ],
      },
      k_nereden_2: {
        evre: "konu",
        baslik: "Nereden · 2",
        satirlar: [
          { k: "karakter", m: "Moğol. Kösedağ'dan sonra beyler dağıldı. Bizim köye üç gün sonra geldiler." },
          { k: "karakter", m: "Gerisini sorma, ağam." },
        ],
        etki: { beyan: { id: "mogol", metin: "Köyü Kösedağ'dan üç gün sonra Moğol yakmış." } },
        secenekler: [
          { metin: "Sormam.", hedef: "konular", etki: { tansiyon: -1 }, neden: "Susuşa saygı. Karakter 'gerisini sorma' dediyse bu bir bilgidir." },
          {
            metin: "Gerisini anlat.",
            hedef: "k_nereden_3",
            etki: { tansiyon: 2, sabir: -1 },
            neden: "Üçüncü katman: zorla açılır, acı bir bilgi verir ve hatırlanır. İkna zarını zorlaştırır.",
          },
        ],
      },
      k_nereden_3: {
        evre: "konu",
        baslik: "Nereden · 3",
        satirlar: [
          { k: "anlati", m: "Uzun susar. Gözünü kesenin üstünden ayırmaz." },
          { k: "karakter", m: "Avradımı ahırın önünde buldum. Yeter mi, ağam?" },
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
          {
            k: "karakter",
            m: "Durmak ölmek demekti. Bir de güz gelmeden toprak bulmazsam bu tohum boşa gider.",
            varyant: [
              { kosul: { baglam: { mevsim: "kis" } }, m: "Kış bastırdı. Bir çatı bulamazsam bahara ne ben çıkarım ne bu tohum." },
            ],
          },
        ],
        secenekler: [
          {
            metin: "Hangi tohum?",
            kosul: { bayrak_yok: "tohum_biliniyor" },
            hedef: "k_yuk_tohum",
            etki: { sabir: -1 },
            neden: "Ağzından kaçan söz başka bir konuya kapı açar.",
          },
          { metin: "Anladım.", hedef: "konular", neden: "Konudan çıkılır." },
        ],
      },

      k_kiminle: {
        evre: "konu",
        baslik: "Kiminle",
        satirlar: [
          { k: "karakter", m: "Yalnızım." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 2 },
            m: "Çabuk söyledi. Bu soruyu bekliyormuş.",
            varyant: [{ kosul: { tecrube_min: 2, ipucu: "arkaya_bakti" }, m: "Çabuk söyledi. Az önce de yokuşa bakmıştı." }],
          },
        ],
        etki: { beyan: { id: "yalniz", metin: "Yalnız geldiğini söyledi." } },
        secenekler: [
          {
            metin: "Yolda da mı yalnızdın?",
            hedef: "k_kiminle_2",
            etki: { tansiyon: 1, sabir: -1 },
            neden: "Üstelemek: yalanın etrafına bir doğru eklenir.",
          },
          { metin: "Peki.", hedef: "konular", neden: "Beyan defterde kalır." },
        ],
      },
      k_kiminle_2: {
        evre: "konu",
        baslik: "Kiminle · 2",
        satirlar: [
          { k: "karakter", m: "Yedi hane çıktık yola. Tokat yolunda ayrıldık; onlar kuzeye, ben batıya." },
          { k: "karakter", m: "Şimdi yalnızım, dedim ya." },
        ],
        etki: { beyan: { id: "yedi_hane", metin: "Yedi haneyle yola çıkmış, Tokat yolunda ayrılmışlar." } },
        sonraki: "konular",
      },

      k_is: {
        evre: "konu",
        baslik: "İş",
        satirlar: [
          { k: "karakter", m: "Toprak işlerim. Darı, arpa, mercimek. Saban tutarım, harman savururum." },
          { k: "sezgi", kosul: { tecrube_min: 1 }, m: "Avuçları yarık yarık. Çiftçi eli; burada yalan yok." },
        ],
        etki: { beyan: { id: "ciftci", metin: "Çiftçi: darı, arpa, mercimek." } },
        secenekler: [
          { metin: "Başka ne bilirsin?", hedef: "k_is_2", etki: { sabir: -1 }, neden: "İkinci katman, dolaylı bir ipucu verir." },
          { metin: "İyi. Tarlaya el lazım.", hedef: "konular", etki: { tansiyon: -1 }, neden: "Değer görmek yumuşatır." },
        ],
      },
      k_is_2: {
        evre: "konu",
        baslik: "İş · 2",
        satirlar: [
          { k: "karakter", m: "Başka bir şey bilmem. Anam söğüt kabuğundan ateş suyu kaynatmayı öğretmişti, o kadar." },
          { k: "sezgi", kosul: { ipucu: "sogut" }, m: "Heybedeki söğüt kabuğu. Ateş düşürmek için. Kimin ateşi var?" },
        ],
        etki: { beyan: { id: "sogut_bilgi", metin: "Söğüt kabuğundan ateş suyu kaynatmayı biliyor." } },
        sonraki: "konular",
      },

      k_yuk: {
        evre: "konu",
        baslik: "Yük",
        satirlar: [
          { k: "karakter", m: "Darı. Yolda yenecek kadar kaldı." },
          { k: "anlati", m: "Göğsündeki keseyi daha sıkı tutar." },
        ],
        etki: { beyan: { id: "dari", metin: "Yükü darı; yolda yenecek kadar." } },
        secenekler: [
          {
            metin: "Ya o kese?",
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
          { k: "karakter", m: "Tohum. Köyün tohumu, ağam; benim değil." },
          { k: "karakter", m: "Her ocak bir avuç koydu. Söz verdim: nerede yer bulursam ekeceğim, kalanlar gelince harmanı paylaşacağız." },
        ],
        etki: { bayrak: "tohum_biliniyor", beyan: { id: "tohum", metin: "Kesede köyün ortak tohumu var; ekip harmanı paylaşma sözü vermiş." } },
        secenekler: [
          {
            metin: "Köye girersen o tohum ambara girer.",
            hedef: "tohum_ambar",
            neden: "Pazarlık: karakter şart koşar, muhafızdan söz ister.",
          },
          {
            metin: "Güzel söz. Tut onu.",
            hedef: "konular",
            etki: { tansiyon: -1, hatirla: "Tohumuna dokunmadın." },
            neden: "Sözüne saygı. Hatırlanır; ileride dönüş olayında karşılığı olur.",
          },
          {
            metin: "O keseyi kapıda bırakırsın ya da girmezsin.",
            zar: { yaklasim: "gozdagi", tur: "tek_sans", basari: "tohum_alindi", basarisiz: "tohum_direnc" },
            neden: "Gözdağı, tek şans. Başarırsa tohum alınır ama dedikodu ve ikna cezası doğar.",
          },
        ],
      },
      tohum_ambar: {
        evre: "konu",
        baslik: "Tohum pazarlığı",
        satirlar: [
          { k: "anlati", m: "Uzun düşünür." },
          { k: "karakter", m: "Ambarına koyarım. Ama ilk ekimi ben ederim; kalanlar gelince payları verilir. Söz ver bana." },
        ],
        secenekler: [
          {
            metin: "Söz.",
            hedef: "konular",
            etki: { bayrak: "tohum_soz", hatirla: "Yusuf'a tohum için söz verdin." },
            neden: "Söz kişi hafızasına yazılır; tutulmazsa dönüşte hesabı sorulur. İkna zarını kolaylaştırır.",
          },
          {
            metin: "Söz vermem. Ambar köyündür.",
            hedef: "konular",
            etki: { tansiyon: 2 },
            neden: "Köyün çıkarı önde; karakterin güveni düşer.",
          },
        ],
      },
      tohum_alindi: {
        evre: "konu",
        baslik: "Tohum zorla",
        satirlar: [
          { k: "anlati", m: "Keseyi yere koyar. Elleri titriyor." },
          { k: "karakter", m: "Al. Ama Hak görür." },
        ],
        etki: {
          bayrak: "tohum_zorla",
          kaynak: { tohum: 1 },
          hatirla: "Tohumu zorla aldın.",
          dedikodu: "Muhafız bir garibin tohumunu kapıda aldı.",
        },
        sonraki: "konular",
      },
      tohum_direnc: {
        evre: "konu",
        baslik: "Tohum direnci",
        satirlar: [{ k: "karakter", m: "Bu keseyi canımla veririm, ağam. Başka türlü vermem." }],
        sonraki: "konular",
      },

      k_yol: {
        evre: "konu",
        baslik: "Yol",
        satirlar: [
          { k: "karakter", m: "Yanık köyler. Bir de yol ağızlarında asılı adamlar." },
          { k: "karakter", m: "Moğol asmamış onları. Kendi beylerimiz, kaçanı asıyordu." },
        ],
        etki: { beyan: { id: "yol", metin: "Yolda kaçakları asan beyler görmüş." } },
        sonraki: "konular",
      },
      k_haber: {
        evre: "konu",
        baslik: "Haber",
        satirlar: [
          { k: "karakter", m: "Sivas kapısını açtı, duydun mu? Kan akmadı, akçe aktı; şehir fidyesini verdi." },
          { k: "karakter", m: "Köyler veremedi." },
        ],
        etki: { beyan: { id: "haber", metin: "Sivas fidyeyle teslim olmuş; köyler yağmalanmış." } },
        sonraki: "konular",
      },

      // ---------------- HEYBE ----------------
      heybe: {
        evre: "heybe",
        baslik: "Heybe",
        satirlar: [
          { k: "anlati", m: "Heybede kuru ekmek kırıntısı, bir çakmak taşı, bir avuç söğüt kabuğu…" },
          { k: "anlati", m: "…ve küçük bir çarık. Bir çocuk ayağı kadar." },
          { k: "karakter", m: "(Çarığı görünce yüzü değişir.) Yoldan buldum onu. Yanık bir evin önünde." },
          {
            k: "sezgi",
            kosul: { tecrube_min: 1 },
            m: "Çarığın tabanı yeni yamanmış. Yoldan bulunan çarığa kimse yama vurmaz.",
            etki: { ipucu: "yama" },
          },
        ],
        etki: { ipucu: ["carik", "sogut"], beyan: { id: "carik_yol", metin: "Çarığı yoldan bulduğunu söyledi." } },
        sonraki: "konular",
      },

      // ---------------- YÜZLEŞME ----------------
      yuzles: {
        evre: "yuzlesme",
        baslik: "Yüzleşme",
        satirlar: [
          {
            k: "anlati",
            m: "Yusuf bir şey demez. Yokuşun dibine bakar.",
            varyant: [{ kosul: { ipucu: "yama", bayrak: "yuz_carik" }, m: "Yusuf bir şey demez. Gözü elindeki yamalı çarıkta." }],
          },
          { k: "karakter", kosul: { tansiyon_min: 8 }, m: "(Geri geri çekilir.) Bırak beni, ağam. Giderim." },
        ],
        secenekler: [
          {
            metin: "Doğruyu söylersen kapı kapanmaz. Söz.",
            zar: { yaklasim: "ikna", tur: "tekrar", basari: "sir_acildi", basarisiz: "yuzles_inkar" },
            neden: "İkna, tekrar denenebilir. Her başarısızlık tansiyonu artırır; 10'u aşarsa karakter kaçar.",
          },
          {
            metin: "Söylemezsen ikimiz de biliriz ne olacağını.",
            zar: {
              yaklasim: "gozdagi",
              tur: "tek_sans",
              basari: "sir_acildi_korku",
              basarisiz: "yuzles_inkar",
              basarisiz_etki: { tansiyon: 3 },
            },
            neden: "Gözdağı, tek şans. Sır açılır ama korkuyla açılır: dedikodu ve hatırlanma.",
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
            neden: "Aynı sessizlik, gergin karaktere tehdit gibi gelir: kapanır.",
          },
          {
            metin: "Söylemek istemiyorsan söyleme.",
            hedef: "konular",
            etki: { tansiyon: -1 },
            neden: "Geri çekilmek. Başka bir ipucuyla yeniden yüzleşilebilir.",
          },
        ],
      },
      yuzles_sessiz: {
        evre: "yuzlesme",
        baslik: "Kapanma",
        satirlar: [{ k: "karakter", m: "Ne bakarsın öyle? Yalnızım, dedim ya." }],
        sonraki: "yuzles",
      },
      yuzles_inkar: {
        evre: "yuzlesme",
        baslik: "İnkâr",
        satirlar: [{ k: "karakter", m: "Yalnızım, dedim. Daha ne söyleyeyim?" }],
        sonraki: "yuzles",
      },

      // ---------------- SIR ----------------
      sir_acildi: {
        evre: "sir",
        baslik: "Sır: Elif",
        satirlar: [
          { k: "anlati", m: "Omuzları düşer." },
          { k: "karakter", m: "Kızım. Elif. Yedi yaşında." },
          { k: "karakter", m: "Yokuşun dibindeki ardıçlığın altında bekliyor. Üç gündür ateşi var." },
          {
            k: "karakter",
            m: "Hasta dersem kapı kapanır diye… Onu yolda bırakamam, ağam.",
            varyant: [{ kosul: { bayrak: "es_oldu" }, m: "Hasta dersem kapı kapanır diye… Anasını ahırın önünde bıraktım. Kızını bırakamam." }],
          },
        ],
        etki: {
          bayrak: "sir_acik",
          tansiyon: -2,
          beyan: { id: "kizi_var", metin: "Kızı Elif (7) ardıçlıkta bekliyor; üç gündür ateşli." },
        },
        sonraki: "ikilem",
      },
      sir_acildi_korku: {
        evre: "sir",
        baslik: "Sır: korkuyla",
        satirlar: [
          { k: "anlati", m: "Dizlerinin üstüne çöker." },
          { k: "karakter", m: "Kızım… Ardıçlığın altında. Ateşi var. Vurma, ağam. Ona dokunma." },
        ],
        etki: {
          bayrak: ["sir_acik", "korkuyla"],
          tansiyon: 1,
          beyan: { id: "kizi_var", metin: "Kızı Elif (7) ardıçlıkta bekliyor; üç gündür ateşli." },
          hatirla: "Sırrını korkutarak aldın.",
          dedikodu: "Muhafız bir babayı kapıda dize getirdi.",
        },
        sonraki: "ikilem",
      },

      // ---------------- İKİLEM VE KARAR ----------------
      ikilem: {
        evre: "ikilem",
        baslik: "İkilem: ateşli çocuk",
        satirlar: [
          { k: "anlati", m: "Ateşli bir çocuk. Köyde öksürük yayılırsa kış uzun olur. Ama ardıçlığın altında bir gece daha…" },
          { k: "es", kosul: { es_meslek: "sifaci" }, m: "(Yanına gelmiş.) Ateşi görmeden bir şey diyemem. Getirsinler, bakarım." },
          { k: "es", kosul: { es_meslek: ["dokumaci", "firinci", "bostanci", "sutcu", "yun_egirici"] }, m: "(Yanına gelmiş.) Çocuğu dışarıda bırakma. Ama köyde de şifa bilen yok, bunu da düşün." },
        ],
        secenekler: [
          {
            metin: "İkinizi de alırım. Kızı doğru eşime götürün.",
            kosul: { es_meslek: "sifaci" },
            hedef: "son_kabul_es",
            neden: "Eşin şifacıysa açılır: risk en az, bedel eşin iki günü.",
          },
          {
            metin: "İkinizi de alırım. Kız şifahanede yatsın.",
            kosul: { baglam: { sifahane: true } },
            hedef: "son_kabul_sifahane",
            neden: "Köyde şifahane varsa açılır (bağlam sorgusu).",
          },
          { metin: "İkinizi de alırım.", hedef: "son_kabul_risk", neden: "Merhamet; köye hastalık riski girer." },
          {
            metin: "Kız üç gece ahırın yanında ayrı yatsın, sonra köye girer.",
            hedef: "son_karantina",
            neden: "Orta yol: risk yok, güven orta.",
          },
          { metin: "Seni alırım. Kızı alamam.", hedef: "son_bol", neden: "Aileyi bölmek. Karakter kabul etmez; dedikodu doğar." },
          {
            metin: "Tohumun yarısını ver, kızı da alırım.",
            kosul: { bayrak: "tohum_biliniyor", bayrak_yok: "tohum_zorla" },
            hedef: "son_rusvet",
            neden: "Rüşvet: köy tohum kazanır, muhafız terazisi yozlaşmaya kayar.",
          },
          { metin: "İkinizi de alamam. Yolunuz açık olsun.", hedef: "son_ret", neden: "Köyün güvenliği önde." },
        ],
      },

      karar: {
        evre: "karar",
        baslik: "Karar (sır açılmadan)",
        satirlar: [{ k: "anlati", m: "Yusuf çuvalı omzuna almaya hazır, bekliyor." }],
        secenekler: [
          { metin: "Gir. Köyde sana yer var.", hedef: "son_kabul_yalniz", neden: "Kabul; ama kapıda görülmeyen kız gece gelir." },
          {
            metin: "Tohumun yarısını ver, kapı açılır.",
            kosul: { bayrak: "tohum_biliniyor", bayrak_yok: "tohum_zorla" },
            hedef: "son_rusvet_yalniz",
            neden: "Rüşvet, sır bilinmeden.",
          },
          { metin: "Bu kapı sana kapalı.", hedef: "son_ret_bilmeden", neden: "Ret; neyin geri çevrildiği sonradan görülür." },
          { metin: "Bekle. Bir şey daha soracağım.", hedef: "konular", neden: "Konu merkezine dönülür." },
        ],
      },

      // ---------------- SONLAR ----------------
      son_kabul_es: {
        evre: "son",
        baslik: "Kabul · eşin bakar",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşa koşar. Az sonra kucağında küçük bir kızla döner." },
          { k: "es", m: "(Akşam.) Ateşi yüksek ama geçer. Söğüt kabuğunu babası iyi düşünmüş." },
        ],
        etki: { karar: "kabul", hatirla: "Elif'i eşin iyileştirdi." },
        sonuc: "Yusuf ve Elif köyde. Eşin iki gün şifacılıkla meşgul. Yusuf'un sadakati yüksek. Tohum için söz verildiyse ilk ekimde tohum ambara girer.",
      },
      son_kabul_sifahane: {
        evre: "son",
        baslik: "Kabul · şifahane",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşa koşar. Az sonra kucağında küçük bir kızla döner; kızı doğruca şifahaneye götürürler." },
          { k: "es", m: "(Akşam.) Şifahane olmasa ne yapardık, bilmem." },
        ],
        etki: { karar: "kabul", hatirla: "Elif'i köye aldın." },
        sonuc: "Yusuf ve Elif köyde; Elif üç gün şifahanede. Hastalık riski yok. Yusuf'un sadakati yüksek.",
      },
      son_kabul_risk: {
        evre: "son",
        baslik: "Kabul · risk",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf yokuşa koşar. Az sonra kucağında küçük bir kızla döner." },
          {
            k: "es",
            m: "(Akşam.) İyi ettin. Ama çocuk öksürüyor; komşular duyarsa çok konuşulur.",
            varyant: [{ kosul: { es_meslek: "sifaci" }, m: "(Akşam.) Bana getirmedin ama gidip baktım. Ateşi düşer. Yine de söyle, ayrı yatsınlar." }],
          },
        ],
        etki: { karar: "kabul", bayrak: "hastalik_riski", hatirla: "Elif'i köye aldın." },
        sonuc: "Yusuf ve Elif köyde. İki gün içinde hastalık krizi olasılığı artar. Yusuf'un sadakati yüksek.",
      },
      son_karantina: {
        evre: "son",
        baslik: "Ayrı tutma",
        son: true,
        satirlar: [
          { k: "karakter", m: "Üç gece… Ahırın yanında ben de yatarım. Sen bilirsin, ağam." },
          { k: "es", m: "(Akşam.) Akıllıca. Ben bir kap çorba götürdüm onlara." },
        ],
        etki: { karar: "kabul_bekletme" },
        sonuc: "Üç gece sonra köye girerler. Hastalık riski yok. Yusuf'un güveni orta.",
      },
      son_bol: {
        evre: "son",
        baslik: "Aileyi bölme",
        son: true,
        satirlar: [
          { k: "anlati", m: "Uzun bakar." },
          { k: "karakter", m: "O zaman ben de yokum, ağam." },
          { k: "anlati", m: "Çuvalı omuzlar, yokuşu iner." },
          { k: "es", m: "(Akşam.) Babayı kızından ayırmak mı? Bunu köyde kimseye anlatma." },
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
          { k: "anlati", m: "Keseyi açar, avucunu iki kez doldurur. Elleri titriyor." },
          { k: "karakter", m: "Al. Geride kalanlar bunu sorarsa ne diyeyim?" },
          { k: "es", m: "(Akşam.) Tohum ambarda. Ama o adamın yüzüne bakamadım." },
        ],
        etki: {
          karar: "rusvet",
          bayrak: "rusvet",
          kaynak: { tohum: 1 },
          hatirla: "Tohumun yarısını aldın.",
          dedikodu: "Muhafız kapıyı tohumla açtı.",
        },
        sonuc: "Yusuf ve Elif köyde; rüşvet sayacı +1, terazi yozlaşmaya kayar. Yedi hane sonradan gelirse 'pay sorusu' dönüş olayı açılır.",
      },
      son_ret: {
        evre: "son",
        baslik: "Ret",
        son: true,
        satirlar: [
          { k: "karakter", m: "Hak sana da evladına bakan bir göz versin, ağam." },
          { k: "anlati", m: "Yokuşu iner. Ardıçlığın oradan küçük bir gölge kalkar, babasının eteğine yapışır." },
          { k: "es", m: "(Akşam.) Bütün gece o çocuğu düşündüm." },
        ],
        etki: { karar: "ret", hatirla: "Ateşli bir çocuğu geri çevirdin." },
        sonuc: "Ret. Köy güvende; vicdan düşer. Yusuf ileride dönerse selamı ret varyantıyla gelir.",
      },
      son_kabul_yalniz: {
        evre: "son",
        baslik: "Kabul · sır kapıda kaldı",
        son: true,
        satirlar: [
          { k: "karakter", m: "Hak razı olsun." },
          { k: "anlati", m: "Gece yarısı nöbetçi, Yusuf'un kapı dibinden yokuşa süzüldüğünü görür. Sabaha karşı kucağında bir çocukla döner." },
        ],
        etki: { karar: "kabul", bayrak: ["gizli_cocuk", "hastalik_riski"] },
        sonuc: "Ertesi sabah 'gizli çocuk' olayı açılır: ateşli bir çocuk köye habersiz girdi. Hastalık riski var; muhafızın kapıdaki itibarı sınanır.",
      },
      son_rusvet_yalniz: {
        evre: "son",
        baslik: "Rüşvet · sır kapıda kaldı",
        son: true,
        satirlar: [
          { k: "anlati", m: "Keseyi açar, avucunu iki kez doldurur." },
          { k: "karakter", m: "Al. Sana bu kapının hakkı." },
          { k: "anlati", m: "Gece yarısı yokuşa süzülür; sabaha karşı kucağında bir çocukla döner." },
        ],
        etki: { karar: "rusvet", bayrak: ["rusvet", "gizli_cocuk", "hastalik_riski"], kaynak: { tohum: 1 }, dedikodu: "Muhafız kapıyı tohumla açtı." },
        sonuc: "Rüşvet sayacı +1. Ertesi sabah 'gizli çocuk' olayı açılır.",
      },
      son_ret_bilmeden: {
        evre: "son",
        baslik: "Ret · bilmeden",
        son: true,
        satirlar: [
          { k: "karakter", m: "(Çuvalı omuzlar.) Ocağın yine de tütsün." },
          { k: "anlati", m: "Yokuşun dibinde ardıçlığa doğru yürür. Orada küçük bir gölge kalkar." },
          { k: "sira", m: "Nöbetçi: \"Çocuk varmış, muhafız…\"" },
        ],
        etki: { karar: "ret", hatirla: "Neyi geri çevirdiğini sonradan gördün." },
        sonuc: "Ret. Muhafız gerçeği kapı kapandıktan sonra görür; vicdan düşer.",
      },
      kacis: {
        evre: "son",
        baslik: "Kaçış (tansiyon > 10)",
        son: true,
        satirlar: [
          { k: "anlati", m: "Yusuf çuvalı bırakır, keseyi kapar, yokuşa koşar." },
          { k: "anlati", m: "Ardıçlığın oradan bir çocuk sesi duyulur; sonra ikisi birden ormana dalar." },
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
