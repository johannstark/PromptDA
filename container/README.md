# PromptDA Container

This directory contains Docker configuration files for running PromptDA in a containerized environment.

## Requirements

- Docker with NVIDIA GPU support
- NVIDIA drivers compatible with CUDA 11.8
- docker-compose (for using docker-compose.yml)

## Container Configuration

The container includes:

- CUDA 11.8 with cuDNN for GPU acceleration
- PyTorch 2.0.1 with required dependencies
- FFmpeg for video processing
- Volume attachments for input/output data
- Persistent cache for HuggingFace models
  
## Usage

### Python demo script

You can run the Python demo script directly in the container. The script is located at `/app/demo.py`.
The results will be saved in the `/app/data` directory.

As we are mounting a volume for `/app/data`, you can access the results from your host machine on `./data`.

### Custom capture script

You can use your own capture data by placing the zip files in the `./zips` directory. The container will automatically mount this directory to `/app/zips` inside the container.
Use the `custom_capture.sh` script to run the capture process. The script will look for zip files in the `/app/zips` directory and process them.
The results will be saved in the `/app/data` directory.

```bash
./custom_capture.sh <zip_file_path_in_container>
```

## Quick Start

```bash
# From the project root directory
docker compose -f container/docker-compose.yml run --rm custom-promptda
```

## Directory Structure

When using docker-compose, the following directory structure is established:

- `/app/zips` - Mount point for zip files (read-only)
- `/app/data` - Mount point for input/output data
- `/app/.cache` - Persistent cache for HuggingFace models

## Building Manually

If you prefer to build and run the container manually:

```bash
# Build the image
docker build -t custom-promptda -f container/Dockerfile .

# Run interactively
docker run --gpus all -it custom-promptda
```

## Troubleshooting

- If you encounter CUDA errors, ensure your GPU drivers are compatible with CUDA 11.8
- For memory issues, decrease batch size or input resolution
- If container fails to start, ensure NVIDIA Docker runtime is installed and configured
  