# Build Stage
FROM node:22-alpine AS build

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies using npm ci for clean install
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production Stage
FROM nginx:alpine

# Copy built assets from build stage to nginx serving directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
