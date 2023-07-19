# Docker Files

To push new images up to Docker hub

1. `docker login`
2. `docker build . --platform=linux/amd64 -t ${USER}/pyinstaller-windows:3.11 -t ${USER}/pyinstaller-windows:latest && docker push ${USER}/pyinstaller-windows:3.11 && docker push ${USER}/pyinstaller-windows:latest`