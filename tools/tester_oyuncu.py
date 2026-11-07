"""ADM-16: durum oku -> politika seçimi -> gerçek oyuncu eylemi. Hile komutu yok."""
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import random
import socket
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "bridge/python"))
from bridge_client import Bridge, BridgeError, wait_ready  # noqa: E402


class Politika:
    def __init__(self, ad, tohum):
        self.ad = ad
        self.rng = random.Random(tohum)
        self.sohbet_sayisi = {}
        self.koy_adimi = {}

    def sec(self, s):
        """Yalnız get_state içindeki oyuncunun gördüğü veriyi kullanır."""
        if not s.get("hazir") or s.get("mesgul"):
            return None
        ekran = s["ekran"]
        if ekran == "son":
            return None
        if ekran == "rapor":
            secenekler = s.get("secenekler", [])
            i = self.rng.choice(secenekler)["indeks"] if self.ad == "rastgele" and secenekler else 0
            return "devam", {"indeks": i}
        if ekran == "kapi":
            kisi = s.get("kisi", {})
            if s.get("evre") == "karar":
                kararlar = kisi.get("kararlar", [])
                if not kararlar:
                    return None
                if self.ad == "rusvetci" and "rusvet" in kararlar:
                    karar = "rusvet"
                elif self.ad == "rastgele":
                    karar = self.rng.choice(kararlar)
                else:
                    # Anlatılan görünür hastalık/tehdit ve erzak darlığına göre ihtiyat.
                    metin = (kisi.get("konusma", "") + " ".join(kisi.get("gorunen_ipuclari", []))).lower()
                    risk = any(k in metin for k in ("salgın", "zehir", "silah çek", "öksür"))
                    karar = "ret" if risk or s.get("erzak", 0) < 10 else "kabul"
                    if karar not in kararlar:
                        karar = kararlar[0]
                return "kapi_karar", {"karar": karar}
            if s.get("evre") == "sohbet":
                imza = (s.get("gun"), kisi.get("ad"), kisi.get("sirada"))
                sayi = self.sohbet_sayisi.get(imza, 0)
                secenekler = s.get("secenekler", [])
                eylemler = s.get("eylemler", [])
                # CHR yönlendirme/karar düğmeleri de gerçek sohbet panelindedir.
                for alan, liste in (("secenek", secenekler), ("eylem", eylemler)):
                    for b in liste:
                        if "karar" in b["metin"].lower() and (sayi >= 2 or len(secenekler) <= 1):
                            return "devam", {"alan": alan, "indeks": b["indeks"]}
                if secenekler:
                    self.sohbet_sayisi[imza] = sayi + 1
                    b = self.rng.choice(secenekler) if self.ad == "rastgele" else secenekler[sayi % len(secenekler)]
                    return "soru_sor", {"indeks": b["indeks"]}
                return None
            if s.get("evre") in ("sira", "is") and s.get("secenekler"):
                b = self.rng.choice(s["secenekler"]) if self.ad == "rastgele" else s["secenekler"][0]
                return "devam", {"indeks": b["indeks"]}
        if ekran == "koy":
            koy = s["koy"]
            adim = self.koy_adimi.get(s["gun"], 0)
            self.koy_adimi[s["gun"]] = adim + 1
            if adim < 16:
                binalar = koy["binalar"]
                for kisi in koy["bosta"]:
                    for b in binalar:
                        if b["id"] in kisi.get("atanabilir_binalar", []) and b["tur"] in ("tarla", "avci", "hizarhane"):
                            return "koy_eylem", {"tur": "ata", "koylu": kisi["id"], "bina": b["id"]}
                sayilar = {}
                for b in binalar:
                    sayilar[b["tur"]] = sayilar.get(b["tur"], 0) + 1
                istekler = []
                if sayilar.get("tarla", 0) < max(1, (koy["nufus"] + 3) // 4):
                    istekler.append("tarla")
                if sayilar.get("hizarhane", 0) < 1:
                    istekler.append("hizarhane")
                gelecek_yatak = koy["yatak"] + sum(b.get("yatak", 0) for b in binalar if not b["hazir"])
                if gelecek_yatak < koy["nufus"] + 2:
                    istekler.append("cadir")
                for tur in istekler:
                    for b in koy["kurulabilir"]:
                        if b["tur"] == tur and b["hucreler"]:
                            return "koy_eylem", {"tur": "insa", "bina": tur, "hucre": b["hucreler"][0]}
            return "gece_bitir", {}
        return None


def bos_port():
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        return sock.getsockname()[1]


def sureci_kapat(process):
    if process.poll() is None:
        if os.name == "nt":
            # Godot console launcher may own a child engine process.
            subprocess.run(["taskkill", "/PID", str(process.pid), "/T", "/F"],
                           capture_output=True, timeout=10)
            process.wait(timeout=5)
            return
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait(timeout=5)


def arac_raporu(ozet):
    araclar = ozet["ILKSAAT_ARACLAR"]
    adlar = {
        "koy_hizi": "Köy hızı", "koy_atama": "İşçi atama",
        "kapi_selam": "Kapı selamı", "kapi_konu": "İlk aileye konu sorusu",
        "kapi_karar": "Kapı kararı", "heybe": "Heybeyi açma",
        "beyan": "Heybe beyanını sorma", "bakmak": "Nişan ve yükü inceleme",
        "yemin": "Yemin",
    }
    satirlar = [
        "# İlk altı gecede araç kullanımı",
        "",
        f"Tohum {ozet['tohum']}, politika {ozet['politika']}, "
        f"tamamlanan gece {ozet['gece_sayisi']}, hata {ozet['hata_sayisi']}.",
        "Gece numaraları sıfır tabanlıdır.",
        "",
        "| Araç | Durum | İlk kullanım gecesi |",
        "| --- | --- | --- |",
    ]
    for kimlik, ad in adlar.items():
        gece = araclar.get(kimlik)
        if gece is None:
            durum = "Ölçülmedi"
        else:
            durum = "Kullanıldı" if gece >= 0 else "Kullanılmadı"
        satirlar.append(f"| {ad} | {durum} | {gece if gece is not None and gece >= 0 else '—'} |")
    return "\n".join(satirlar) + "\n"


def oyna(args):
    cikti = args.cikti or ROOT / f"work/tester/oyun_{args.tohum}.jsonl"
    cikti = cikti.resolve()
    cikti.parent.mkdir(parents=True, exist_ok=True)
    port = args.port or bos_port()
    # Godot'un normal oyuncu slotları korunur; otomatik faz kayıtları da burada.
    slot = cikti.parent / f"kayit_{args.tohum}_{port}"
    env = {**os.environ, "BRIDGE_IDLE_QUIT_S": "0", "BRIDGE_TESTER_DIR": str(slot)}
    if os.name == "nt":
        appdata = slot / "appdata"
        (appdata / "Godot").mkdir(parents=True, exist_ok=True)
        env["APPDATA"] = str(appdata)
    command = [args.godot, "--path", str(ROOT), "--audio-driver", "Dummy"]
    command += ["--headless"] if args.headless else ["--windowed"]
    command += ["--", "--bridge-port", str(port)]
    politika = Politika(args.politika, args.tohum)
    client = Bridge(port=port, timeout=min(30, args.zaman_asimi))
    hatalar, adim, son, gece = 0, 0, "", 0
    neden = ""
    ilk_saat = []
    ilk_saat_araclar = {}
    process = None
    baslangic = time.monotonic()
    log_path = cikti.with_suffix(".godot.log")
    try:
        with log_path.open("w", encoding="utf-8") as log, cikti.open("w", encoding="utf-8") as out:
            options = {"creationflags": subprocess.CREATE_NO_WINDOW} if os.name == "nt" else {}
            process = subprocess.Popen(command, cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT, **options)
            ready, why = wait_ready(port, min(90, args.zaman_asimi), alive=lambda: process.poll() is None)
            if not ready:
                raise BridgeError("Köprü açılamadı: " + why)
            client.call("yeni_oyun", tohum=args.tohum)
            while time.monotonic() - baslangic < args.zaman_asimi:
                if process.poll() is not None:
                    raise BridgeError("Godot beklenmedik şekilde kapandı")
                s = client.call("get_state")
                gece = s.get("tamamlanan_gece", 0)
                ilk_saat = s.get("ILKSAAT", ilk_saat)
                ilk_saat_araclar = s.get("ILKSAAT_ARACLAR", ilk_saat_araclar)
                kayit = {"adim": adim, "sure": round(time.monotonic() - baslangic, 3), "state": s}
                if s["ekran"] == "son":
                    son = s["son"]["kimlik"]
                    neden = "son"
                    out.write(json.dumps(kayit, ensure_ascii=False) + "\n")
                    break
                # Limit rapor ve olay tamamlanınca, sonraki kapıya gelmeden de durabilir.
                if gece >= args.gece and s["ekran"] != "rapor":
                    neden = "gece_siniri"
                    out.write(json.dumps(kayit, ensure_ascii=False) + "\n")
                    break
                eylem = politika.sec(s)
                if eylem:
                    cmd, kw = eylem
                    kayit["eylem"] = {"cmd": cmd, "args": kw}
                    try:
                        kayit["sonuc"] = client.call(cmd, **kw)
                    except BridgeError as error:
                        hatalar += 1
                        kayit["error"] = str(error)
                out.write(json.dumps(kayit, ensure_ascii=False) + "\n")
                out.flush()
                adim += 1
                time.sleep(args.bekle)
            else:
                hatalar += 1
                neden = "zaman_asimi"
            try:
                client.call("quit")
            except BridgeError:
                pass
    except (BridgeError, OSError) as error:
        hatalar += 1
        neden = str(error)
    finally:
        client.close()
        if process is not None:
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                sureci_kapat(process)
    log = log_path.read_text(encoding="utf-8", errors="replace") if log_path.exists() else ""
    engine_hata = any(k in log for k in ("SCRIPT ERROR", "Parse Error", "Failed to load script"))
    if engine_hata:
        hatalar += 1
    ozet = {"son": son or None, "gece_sayisi": gece, "hata_sayisi": hatalar, "adim": adim,
            "durma": neden, "tohum": args.tohum, "politika": args.politika, "cikti": str(cikti),
            "ILKSAAT": ilk_saat, "ILKSAAT_ARACLAR": ilk_saat_araclar}
    if args.arac_raporu:
        if gece < 6 or hatalar or not ilk_saat_araclar:
            print("Araç raporu için altı tamamlanmış gece ve araç ölçümü gerekli.", file=sys.stderr)
            hatalar += 1
            ozet["hata_sayisi"] = hatalar
        else:
            cikti.with_suffix(".araclar.md").write_text(arac_raporu(ozet), encoding="utf-8")
    cikti.with_suffix(".ozet.json").write_text(json.dumps(ozet, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(ozet, ensure_ascii=False))
    return 0 if neden in ("son", "gece_siniri") and hatalar == 0 else 1


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default=os.environ.get("GODOT_BIN", "godot"))
    parser.add_argument("--headless", action="store_true", help="Penceresiz; varsayılan pencereli")
    parser.add_argument("--tohum", type=int, default=11)
    parser.add_argument("--politika", choices=("rastgele", "temkinli", "rusvetci"), default="temkinli")
    parser.add_argument("--gece", type=int, default=30, help="Tamamlanan gece sınırı")
    parser.add_argument("--cikti", type=Path)
    parser.add_argument("--arac-raporu", action="store_true", help="İlk altı gecenin araç tablosunu yaz")
    parser.add_argument("--port", type=int, default=0, help="0: boş localhost portu seç")
    parser.add_argument("--zaman-asimi", type=float, default=1800)
    parser.add_argument("--bekle", type=float, default=0.15)
    args = parser.parse_args(argv)
    if args.gece < 1 or args.zaman_asimi <= 0 or args.bekle < 0 or not 0 <= args.port <= 65535:
        parser.error("gece/zaman aşımı pozitif, bekle >= 0, port 0..65535 olmalı")
    if args.arac_raporu and args.gece < 6:
        parser.error("--arac-raporu en az 6 gece gerektirir")
    return oyna(args)


if __name__ == "__main__":
    raise SystemExit(main())
