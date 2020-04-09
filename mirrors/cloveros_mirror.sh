main() {
if [ $(id -u) != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi
if [ "$(ping -c1 $1 2> /dev/null | awk -F "[()]" "NR==1 {print \$2}")" != "$(wget -qO - ifconfig.co)" ]; then
	echo "Usage: cloveros_mirror.sh YourDomain.com www.YourDomain.com YourOtherDomain.com
Domain name is required and must point to current IP. Only the first domain will be configured in nginx.

Required dependencies for nginx build: gcc, make, git, wget, includes for pcre/zlib/openssl
Debian: apt update && apt -y install gcc make git libpcre3-dev libssl-dev zlib1g-dev
Gentoo: emerge --sync && emerge git
CentOS/Fedora: yum update && yum install gcc make git wget libpcre-devel openssl-devel zlib-devel"
	exit 1
fi
for domain in "$@"; do
	domains+="DNS:$domain,"
done
domains="${domains%?}"
if [ ! -d "nginx/" ] || [ ! -d "conf/" ]; then
	if [ ! -f "/usr/bin/gcc" ] || [ ! -f "/usr/bin/make" ] || [ ! -f "/usr/bin/git" ] || [ ! -f "/usr/bin/wget" ] || [ ! -f "/usr/include/pcre.h" ] || [ ! -f "/usr/include/zlib.h" ] || [ ! -d "/usr/include/openssl/" ]; then
		if [ -f "/usr/bin/dpkg" ]; then
			apt update && apt -y install gcc make git libpcre3-dev libssl-dev zlib1g-dev
		fi
		if [ -f "/usr/bin/emerge" ]; then
			emerge --sync && emerge git
		fi
		if [ -f "/usr/bin/yum" ]; then
			yum update && yum install gcc make git wget libpcre-devel openssl-devel zlib-devel
		fi
	fi
	useradd www-data
	git clone --depth 1 https://github.com/nginx/nginx
	cd nginx/
	git clone --depth 1 https://github.com/eustas/ngx_brotli
	git clone --depth 1 https://github.com/arut/nginx-rtmp-module
	cd ngx_brotli ; git submodule update --init ; cd ..
	CFLAGS="-Ofast -march=native -mfpmath=both -pipe -funroll-loops -flto=8 -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -mtls-dialect=gnu2 -Wl,--hash-style=gnu" auto/configure --with-http_v2_module --with-http_realip_module --with-http_ssl_module --add-module=ngx_brotli --add-module=nginx-rtmp-module --with-file-aio --with-threads
	make -j8
	cp -R conf ..
	cd ..
	echo "$(nginxconfigtemplatefn)" > conf/nginx.conf
	openssl dhparam -out conf/dhparam.pem 4096
	mkdir conf/ssl/
	mkdir conf/logs/
	sed -ri "s/(ssl_certificate.*;)/#\1/; s/(listen 443 ssl http2;)/#\1/" conf/nginx.conf
	nginx/objs/nginx -p conf/ -c nginx.conf
	mkdir -p /var/www/html/.well-known/acme-challenge/
	openssl genrsa 4096 > conf/ssl/account.key
	openssl genrsa 4096 > conf/ssl/certificate.key
	openssl req -new -sha256 -key conf/ssl/certificate.key -subj "/" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$domains")) > conf/ssl/certificate.csr
	wget -qO - https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py | python - --account-key conf/ssl/account.key --csr conf/ssl/certificate.csr --acme-dir /var/www/html/.well-known/acme-challenge/ > conf/ssl/certificate.crt
	pkill nginx
	sed -ri "s/#(ssl_certificate.*;)/\1/; s/#(listen 443 ssl http2;)/\1/" conf/nginx.conf
	sed -i "$ s@}@\n\
	server {\n\
		server_name \"$1\";\n\
		listen 443 ssl http2;\n\
		add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains; preload\";\n\
		add_header X-Content-Type-Options nosniff;\n\
		root /var/www/html/cloveros.ga/;\n\
	}\n\
}@" conf/nginx.conf
	mkdir /var/www/html/cloveros.ga/
	sleep 1
	nginx/objs/nginx -p $(pwd)/conf/ -c nginx.conf
fi

while :; do
	if ! pidof nginx; then
		nginx/objs/nginx -p $(pwd)/conf/ -c nginx.conf
	fi
	if [ $(($(date +%s -d "$(openssl x509 -enddate -noout -in conf/ssl/certificate.crt | sed s/notAfter=//)") - $(date +%s))) -lt "2592000" ]; then
		openssl req -new -sha256 -key conf/ssl/certificate.key -subj "/" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$domains")) > conf/ssl/certificate.csr
		wget -qO - https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py | python - --account-key conf/ssl/account.key --csr conf/ssl/certificate.csr --acme-dir /var/www/html/.well-known/acme-challenge/ > conf/ssl/certificate.crt
		nginx/objs/nginx -p $(pwd)/conf/ -c nginx.conf -s reload
	fi
	rsync -a --delete rsync://nl.cloveros.ga/cloveros /var/www/html/cloveros.ga/;
	sleep 600
done
}

nginxconfigtemplatefn() {
	local config='
user www-data;
worker_processes auto;

events {
	worker_connections 8096;
	use epoll;
	multi_accept on;
}

http {
	default_type application/octet-stream;
	include mime.types;
	client_max_body_size 9999m;
	charset utf-8;
	index index.php index.html index.htm;
	autoindex off;
	autoindex_exact_size off;
	if_modified_since before;
	server_tokens off;
	access_log off;

	ssl_certificate ssl/certificate.crt;
	ssl_certificate_key ssl/certificate.key;
	ssl_dhparam dhparam.pem;
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA;
	ssl_ecdh_curve secp384r1;
	ssl_session_timeout 10m;
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off;
	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 128.52.130.209 52.174.55.168 valid=300s;
	resolver_timeout 5s;
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
	add_header X-Content-Type-Options nosniff;

	sendfile on;
	aio threads;
	directio 512;
	tcp_nopush on;
	tcp_nodelay on;

	ssl_buffer_size 4k;
	keepalive_timeout 65;
	keepalive_requests 100000;
	client_body_buffer_size 128k;
	client_header_buffer_size 1k;
	large_client_header_buffers  4 4k;
	output_buffers 1 32k;
	postpone_output 0;

	brotli on;
	brotli_types text/richtext text/plain text/css text/x-script text/x-component text/x-java-source application/javascript application/x-javascript text/javascript text/js image/x-icon application/x-perl application/x-httpd-cgi text/xml application/xml application/xml+rss application/json multipart/bag multipart/mixed application/xhtml+xml font/ttf font/otf font/x-woff image/svg+xml application/vnd.ms-fontobject application/ttf application/x-ttf application/otf application/x-otf application/truetype application/opentype application/x-opentype application/woff application/eot application/font application/font-woff application/font-sfnt application/atom+xml application/rss+xml application/x-font-ttf application/x-web-app-manifest+json font/opentype image/bmp;
	gzip on;
	gzip_proxied any;
	gzip_types text/richtext text/plain text/css text/x-script text/x-component text/x-java-source application/javascript application/x-javascript text/javascript text/js image/x-icon application/x-perl application/x-httpd-cgi text/xml application/xml application/xml+rss application/json multipart/bag multipart/mixed application/xhtml+xml font/ttf font/otf font/x-woff image/svg+xml application/vnd.ms-fontobject application/ttf application/x-ttf application/otf application/x-otf application/truetype application/opentype application/x-opentype application/woff application/eot application/font application/font-woff application/font-sfnt application/atom+xml application/rss+xml application/x-font-ttf application/x-web-app-manifest+json font/opentype image/bmp;

#	open_file_cache inactive=5s max=1000;
#	open_file_cache_valid 5s;

#	fastcgi_cache_path /dev/shm/phpcache levels=1:2 keys_zone=phpcache:100m;
#	fastcgi_cache_key "$scheme$request_method$host$request_uri";

#	limit_conn_zone $binary_remote_addr zone=addr:10m;

	server {
		location /.well-known/acme-challenge/ {
			root /var/www/html/;
		}
		location / {
			return 301 https://$host$request_uri;
		}
	}

	server {
		listen 443 ssl http2;
		root /var/www/html/;
		add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
		add_header X-Content-Type-Options nosniff;
	}
}
'
	config="${config:1}"
	config="${config%?}"
	echo "$config"
}

main $@
