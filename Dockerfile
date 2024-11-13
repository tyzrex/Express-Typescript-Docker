# Stage 1: Install dependencies
FROM node:18 AS dependencies
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm

# Copy package.json and pnpm-lock.yaml to cache dependencies
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# Stage 2: Build the TypeScript application
FROM dependencies AS builder
WORKDIR /app
COPY . .
RUN pnpm build  # Assumes your build command is defined in package.json

# Stage 3: Production environment
FROM node:18 AS production
WORKDIR /app

# Install pnpm in the final image
RUN npm install -g pnpm

# Copy only the production dependencies from the dependencies stage
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --prod

# Copy the build files from the builder stage
COPY --from=builder /app/dist ./dist

# Copy Prisma schema and migrations
COPY prisma ./prisma
RUN pnpm prisma generate

# Start the production server
CMD ["node", "dist/server.js"]

# Stage 4: Development environment
FROM node:18 AS development
WORKDIR /app

# Install pnpm globally in the development container
RUN npm install -g pnpm

# Copy package.json and pnpm-lock.yaml for installation
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# Copy all source code
COPY . .

# Generate Prisma Client
RUN pnpm prisma generate

# Expose port for development server
EXPOSE 8080

# Start the application in dev mode with live-reloading
CMD ["pnpm", "dev"]
