# ----------------------------
# Backend Build Stage
# ----------------------------
FROM node:18-alpine AS backend-build

# Set working directory for backend
WORKDIR /app/backend

# Copy backend dependencies files
COPY css_backend/package*.json ./

# Install backend dependencies (production only)
RUN npm ci --only=production

# Copy all backend source code
COPY css_backend/ ./

# ----------------------------
# Frontend Build Stage
# ----------------------------
FROM node:18-alpine AS frontend-build

# Set working directory for frontend
WORKDIR /app/frontend

# Copy frontend dependencies files
COPY css_frontend/package*.json ./

# Install frontend dependencies
RUN npm ci

# Copy all frontend source code
COPY css_frontend/ ./

# Build frontend production bundle
RUN npm run build

# ----------------------------
# Final Stage (Runtime)
# ----------------------------
FROM node:18-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy backend app (excluding dev dependencies)
COPY --from=backend-build /app/backend ./backend
COPY --from=backend-build /app/backend/node_modules ./backend/node_modules

# Copy frontend build output
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Set working directory to backend for start
WORKDIR /app/backend

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose backend port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Start the backend app
CMD ["npm", "start"]
