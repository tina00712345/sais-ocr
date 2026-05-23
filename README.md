# SAIS Ancient OCR — YOLOv8m + EfficientNet-B0/ArcFace

## Model Overview

Two-stage OCR pipeline for ancient Chinese bronze inscription detection and recognition:

1. **Detection** — YOLOv8m detects character bounding boxes on full rubbing images
2. **Recognition** — EfficientNet-B0 backbone + ArcFace margin loss, 2812-character classifier

## Environment

- **OS**: Ubuntu 22.04 (nvidia/cuda:12.0-runtime-ubuntu22.04)
- **Python**: 3.10
- **CUDA**: 12.0
- **PyTorch**: 2.x (with CUDA 12.x support)
- **Key libraries**: ultralytics, opencv-python-headless, numpy, Pillow

## Inference

Entry point: `bash /app/run.sh` (auto-executed on container start)

1. Reads PNG images from `/saisdata/13/eval/images/`
2. Runs YOLOv8m detection → extracts character crops
3. Runs EfficientNet-B0/ArcFace classifier → predicts character
4. Writes result to `/saisresult/prediction.json`

### Output format

```json
{
  "image_id_1": [
    {"bbox": [x, y, w, h], "text": "天"},
    {"bbox": [x, y, w, h], "text": "王"}
  ],
  "image_id_2": []
}
```

## Model Weights

All weights are inside the image at:

| File | Location | Description |
|------|----------|-------------|
| YOLO detection | `/app/models/yolo_best.pt` | YOLOv8m, trained on 6k+ rubbing images |
| Classifier | `/app/models/cls_inference.pt` | EfficientNet-B0 + ArcFace, 2812 classes |
| Class mapping | `/app/models/class_names.json` | Index → Chinese character mapping |

## Training

- **Detection**: YOLOv8m, 20 epochs, imgsz=1280, batch=8, mAP50=0.466
- **Classification**: EfficientNet-B0 + ArcFace (s=30, m=0.5), 30 epochs, imgsz=128, batch=64, Top-1 Acc=86.24%

## External Data

- Cross-domain training data (6,000+ full rubbing images) for YOLO detection
- HUST-OBC dataset (62k+ single-character images, 2812 classes) for classifier training

## Submission

- Input: `/saisdata/13/eval/images/*.png`
- Output: `/saisresult/prediction.json`
- Entry point: `/app/run.sh`
- Random seed: 42 (fixed for reproducibility)
