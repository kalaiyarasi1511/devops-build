FROM nginx:alpine

# copy built site
COPY build/ /usr/share/nginx/html

# copy our nginx config (make sure file exists: nginx_default.conf)
COPY nginx_default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
