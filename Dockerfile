FROM nginx:1.25-alpine

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Accept version as build arg
ARG VERSION=v1.0.0
ARG BUILD_DATE
ARG GIT_COMMIT

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
