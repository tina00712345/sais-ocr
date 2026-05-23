FROM nvidia/cuda:12.0-runtime-ubuntu22.04

ENV TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-setuptools \
        tini \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/src /app/models /saisresult

RUN pip3 install --no-cache-dir \
        torch \
        torchvision \
        ultralytics \
        opencv-python-headless \
        numpy \
        Pillow \
        pyyaml \
    --index-url https://mirrors.aliyun.com/pypi/simple

COPY src/ /app/src/
COPY models/ /app/models/
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

WORKDIR /app
ENTRYPOINT ["/usr/bin/tini", "--", "bash", "/app/run.sh"]
```
