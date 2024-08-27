# Use a newer Node.js LTS version for the build stage
FROM node:20 as build 

# Set the working directory
WORKDIR /react-app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Upgrade npm to the latest version
RUN npm install -g npm@10.8.2

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
RUN npm run build

# Use the official Nginx image to serve the build
FROM nginx:1.19

# Copy custom Nginx configuration
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the build output from the previous stage
COPY --from=build /react-app/build /usr/share/nginx/html
