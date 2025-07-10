FROM node:18-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    bash

# Set working directory
WORKDIR /app

# Install plu-ts and related dependencies (excluding non-existent plutus-data-schema)
RUN npm install -g @harmoniclabs/plu-ts typescript ts-node

# Create a basic package.json for the container
RUN echo '{"name": "plu-ts-container", "version": "1.0.0", "dependencies": {"@harmoniclabs/plu-ts": "latest", "typescript": "latest", "ts-node": "latest"}}' > package.json

# Install dependencies
RUN npm install

# Set default command
CMD ["bash"]
