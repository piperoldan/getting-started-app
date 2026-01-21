# Stage 1: The Build Environment
FROM node:23-alpine AS build
WORKDIR /app

# Copy ONLY package.json (we are going to let npm regenerate the lockfile)
COPY package.json ./

# 1. Install everything (NPM will look at the 'overrides' we put in package.json)
RUN npm install

# 2. THE BRUTE FORCE FIX (Done right here in the build stage)
RUN npm install form-data@2.5.4

# Copy source
COPY . .

# Stage 2: The Production Environment
FROM node:18-alpine
WORKDIR /app

# Copy ONLY what is absolutely necessary
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src
COPY --from=build /app/package.json ./

EXPOSE 3000
CMD ["node", "src/index.js"]