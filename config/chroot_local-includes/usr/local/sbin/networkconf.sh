#!/bin/sh

	
MY_INTERFACES="/etc/network/interfaces";
MY_RESOLV_CONF="/etc/resolv.conf";
MY_DHCP=off;
MY_ERROR() {
	echo "$1\n";
	echo "Wir fangen nochmal von vorne an.\n";
	MY_GET_CHOICE;
}

MY_READ_SETTINGS() {
	echo  "IP Adresse? (Bsp. 192.168.100.1)"
	read MY_IP;
	test $(expr length "$MY_IP") -gt 6 || MY_ERROR "\nIP ist zu kurz.";
	echo  "Netzmaske? (Bsp. 255.255.255.0)\n"
	read MY_NETMASK;
	test $(expr length "$MY_NETMASK") -gt 6 || MY_ERROR "\nNetzmaske ist zu kurz.";
	echo  "Gateway? (Bsp. 192.168.100.254)\n"
	read MY_GATEWAY;
	echo  "Nameserver? (Bsp. 192.168.100.254)\n"
	read MY_NAMESERVER;
	
}
MY_GET_CHOICE() {
	echo  "\n\nNetzwerk Konfiguration\n\nSoll DHCP (d) oder eine feste IP (s) verwendet werden?\n\n"
	
	read n;
	
	case $n in 
		d|D)
			MY_DHCP=on;
		;;
		s|S)
			MY_READ_SETTINGS;
		;;
		*)
		echo "Ich konnte Sie nicht verstehen. Wir fangen nochmal an.\n";
		MY_GET_CHOICE;
		;;
	esac
}

MY_WRITE_INTERFACES() {
	echo "$MY_INTERFACES wird geschrieben\n";
	case $MY_DHCP in
		on)
			echo "auto lo\niface lo inet loopback" > $MY_INTERFACES;
			echo "auto eth0\niface eth0 inet dhcp\n" >> $MY_INTERFACES;
		;;
		*)
			echo "auto lo\niface lo inet loopback" > $MY_INTERFACES;
			echo "auto eth0\niface eth0 inet static\n" >> $MY_INTERFACES;
			echo "address $MYIP\nnetmask $MY_NETMASK\n" >> $MY_INTERFACES;
			test $(expr length "$MY_GATEWAY") -gt 6 && \
			echo "gateway $MY_GATEWAY" >> $MY_INTERFACES;
		;;
	esac
}

MY_RESOLV() {
	test $(expr length "$MY_NAMESERVER") -gt 6 || return;
	echo "Schreibe $MY_RESOLV_CONF.\n";
	echo "nameserver $MY_NAMESERVER" > $MY_RESOLV_CONF
}

MY_NETWORK_STOP() {

	echo "Halte Netzwerk an.\n";
	/etc/init.d/networking stop || MY_FEHLER "Netzwerk konnte nicht angehalten werden.\n";
}

MY_NETWORK_START() {

	echo "Starte Netzwerk.\n";
	/etc/init.d/networking stop || MY_FEHLER "Netzwerk konnte nicht gestartet werden.\n";
}


MY_GET_CHOICE;
MY_NETWORK_STOP;
MY_WRITE_INTERFACES;
MY_RESOLV;
MY_NETWORK_START;

