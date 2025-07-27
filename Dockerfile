FROM node:18-alpine

WORKDIR /app

COPY src/ ./

RUN npm install express

EXPOSE 3000

CMD ["node", "index.js"]
