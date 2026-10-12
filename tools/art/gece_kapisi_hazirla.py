"""Existing raster sources only: chroma/neutral background removal, crop and padding.

No generation, downloads, API, model weights or game code. Run with PYTHONUTF8=1.
Neutral backgrounds need visual approval: iron and checkerboards can share colors.
"""
from pathlib import Path
import argparse
import hashlib
import json

import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageOps, ImageEnhance
from scipy import ndimage


def remove_background(image, method, hole=False):
    if method not in ("magenta", "green", "neutral"):
        raise ValueError("Unknown background method: " + method)
    rgb = np.asarray(image.convert("RGB"))
    a = rgb.astype(np.int16)
    if method in ("magenta", "green"):
        strength = (np.minimum(a[:, :, 0], a[:, :, 2]) - a[:, :, 1]
                    if method == "magenta" else a[:, :, 1] - np.maximum(a[:, :, 0], a[:, :, 2]))
        alpha = np.clip((65 - strength.astype(np.float32)) * 255 / 45, 0, 255).astype(np.uint8)
        # JPEG contaminated edge colors replaced from nearest solid object pixel.
        edge = (alpha > 0) & (alpha < 255)
        if edge.any():
            _, nearest = ndimage.distance_transform_edt(alpha < 255, return_indices=True)
            rgb = rgb.copy()
            rgb[edge] = rgb[nearest[0][edge], nearest[1][edge]]
    else:
        # GrabCut on a bounded preview; protect dark interiors, let texture/color
        # distributions distinguish neutral iron from the repeated light ground.
        scale = min(1, 1200 / max(image.size))
        small = cv2.resize(rgb, None, fx=scale, fy=scale, interpolation=cv2.INTER_AREA)
        gray = small.mean(axis=2)
        chroma = small.max(axis=2).astype(int) - small.min(axis=2).astype(int)
        labels = np.full(gray.shape, cv2.GC_PR_BGD, np.uint8)
        likely = (gray < 115) | (chroma > 32)
        count, components, stats, _ = cv2.connectedComponentsWithStats(likely.astype(np.uint8))
        if count < 2:
            raise ValueError("No object found")
        largest = 1 + stats[1:, cv2.CC_STAT_AREA].argmax()
        x, y, w, h, _ = stats[largest]
        labels[y:y+h, x:x+w] = cv2.GC_PR_FGD
        labels[(gray < 65) | (chroma > 55)] = cv2.GC_FGD
        labels[:3] = labels[-3:] = cv2.GC_BGD
        labels[:, :3] = labels[:, -3:] = cv2.GC_BGD
        if hole:
            labels[(gray > 150) & (chroma < 18)] = cv2.GC_BGD
        cv2.setRNGSeed(41)
        cv2.grabCut(small, labels, None, np.zeros((1, 65)), np.zeros((1, 65)), 5, cv2.GC_INIT_WITH_MASK)
        alpha = np.where((labels == cv2.GC_FGD) | (labels == cv2.GC_PR_FGD), 255, 0).astype(np.uint8)
        if not hole:
            alpha = (ndimage.binary_fill_holes(alpha > 0) * 255).astype(np.uint8)
        alpha = cv2.resize(alpha, image.size, interpolation=cv2.INTER_LINEAR)
    # Remove isolated speckles without erasing holes in frames.
    components, count = ndimage.label(alpha > 128)
    if count:
        sizes = np.bincount(components.ravel())
        sizes[0] = 0
        keep = ndimage.binary_dilation(components == sizes.argmax(), iterations=2)
        alpha[~keep] = 0
    rgba = np.dstack((rgb, alpha))
    rgba[alpha == 0, :3] = 0
    return Image.fromarray(rgba), method


