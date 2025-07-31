FROM node:18-slim

# Set working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy source and static files
COPY src/ src/
COPY public/ public/

# Expose the app port
EXPOSE 80

# Start the application
CMD ["node", "src/index.js"]
