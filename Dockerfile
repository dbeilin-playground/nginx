FROM nginx:1.25-alpine AS base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Accept version as build arg
ARG VERSION=v1.0.0
ARG BUILD_DATE
ARG GIT_COMMIT

# Production stage
FROM base AS production

# Create a custom page that shows build info
RUN echo '<!DOCTYPE html>' > /usr/share/nginx/html/index.html && \
    echo '<html><head>' >> /usr/share/nginx/html/index.html && \
    echo '<meta charset="UTF-8">' >> /usr/share/nginx/html/index.html && \
    echo '<title>Test Nginx App</title></head>' >> /usr/share/nginx/html/index.html && \
    echo '<body style="font-family: Arial; text-align: center; padding: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">' >> /usr/share/nginx/html/index.html && \
    echo '<h1>🚀 Test Nginx App</h1>' >> /usr/share/nginx/html/index.html && \
    echo "<h2>Version: ${VERSION}</h2>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Built: ${BUILD_DATE}</p>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Commit: ${GIT_COMMIT}</p>" >> /usr/share/nginx/html/index.html && \
    echo '<p>Environment: <span id="env">Loading...</span></p>' >> /usr/share/nginx/html/index.html && \
    echo '<script>document.getElementById("env").innerText = window.location.hostname;</script>' >> /usr/share/nginx/html/index.html && \
    echo '</body></html>' >> /usr/share/nginx/html/index.html

EXPOSE 80

# Debug/Profiling stage
FROM base AS pprof

# Install debugging and profiling tools
RUN apk add --no-cache \
    curl \
    htop \
    strace \
    tcpdump \
    net-tools \
    lsof \
    procps \
    && rm -rf /var/cache/apk/*

# Enable nginx status module for monitoring
RUN echo 'server {' > /etc/nginx/conf.d/status.conf && \
    echo '    listen 8080;' >> /etc/nginx/conf.d/status.conf && \
    echo '    location /nginx_status {' >> /etc/nginx/conf.d/status.conf && \
    echo '        stub_status on;' >> /etc/nginx/conf.d/status.conf && \
    echo '        access_log off;' >> /etc/nginx/conf.d/status.conf && \
    echo '        allow all;' >> /etc/nginx/conf.d/status.conf && \
    echo '    }' >> /etc/nginx/conf.d/status.conf && \
    echo '}' >> /etc/nginx/conf.d/status.conf

# Create a custom page that shows build info with profiling indicators
RUN echo '<!DOCTYPE html>' > /usr/share/nginx/html/index.html && \
    echo '<html><head>' >> /usr/share/nginx/html/index.html && \
    echo '<meta charset="UTF-8">' >> /usr/share/nginx/html/index.html && \
    echo '<title>Test Nginx App - Profiling Edition</title></head>' >> /usr/share/nginx/html/index.html && \
    echo '<body style="font-family: Arial; text-align: center; padding: 50px; background: linear-gradient(135deg, #ff6b6b 0%, #ffa500 100%); color: white;">' >> /usr/share/nginx/html/index.html && \
    echo '<h1>🚀 Test Nginx App - Profiling Edition 🔍</h1>' >> /usr/share/nginx/html/index.html && \
    echo "<h2>Version: ${VERSION}</h2>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Built: ${BUILD_DATE}</p>" >> /usr/share/nginx/html/index.html && \
    echo "<p>Commit: ${GIT_COMMIT}</p>" >> /usr/share/nginx/html/index.html && \
    echo '<p>🐛 Debug Mode: ENABLED</p>' >> /usr/share/nginx/html/index.html && \
    echo '<p>📊 Profiling Tools: Available</p>' >> /usr/share/nginx/html/index.html && \
    echo '<p>Environment: <span id="env">Loading...</span></p>' >> /usr/share/nginx/html/index.html && \
    echo '<div style="margin-top: 30px; padding: 20px; background: rgba(0,0,0,0.2); border-radius: 10px;">' >> /usr/share/nginx/html/index.html && \
    echo '<h3>🔧 Debug Endpoints</h3>' >> /usr/share/nginx/html/index.html && \
    echo '<p><a href="/nginx_status" style="color: #fff; text-decoration: underline;">Nginx Status</a> (Port 8080)</p>' >> /usr/share/nginx/html/index.html && \
    echo '<p>Debug tools: curl, htop, strace, tcpdump, netstat available</p>' >> /usr/share/nginx/html/index.html && \
    echo '</div>' >> /usr/share/nginx/html/index.html && \
    echo '<script>document.getElementById("env").innerText = window.location.hostname;</script>' >> /usr/share/nginx/html/index.html && \
    echo '</body></html>' >> /usr/share/nginx/html/index.html

EXPOSE 80 8080
