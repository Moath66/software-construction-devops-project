# Multi-stage build for Node.js application
FROM node:18-alpine AS backend-build

# Set working directory for backend
WORKDIR /app/backend

# Copy backend package files
COPY css_backend/package*.json ./

# Install backend dependencies
RUN npm install

# Copy backend source code
COPY css_backend/ ./

# Expose backend port
EXPOSE 5000

# Build stage for frontend
FROM node:18-alpine AS frontend-build

# Set working directory for frontend
WORKDIR /app/frontend

# Copy frontend package files
COPY css_frontend/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy frontend source code
COPY css_frontend/ ./

# Build frontend for production
RUN npm run build

# Final stage - combine both
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy backend from build stage
COPY --from=backend-build /app/backend ./backend

# Copy frontend build from build stage
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Set working directory to backend
WORKDIR /app/backend

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Start the application
CMD ["npm", "start"]
