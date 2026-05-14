# Etapa 1: Construcción (Build)
FROM node:24-alpine AS builder

WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos todas las dependencias (incluyendo las de desarrollo para compilar)
RUN npm install

# Copiamos el resto del código y compilamos
COPY . .
RUN npm run build

# Etapa 2: Ejecución (Production)
FROM node:24-alpine

WORKDIR /app

# Variable de entorno para producción
ENV NODE_ENV=production

# Copiamos solo lo necesario desde la etapa anterior
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Instalamos solo dependencias de producción para ahorrar espacio
RUN npm install --only=production

EXPOSE 3002

# Comando para arrancar la app
CMD ["node", "dist/main"]