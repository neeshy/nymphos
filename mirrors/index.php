<?php
chdir(__DIR__);
$git = 'https://gitgud.io/cloveros/cloveros/raw/master';
$isoname = basename(glob('/usr/portage/packages/s/CloverOS-x86_64-*.iso')[0]);
$libreisoname = basename(glob('/usr/portage/packages/s/CloverOS_Libre-x86_64-*.iso')[0]);

$packageuse = file_get_contents('../binhost_settings/etc/portage/package.use');
$packageenv = file_get_contents('../binhost_settings/etc/portage/package.env');
$packagekeywords = file_get_contents('../binhost_settings/etc/portage/package.keywords');
$makeconf = file_get_contents('../binhost_settings/etc/portage/make.conf');
$worldtxt = file_get_contents('../binhost_settings/var/lib/portage/world');
$installscriptsh = file_get_contents('../installscript.sh');
$usermake = file_get_contents('../home/user/make.conf');
$quickpkg = file_get_contents('/usr/portage/packages/s/quickpkg.html');
$quickpkg = substr($quickpkg, strpos($quickpkg, '<pre class="ansi2html-content">')+strlen('<pre class="ansi2html-content">')+1);
$quickpkg = rtrim($quickpkg, "</pre></body>\n</html>");
$packagecount = count(glob('/var/db/pkg/*/*'));

$mirrors = substr($usermake, strpos($usermake, 'binhost_mirrors="$PORTAGE_BINHOST,') + 34);
$mirrors = substr($mirrors, 0, strpos($mirrors, ',"'));
$mirrors = explode(',', $mirrors);
$mirrorlinks = '';
foreach ($mirrors as $line) {
	$mirrorlinks .= '<a target="_blank" href="'.$line.'">'.$line.'</a> ';
}

$dir = '/usr/portage/packages/';
$files = '<h1>Index of /</h1><hr><pre>';
foreach (scandir($dir) as $line) {
	if ($line == '.') {
		continue;
	}
	if (is_dir($dir.$line)) {
		$line = $line.'/';
	}
	$files .= '<a href="'.$line.'">'.str_pad($line.'</a>', 55).gmdate('d-M-Y H:i', filemtime($dir.$line)).'       -'."\n";
}
$files .= '</pre><hr>';

echo '<!DOCTYPE html>
<html>
<link rel="icon" href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEXKbt4AmQAAzAArTnekAAAAAXRSTlMAQObYZgAAADdJREFUeAFjYGARYGBgEA0BEqGhUIJLNGQBg1Zr0AqGVQu9VjFordBaASIgXLAEWAlcB8QAsFEAnzYQ4QKPcGQAAAAASUVORK5CYII=" type="image/x-ico" />
<title>CloverOS GNU/Linux</title>
<style>
	body { color: black; background: white; }
	a { text-decoration: none; }
	a:visited { color: blue; }
	.mono { font-family: monospace; }
	.pre { white-space: pre; }
	.fileinfo { height: 150px; width: 550px; margin: 0; overflow: auto; resize: both; border: 1px solid black; }
	.ansi1 { font-weight: bold; }
	.ansi32 { color: #00aa00; }
	.ansi34 { color: #0000aa; }
</style>
CloverOS GNU/Linux
<br><br>
Git: <a target="_blank" href="https://gitgud.io/cloveros/cloveros">https://gitgud.io/cloveros/cloveros</a><br>
ISO: <a href="s/'.$isoname.'">https://cloveros.ga/s/'.$isoname.'</a><br>
Libre ISO: <a href="s/'.$libreisoname.'">https://cloveros.ga/s/'.$libreisoname.'</a><br>
GPG: <a target="_blank" href="s/cloveros.gpg">78F5 AC55 A120 07F2 2DF9  A28A 78B9 3F76 B8E4 2805</a><br>
IRC: <a target="_blank" href="irc://irc.rizon.net/cloveros">#cloveros</a> on irc.rizon.net<br>
Twitter: <a target="_blank" href="https://twitter.com/cloveros_ga">https://twitter.com/cloveros_ga</a><br>
Rsync: rsync://nl.cloveros.ga/cloveros<br>
License: WTFPL<br>
Mirrors: '.$mirrorlinks.'<br>
Packages: <a target="_blank" href="s/packages.html">'.$packagecount.' https://cloveros.ga/s/packages.html</a><br>
CFLAGS: <span class="mono">CFLAGS="-Ofast -mssse3 -mfpmath=both -pipe -funroll-loops -flto=8 -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -mtls-dialect=gnu2 -Wl,--hash-style=gnu"</span><br>
USE flags: <span class="mono">USE="-systemd -pulseaudio -avahi -dbus -consolekit -libnotify -udisks -zeroconf -nls -doc -gnome-keyring -gstreamer -libav -openal -kde -gnome -openssl libressl bindist ipv6 cli jpeg gif png otr minimal offensive zsh-completion custom-cflags custom-optimization threads aio jit fftw lto graphite pgo numa alsa joystick xinerama wayland egl dga dri dri3 vulkan opengl opencl glamor vaapi vdpau system-ffmpeg system-icu system-libvpx system-harfbuzz system-jpeg system-libevent system-sqlite system-cairo system-compress system-images system-nss system-pixman system-vpx system-llvm system-lua system-cmark system-libyaml system-lcms system-lz4 system-uulib system-snappy system-jsoncpp system-binutils system-clang system-tbb system-renpy system-libs system-heimdal system-leveldb system-libmspack system-zlib system-av1"</span><br>
DL & Validate ISO: <span class="mono pre">gpg --keyserver hkp://pool.sks-keyservers.net --recv-key "78F5 AC55 A120 07F2 2DF9 A28A 78B9 3F76 B8E4 2805"
wget https://cloveros.ga/s/'.$isoname.' https://cloveros.ga/s/signatures/s/'.$isoname.'.asc
gpg --verify '.$isoname.'.asc '.$isoname.'</span>
<br><br>
<a target="_blank" href="'.$git.'/installscript.sh">CloverOS install script</a>
<div class="mono pre fileinfo">'.$installscriptsh.'</div>
<br>
<a target="_blank" href="s/quickpkg.html"><span class="mono">$ sudo quickpkg --include-unmodified-config=y "*/*"</div></a>
<div class="mono pre fileinfo">'.$quickpkg.'</div>
<br>
<a href="'.$git.'/binhost_settings/etc/portage/make.conf" target="_blank">/etc/portage/make.conf</a>
<div class="mono pre fileinfo">'.$makeconf.'</div>
<br>
<a href="'.$git.'/binhost_settings/etc/portage/package.use" target="_blank">/etc/portage/package.use</a>
<div class="mono pre fileinfo">'.$packageuse.'</div>
<br>
<a href="'.$git.'/binhost_settings/etc/portage/package.env" target="_blank">/etc/portage/package.env</a>
<div class="mono pre fileinfo">'.$packageenv.'</div>
<br>
<a href="'.$git.'/binhost_settings/var/lib/portage/world" target="_blank">/var/lib/portage/world</a>
<div class="mono pre fileinfo">'.$worldtxt.'</div>
'.$files.'
</html>';
