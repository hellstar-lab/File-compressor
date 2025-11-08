FROM python:3.11-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential make pkg-config && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
# Build the compressor CLI. This produces bin/universal_comp.exe which the server auto-detects.
RUN make bin/universal_comp.exe

FROM python:3.11-slim
WORKDIR /app
COPY --from=build /app /app
# Bind to 0.0.0.0 and use platform-provided PORT (Render sets PORT).
ENV HOST=0.0.0.0
ENV PORT=8080
EXPOSE 8080
CMD ["python3", "web/server.py"]