ARG VERSION=latest
ARG UBUNTU_VERSION=jammy
FROM jellyfin/jellyfin:${VERSION} as jellyfin

FROM ubuntu:${UBUNTU_VERSION} as base

ARG UBUNTU_VERSION
ARG TARGETARCH
RUN echo "deb [arch=${TARGETARCH}] https://repo.jellyfin.org/master/ubuntu ${UBUNTU_VERSION} main" 
# Set the health URL
ENV HEALTHCHECK_URL=http://localhost:8096/health

# Default environment variables for the Jellyfin invocation
ENV DEBIAN_FRONTEND="noninteractive" \
    UBUNTU_FRONTEND="noninteractive" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    JELLYFIN_DATA_DIR="/config" \
    JELLYFIN_CACHE_DIR="/cache" \
    JELLYFIN_CONFIG_DIR="/config/config" \
    JELLYFIN_LOG_DIR="/config/log" \
    JELLYFIN_WEB_DIR="/jellyfin/jellyfin-web" \
    JELLYFIN_FFMPEG="/usr/lib/jellyfin-ffmpeg/ffmpeg"

# required for fontconfig cache
ENV XDG_CACHE_HOME=${JELLYFIN_CACHE_DIR}

# https://github.com/dlemstra/Magick.NET/issues/707#issuecomment-785351620
ENV MALLOC_TRIM_THRESHOLD_=131072

# https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(Native-GPU-Support)
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# Install dependencies:
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests --yes \
    ca-certificates \
    gnupg \
    curl \
    apt-transport-https \
 && curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key \
  | gpg --dearmor -o /etc/apt/trusted.gpg.d/ubuntu-jellyfin.gpg \
 && echo "deb [arch=${TARGETARCH}] https://repo.jellyfin.org/master/ubuntu ${UBUNTU_VERSION} main" > /etc/apt/sources.list.d/jellyfin.list \
 && apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests --yes \
    ${FFMPEG_PACKAGE} \
    openssl \
    locales \
    libfontconfig1 \
    libfreetype6 \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen \
 && apt-get remove gnupg apt-transport-https --yes \
 && apt-get clean autoclean --yes \
 && apt-get autoremove --yes \
 && rm -rf /var/cache/apt/archives* /var/lib/apt/lists/*
 
RUN apt update && apt full-upgrade -y && apt install -y curl gpg

#Documented solution
#RUN mkdir -p /etc/apt/keyrings
#RUN curl -fsSL https://repo.radeon.com/rocm/rocm.gpg.key | gpg --dearmor -o /etc/apt/keyrings/rocm.gpg
#RUN cat <<EOF | tee /etc/apt/sources.list.d/01_rocm.sources
#Types: deb
#URIs: https://repo.radeon.com/rocm/apt/latest
#Suites: ${UBUNTU_VERSION}
#Components: main
#Architectures: amd64
#Signed-By: /etc/apt/keyrings/rocm.gpg
#EOF
#RUN apt update && apt install -y rocm-opencl-runtime \
# && apt-get clean autoclean --yes \
# && apt-get autoremove --yes \
# && rm -rf /var/cache/apt/archives* /var/lib/apt/lists/*

WORKDIR /tmp
ADD https://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/${UBUNTU_VERSION}/amdgpu-install_6.0.60002-1_all.deb /tmp
RUN apt install -y /tmp/amdgpu-install_6.0.60002-1_all.deb
#RUN amdgpu-install -y --usecase=graphics,rocm
#RUN amdgpu-install --opencl=rocr --no-dkms -y
RUN amdgpu-install --usecase=opencl --no-dkms -y
#RUN usermod -a -G render,video $LOGNAME

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libamdocl64.so" > /etc/OpenCL/vendors/amdocl64.icd
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so
WORKDIR /

RUN mkdir -p ${JELLYFIN_DATA_DIR} ${JELLYFIN_CACHE_DIR} \
 && chmod 777 ${JELLYFIN_DATA_DIR} ${JELLYFIN_CACHE_DIR}

COPY --from=jellyfin /jellyfin /jellyfin

EXPOSE 8096
VOLUME ${JELLYFIN_DATA_DIR} ${JELLYFIN_CACHE_DIR}
ENTRYPOINT [ "/jellyfin/jellyfin", \
             "--ffmpeg", "/usr/lib/jellyfin-ffmpeg/ffmpeg" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 \
     CMD curl -Lk -fsS "${HEALTHCHECK_URL}" || exit 1

