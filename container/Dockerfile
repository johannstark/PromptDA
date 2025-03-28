FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04 as base

# Avoid interactive prompts during installation
ARG DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    python3-setuptools \
    ffmpeg \
    git \
    wget \
	unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Create cache and data directories
RUN mkdir -p /app/data /app/.cache
ENV HF_HOME=/app/.cache

# Stage 1: Install dependencies
FROM base as app

# Copy only requirements file to leverage caching
COPY requirements.txt .

# Install Python dependencies with version pinning
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir open3d

# Copy application code
COPY . .

# Install in development mode and make scripts executable
RUN pip3 install -e . && \
    chmod +x /app/demo.py /app/custom_capture.sh

# Set environment variables for optimizing inference
ENV PYTHONUNBUFFERED=1 \
    OMP_NUM_THREADS=1 \
    PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128 \
    TORCH_CUDNN_V8_API_ENABLED=1 \
    PYTORCH_NO_CUDA_MEMORY_CACHING=1

# Set entrypoint
ENTRYPOINT ["/bin/bash"]
