"""DYL-15: test_soz_duzenleyici.py"""
from pathlib import Path

def test_duzenleyici():
    p = Path("Roadmap-2/soz_agaci/duzenleyici.js")
    assert p.exists(), "duzenleyici.js dosyası mevcut olmalı"
    content = p.read_text(encoding="utf-8")
    assert "SozDuzenleyici" in content, "SozDuzenleyici sınıfı tanımlı olmalı"
    assert "baglantiKur" in content, "baglantiKur metodu bulunmalı"
    print("TEST PASS: test_soz_duzenleyici.py")

if __name__ == "__main__":
    test_duzenleyici()
