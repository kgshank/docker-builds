ARG VERSION
FROM jellyfin/jellyfin:${VERSION:-latest}
RUN apt update && apt full-upgrade -y && apt install -y curl gpg

#Documented solution
#RUN mkdir -p /etc/apt/keyrings
#RUN curl -fsSL https://repo.radeon.com/rocm/rocm.gpg.key | gpg --dearmor -o /etc/apt/keyrings/rocm.gpg
#RUN cat <<EOF | tee /etc/apt/sources.list.d/01_rocm.sources
#Types: deb
#URIs: https://repo.radeon.com/rocm/apt/latest
#Suites: ubuntu
#Components: main
#Architectures: amd64
#Signed-By: /etc/apt/keyrings/rocm.gpg
#EOF
#RUN apt update && apt install -y rocm-opencl-runtime

#Broken packages fix attempt
#RUN apt update && apt full-upgrade -y
#WORKDIR /tmp/rocm
#ENV OPENCL_VERSION=6.1.1.60101-90~20.04
#ADD https://repo.radeon.com/rocm/apt/latest/pool/main/r/rocm-opencl-runtime/rocm-opencl-runtime_${OPENCL_VERSION}_amd64.deb /tmp/rocm
#ADD https://repo.radeon.com/rocm/apt/latest/pool/main/r/rocm-language-runtime/rocm-language-runtime_${OPENCL_VERSION}_amd64.deb /tmp/rocm
#RUN apt update && apt install -y rocm-core comgr hsa-rocr rocm-core openmp-extras-runtime rocm-opencl rocm-opencl-icd-loader
#RUN apt install -y /tmp/rocm/rocm-opencl-runtime_${OPENCL_VERSION}_amd64.deb /tmp/rocm/rocm-language-runtime_${OPENCL_VERSION}_amd64.deb

#Broken packages fix attempt2
ARG UBUNTU_VERSION=jammy
WORKDIR /tmp
ADD https://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/${UBUNTU_VERSION}/amdgpu-install_6.0.60002-1_all.deb /tmp
RUN apt install -y /tmp/amdgpu-install_6.0.60002-1_all.deb
RUN amdgpu-install --usecase=opencl --no-dkms -y

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libamdocl64.so" > /etc/OpenCL/vendors/amdocl64.icd
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so
WORKDIR /

RUN apt-get clean autoclean --yes \
 && apt-get autoremove --yes \
 && rm -rf /var/cache/apt/archives* /var/lib/apt/lists/*
