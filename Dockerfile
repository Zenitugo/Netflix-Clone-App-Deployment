# syntax=docker/dockerfile:1

ARG NODE_VERSION=20

################################################################################
# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine AS base

# Set working directory for all build stages.
WORKDIR /usr/src/app

################################################################################
# Create a stage for installing production dependencies.
FROM base AS deps

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.yarn to speed up subsequent builds.
# Leverage bind mounts to package.json and yarn.lock to avoid having to copy them
# into this layer.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=yarn.lock,target=yarn.lock \
    --mount=type=cache,target=/root/.yarn \
    yarn install --production --frozen-lockfile

################################################################################
# Create a stage for building the application.
FROM deps AS build

# Download additional development dependencies before building, as some projects require
# "devDependencies" to be installed to build. If you don't need this, remove this step.
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=yarn.lock,target=yarn.lock \
    --mount=type=cache,target=/root/.yarn \
    yarn install --frozen-lockfile

# Copy the rest of the source files into the image.
COPY . .

# Set environment variables and build the application.
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn run build

################################################################################
# Create a new stage to run the application with minimal runtime dependencies
# using nginx.
FROM nginx:stable-alpine AS final

# Set working directory for nginx.
WORKDIR /usr/share/nginx/html

# Clean default nginx html directory.
RUN rm -rf ./*

# Copy the build output from the previous stage.
COPY --from=build /usr/src/app/dist .


# Copy custom nginx configuration
#COPY nginx.conf /etc/nginx/nginx.conf


# Expose the port that the application listens on.
EXPOSE 80

# Run nginx in the foreground.
CMD ["nginx", "-g", "daemon off;"]
