# Use Node.js 18 LTS as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy source code
COPY . ./

# Copy production environment file
COPY env.production .env.local

# Build the Next.js application
RUN npm run build


# Expose port 3000 (Next.js default)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1

# Start the application
CMD ["node", ".next/standalone/server.js"]
