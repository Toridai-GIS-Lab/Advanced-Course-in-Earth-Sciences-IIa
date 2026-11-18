FROM ghcr.io/osgeo/gdal:ubuntu-small-3.13.3

# 講義で使う道具
RUN apt-get update \
 && apt-get install -y --no-install-recommends jq git sudo bash-completion less \
 && rm -rf /var/lib/apt/lists/*

# 一般ユーザー gis を作る（Ubuntu 既定の ubuntu ユーザーがあれば置き換える）
RUN (id -u ubuntu >/dev/null 2>&1 && userdel -r ubuntu || true) \
 && useradd -m -s /bin/bash -u 1000 gis \
 && echo "gis ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/gis \
 && chmod 0440 /etc/sudoers.d/gis

# 短いプロンプト
COPY prompt.sh /etc/course-prompt.sh
RUN echo 'source /etc/course-prompt.sh' >> /home/gis/.bashrc
