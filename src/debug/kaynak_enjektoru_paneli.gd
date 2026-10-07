class_name KaynakEnjektoruPaneli
extends HBoxContainer

signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var secim: OptionButton
var miktar: SpinBox
var uygula: Button
var mevcut: Label
const ALANLAR := ["koy_akce", "muhafiz_akce", "gida", "odun", "tas", "demir", "Refah", "Erzak", "Guvenlik", "Moral", "Saglik"]

func _ready() -> void:
	secim = OptionButton.new()
	for ad in ["Köy Akçesi", "Muhafız Akçesi", "Erzak (stok)", "Odun", "Taş", "Demir", "Refah (ekonomik ortalama)", "Erzak (gıda)", "Güvenlik (0–100)", "Moral (ortalama)", "Sağlık (ortalama)"]:
		secim.add_item(ad)
	secim.tooltip_text = "Refah=köylü ekonomik yaşam standardı (0–100); kamu akçesi ayrı; Erzak=gıda stoku (aynı kaynak). Güvenlik=100−asayiş riski. Moral/Sağlık: her köylüye delta, ekranda ortalama."
	secim.item_selected.connect(func(_i: int) -> void: yenile())
	add_child(secim)
	miktar = SpinBox.new()
	miktar.min_value = -KaynakEnjektoru.SINIR
	miktar.max_value = KaynakEnjektoru.SINIR
	miktar.step = 1
	miktar.value = 10
	miktar.custom_minimum_size.x = 150
	miktar.tooltip_text = "Eklenecek/çıkarılacak miktar. Ambar kapasitesi korunur."
	add_child(miktar)
	uygula = Button.new()
	uygula.text = "Miktarı uygula"
	uygula.pressed.connect(_uygula)
	add_child(uygula)
	mevcut = Label.new()
	mevcut.add_theme_font_size_override("font_size", 20)
	add_child(mevcut)
	yenile()

func yenile() -> void:
	uygula.disabled = not ZamanMakinesi.uygun(baglam)
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	if o == null:
		mevcut.text = "Oturum yok"
		return
	var alan: String = ALANLAR[secim.selected]
	var deger: int
	if alan in StatEnjektoru.ALANLAR:
		deger = StatEnjektoru.oku(o, alan)
	else:
		deger = int(o.get(alan)) if alan in ["koy_akce", "muhafiz_akce"] else o.yonetim.kaynaklar.miktar(alan)
	mevcut.text = "Mevcut: %d" % deger

func _uygula() -> void:
	miktar.apply()
	var sonuc := KaynakEnjektoru.uygula(baglam, ALANLAR[secim.selected], int(miktar.value))
	yenile()
	sonuc_alindi.emit(sonuc)
