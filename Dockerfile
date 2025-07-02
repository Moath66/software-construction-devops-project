# Multi-stage build for Node.js application
FROM node:18-alpine AS backend-build

# Set working directory for backend
WORKDIR /app/backend

# Copy backend package files first (for better caching)
COPY css_backend/package*.json ./

# Install backend dependencies
RUN npm ci --only=production

# Copy backend source code
COPY css_backend/ ./

# Build stage for frontend
FROM node:18-alpine AS frontend-build

# Set working directory for frontend
WORKDIR /app/frontend

# Copy frontend package files first (for better caching)
COPY css_frontend/package*.json ./

# Install frontend dependencies
RUN npm ci

# Copy frontend source code
COPY css_frontend/ ./

# Build frontend for production
RUN npm run build

# Final stage - Runtime
FROM node:18-alpine

# Install curl for health check
RUN apk add --no-cache curl

# Create app directory
WORKDIR /app

# Copy backend from build stage (without node_modules)
COPY --from=backend-build /app/backend/package*.json ./backend/
COPY --from=backend-build /app/backend/src ./backend/src
COPY --from=backend-build /app/backend/node_modules ./backend/node_modules

# Copy frontend build
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Set working directory to backend
WORKDIR /app/backend

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Change ownership of app directory
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Start the application
CMD ["npm", "start"]