def prepare(image, size, corner=None):
    bbox = image.getchannel("A").getbbox()
    if not bbox:
        raise ValueError("Empty alpha")
    crop = image.crop(bbox)
    width, height = size[0] - 32, size[1] - 32
    if width <= 0 or height <= 0:
        raise ValueError("Target too small for 16px padding")
    if corner:
        # Resize center/edge bands separately; preserve corner artwork proportions.
        sx, sy = corner["source"]
        tx, ty = corner["target"]
        if min(sx,sy,tx,ty) <= 0 or 2*sx >= crop.width or 2*sy >= crop.height or 2*tx >= width or 2*ty >= height:
            raise ValueError("Nine-slice corners leave no center band")
        source_x = (0, sx, crop.width-sx, crop.width)
        source_y = (0, sy, crop.height-sy, crop.height)
        target_x = (0, tx, width-tx, width)
        target_y = (0, ty, height-ty, height)
        obj = Image.new("RGBA", (width, height))
        for r in range(3):
            for c in range(3):
                piece = crop.crop((source_x[c], source_y[r], source_x[c+1], source_y[r+1]))
                piece = piece.resize((target_x[c+1]-target_x[c], target_y[r+1]-target_y[r]), Image.Resampling.LANCZOS)
                obj.paste(piece, (target_x[c], target_y[r]))
    else:
        obj = ImageOps.contain(crop, (width, height), Image.Resampling.LANCZOS)
    result = Image.new("RGBA", size)
    result.paste(obj, ((size[0]-obj.width)//2, (size[1]-obj.height)//2))
    return result, list(bbox)


def run(config_path, output):
    config = json.loads(config_path.read_text(encoding="utf-8"))
    output.mkdir(parents=True, exist_ok=True)
    records = []
    for job in config:
        if Path(job["name"]).name != job["name"] or not job["name"].endswith(".png"):
            raise ValueError("Output name must be a single PNG filename")
        src = Path(job["source"])
        with Image.open(src) as im:
            if job.get("derived"):
                result = im.convert("RGBA")
                alpha = result.getchannel("A")
                if job["derived"] == "outline":
                    mask = np.asarray(alpha) > 128
                    ring = mask & ~ndimage.binary_erosion(mask, iterations=3)
                    result = Image.new("RGBA", im.size, "#C88A43")
                    result.putalpha(Image.fromarray((ring * 255).astype(np.uint8)))
                elif job["derived"] == "checkmark":
                    with Image.open(job["detail_source"]) as detail:
                        pixels = np.asarray(detail.convert("RGBA"))
                        tick = (pixels[:,:,0] > 160) & (pixels[:,:,1] > 150) & (pixels[:,:,2] > 105) & (pixels[:,:,3] > 128)
                        detail = detail.convert("RGBA")
                        detail.putalpha(Image.fromarray((tick * 255).astype(np.uint8)))
                        result.alpha_composite(detail.resize(im.size, Image.Resampling.LANCZOS))
                    result.putalpha(alpha)
                else:
                    if job.get("desaturate"):
                        result = ImageEnhance.Color(result).enhance(0.2)
                    result = ImageEnhance.Brightness(result).enhance(job["brightness"])
                    result.putalpha(alpha)
                bbox, method = None, "aynı ana şekilden " + job["derived"]
            elif job.get("opaque"):
                result = ImageOps.fit(im.convert("RGB"), tuple(job["size"]), Image.Resampling.LANCZOS)
                bbox, method = None, "opak merkez kadraj"
            else:
                if job.get("roi"):
                    # Manually reviewed rectangular silhouette, not color-based
                    # deletion of grey metal that resembles the checkerboard.
                    roi = tuple(round(v * (im.width if i % 2 == 0 else im.height)) for i, v in enumerate(job["roi"]))
                    cut = im.crop(roi).convert("RGBA")
                    mask = Image.new("L", cut.size)
                    if job.get("polygon"):
                        points = [(round(x*cut.width), round(y*cut.height)) for x,y in job["polygon"]]
                        ImageDraw.Draw(mask).polygon(points, fill=255)
                    else:
                        ImageDraw.Draw(mask).rounded_rectangle((0, 0, cut.width-1, cut.height-1), radius=job.get("radius", 0), fill=255)
                    if job.get("window"):
                        box = tuple(round(v * (cut.width if i % 2 == 0 else cut.height)) for i, v in enumerate(job["window"]))
                        ImageDraw.Draw(mask).rectangle(box, fill=0)
                    if job.get("reject_neutral_above"):
                        pixels = np.asarray(cut)[:,:,:3].astype(np.int16)
                        unwanted = (pixels.mean(axis=2) > job["reject_neutral_above"]) & ((pixels.max(axis=2)-pixels.min(axis=2)) < 18)
                        cleaned = np.asarray(mask).copy()
                        cleaned[unwanted] = 0
                        mask = Image.fromarray(cleaned)
                    cut.putalpha(mask)
                    method = "elle denetlenen nesne/delik maskesi"
                elif job["method"] == "alpha":
                    cut, method = im.convert("RGBA"), "mevcut alfa korundu"
                else:
                    if job.get("pre_roi"):
                        box = tuple(round(v * (im.width if i % 2 == 0 else im.height)) for i, v in enumerate(job["pre_roi"]))
                        im = im.crop(box)
                    cut, method = remove_background(im, job["method"], job.get("hole", False))
                result, bbox = prepare(cut, tuple(job["size"]), job.get("corner"))
                if job.get("tint"):
                    alpha = result.getchannel("A")
                    result = ImageOps.colorize(ImageOps.grayscale(result), *job["tint"]).convert("RGBA")
                    result.putalpha(alpha)
        result.save(output/job["name"])
        records.append(dict(job, sha256=hashlib.sha256(src.read_bytes()).hexdigest(), crop=bbox, operation=method))
        if job.get("detail_source"):
            records[-1]["detail_sha256"] = hashlib.sha256(Path(job["detail_source"]).read_bytes()).hexdigest()
        print(job["name"], flush=True)
    (output/"hazirlama.json").write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("config", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    run(args.config, args.output)
