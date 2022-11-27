#!/bin/bash
fecha=`date`;
	#servicio test
	#stunnel4
	servicio stunnel4 start &>/dev/null
	servicio stunnel4 restart &>/dev/null
	systemctl start stunnel4 &>/dev/null
	systemctl restart stunnel4 &>/dev/null
	/etc/init.d/stunnel4 &>/dev/null

	#stunnel
	#servicio stunnel start &>/dev/null
	#servicio stunnel restart &>/dev/null
	#systemctl start stunnel &>/dev/null
	#systemctl restart stunnel &>/dev/null
	
	echo "$fecha - Auto-inicio stunnel" >> $HOME/aut-stunnel.log 
	#fin
	