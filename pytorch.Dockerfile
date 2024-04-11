# PyTorch riscv64 Docker image

# Use experimental because PyTorch is only available in experimental for now
FROM riscv64/debian:experimental

RUN sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list.d/debian.sources && \
	sed -i "s|http://deb.debian.org/debian|http://mirror.sjtu.edu.cn/debian|g" /etc/apt/sources.list.d/experimental.list

RUN apt-get update && \
	apt-get install -y --no-install-recommends curl build-essential ninja-build \
		python3-pip python3-distutils python3-setuptools python3-torch python3-pil \
		libtorch-dev libjpeg-dev libpng-dev && \
	rm -rf /var/lib/apt/lists/*

# Creates a symbolic link to make 'python' point to 'python3'
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Remove python3.11/EXTERNALLY-MANAGED to avoid 'externally-managed-environment' issue, Debian 12 Bookworm error
RUN rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED

ARG vision_ver=0.17.2
RUN curl -L "https://github.com/pytorch/vision/archive/refs/tags/v$vision_ver.tar.gz" | \
	tar xz -C /root && \
	pip install --no-cache --no-build-isolation "/root/vision-$vision_ver" && \
	rm -rf "/root/vision-$vision_ver"
