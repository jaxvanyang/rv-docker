# Ultralytics YOLOv8 riscv64 Docker image
# Many codes are borrowed from https://github.com/ultralytics/ultralytics/blob/main/docker/Dockerfile-arm64

FROM jaxvanyang/rv-pytorch

# Install linux packages
# g++ required to build 'tflite_support' and 'lap' packages, libusb-1.0-0 required for 'tflite_support' package
# cmake and build-essential is needed to build onnxsim when exporting to tflite
RUN apt-get update && \
	apt-get install --no-install-recommends -y git zip htop libgl1 libglib2.0-0 \
		libpython3-dev gnupg libusb-1.0-0 python3-matplotlib python3-opencv \
		python3-pandas py-cpuinfo python3-seaborn && \
	rm -rf /var/lib/apt/lists/*

# Downloads to user config dir
ADD https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.ttf \
    https://github.com/ultralytics/assets/releases/download/v0.0.0/Arial.Unicode.ttf \
    /root/.config/Ultralytics/

# Create working directory
WORKDIR /usr/src/ultralytics

# Copy contents
ARG ultralytics_ver=8.1.0
RUN git clone https://github.com/ultralytics/ultralytics -b main /usr/src/ultralytics
ADD "https://github.com/ultralytics/assets/releases/download/v$ultralytics_ver/yolov8n.pt" /usr/src/ultralytics/

# pip don't recognize the python3-opencv system package, I don't know why
RUN sed -i '/opencv-python/d' pyproject.toml
RUN pip install --no-cache --no-build-isolation .

# Usage Examples -------------------------------------------------------------------------------------------------------

# Run
# t=jaxvanyang/ultralytics && sudo docker run -it --ipc=host $t

# Pull and Run
# t=jaxvanyang/ultralytics && sudo docker pull $t && sudo docker run -it --ipc=host $t

# Pull and Run with local volume mounted
# t=jaxvanyang/ultralytics && sudo docker pull $t && sudo docker run -it --ipc=host -v "$(pwd)"/datasets:/usr/src/datasets $t
