#!/bin/sh

. /usr/local/sbin/colours.sh
clear;	
MY_INTERFACES="/etc/network/interfaces";
MY_RESOLV_CONF="/etc/resolv.conf";
MY_DHCP=off;
MY_MARKER() {
	echo "#############################\n";
}

MY_ERROR() {
	echo "$1\n";
	RED;
	echo "Wir fangen nochmal von vorne an.\n";
	NC;
	MY_GET_CHOICE;
}

MY_READ_SETTINGS() {
	BLUE;
	echo  "\nIP Adresse? (Bsp. 192.168.100.1)"
	NC;
	read MY_IP;
	test $(expr length "$MY_IP") -gt 6 || MY_ERROR "\nIP ist zu kurz.";
	BLUE;
	echo  "\nNetzmaske? (Bsp. 255.255.255.0)\n"
	NC;
	read MY_NETMASK;
	test $(expr length "$MY_NETMASK") -gt 6 || MY_ERROR "\nNetzmaske ist zu kurz.";
	BLUE;
	echo  "\nGateway? (Bsp. 192.168.100.254)\n"
	NC;
	read MY_GATEWAY;
	BLUE;
	echo  "\nNameserver? (Bsp. 192.168.100.254)\n"
	NC
	read MY_NAMESERVER;
	
}
MY_GET_CHOICE() {
	PURPLE;
	echo  "\n\nNetzwerk Konfiguration\n\n"
	BLUE;
	echo "Soll DHCP (d) oder eine feste IP (s) verwendet werden?\n\n"
	NC;
	read n;
	
	case $n in 
		d|D)
			MY_DHCP=on;
		;;
		s|S)
			MY_READ_SETTINGS;
		;;
		*)
		echo "\nIch konnte Sie nicht verstehen. Wir fangen nochmal an.\n";
		MY_GET_CHOICE;
		;;
	esac
}

MY_WRITE_INTERFACES() {
	CYAN;
	echo "\n$MY_INTERFACES wird geschrieben\n";
	NC;
	case $MY_DHCP in
		on)
			echo "auto lo\niface lo inet loopback" > $MY_INTERFACES;
			echo "auto eth0\niface eth0 inet dhcp\n" >> $MY_INTERFACES;
		;;
		*)
			echo "auto lo\niface lo inet loopback" > $MY_INTERFACES;
			echo "auto eth0\niface eth0 inet static\n" >> $MY_INTERFACES;
			echo "address $MY_IP\nnetmask $MY_NETMASK\n" >> $MY_INTERFACES;
			test $(expr length "$MY_GATEWAY") -gt 6 && \
			echo "gateway $MY_GATEWAY" >> $MY_INTERFACES;
		;;
	esac
}

MY_RESOLV() {
	test $(expr length "$MY_NAMESERVER") -gt 6 || return;
	CYAN;
	echo "\nSchreibe $MY_RESOLV_CONF.\n";
	NC;
	echo "nameserver $MY_NAMESERVER" > $MY_RESOLV_CONF
}

MY_NETWORK_STOP() {
	CYAN;
	echo "\nHalte Netzwerk an.\n";
	NC;
	/etc/init.d/networking stop || MY_FEHLER "Netzwerk konnte nicht angehalten werden.\n";
}

MY_NETWORK_START() {
	CYAN;
	echo "\nStarte Netzwerk.\n";
	NC;
	/etc/init.d/networking start || MY_FEHLER "Netzwerk konnte nicht gestartet werden.\n";
}

MY_END() {
	GREEN;
	echo "\nNetzwerkkonfiguration abgeschlossen.\nDruecken Sie ENTER, um fort zu fahren.\n"
	read e;
}

MY_GET_CHOICE;
MY_MARKER;
MY_NETWORK_STOP;
MY_WRITE_INTERFACES;
MY_RESOLV;
MY_NETWORK_START;
MY_MARKER;
MY_END;
