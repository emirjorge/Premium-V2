#!/bin/bash
 #15/09/2023 by @EmirJorge
 clear
 clear
SCPdir="/etc/VPS-MX"
SCPfrm="${SCPdir}/herramientas" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="${SCPdir}/protocolos"&& [[ ! -d ${SCPinst} ]] && exit

download_udpServer(){
	clear

	if [[ -e /usr/bin/udpServer ]]; then
	clear
	msg -bar
	msg -verd "	SERVICIO UDPSERVER YA ACTIVO"
	msg -bar
	else
	msg -bar
	msg -verd "        Descargando binario UDPserver ----"
	sleep 1
	wget -O /usr/bin/udpServer https://bitbucket.org/iopmx/udprequestserver/downloads/udpServer &>/dev/null
		chmod +x /usr/bin/udpServer
		sleep 1s
   ip_nat=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n 1p)
	interfas=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}'|grep "$ip_nat"|awk {'print $NF'})
	ip_publica=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<< "$(wget -T 10 -t 1 -4qO- "http://ip1.dynupdate.no-ip.com/" || curl -m 10 -4Ls "http://ip1.dynupdate.no-ip.com/")")

	
	msg -ama "        Ejecutando servicio UDPserver ....."
	if screen -dmS UDPserver /usr/bin/udpServer -ip=$ip_publica -net=$interfas -mode=system &>/dev/null ; then
	[[ $(grep -wc "UDPserver" /etc/autostart) = '0' ]] && {
		    echo -e "ps x | grep 'UDPserver' | grep -v 'grep' || screen -dmS UDPserver /usr/bin/udpServer -ip=$ip_publica -net=$interfas -mode=system" >> /etc/autostart
		} || {
		    sed -i '/UDPcustom/d' /etc/autostart
		    echo -e "ps x | grep 'UDPserver' | grep -v 'grep' || screen -dmS UDPserver /usr/bin/udpServer -ip=$ip_publica -net=$interfas -mode=system" >> /etc/autostart
		}
		msg -verd " SERVICIO INSTALADO"
	else
		msg -verm2 " SERVICIO NO INSTALADO"
	fi
	fi
}

  reset_udp(){
  clear
  msg -bar
  msg -ama "        Reiniciando UDPserver...."
  screen -ls | grep UDPserver | cut -d. -f1 | awk '{print $1}' | xargs kill
  if screen -dmS UDPserver /usr/bin/udpServer -ip=$ip_publica -net=$interfas -mode=system ;then
  msg -verd "        Con exito!!!"    
  msg -bar
  else    
  msg -verm "        Con fallo!!!"    
  msg -bar
  fi
 
  }  
  
  stop_udp(){
  clear
  msg -bar
  msg -ama "        Deteniendo UDPserver...."
  msg -bar
  screen -r -S "UDPserver" -X quit
        screen -wipe 1>/dev/null 2>/dev/null
        [[ $(grep -wc "UDPserver" /etc/autostart) != '0' ]] && {
		    sed -i '/UDPserver/d' /etc/autostart
		}
  msg -verd "         Detenido Con exito!!!"   
  }    
  
  remove() {
  stop_udp
  rm -f /usr/bin/udpServer*
  rm -rf /etc/servs
  }
  
  clear
  [[ $(ps x | grep udpServer| grep -v grep) ]] && uds="\033[1;32m[ON]" || uds="\033[1;31m[OFF]"
  msg -tit
  
  msg -verd "         BINARIO OFICIAL DE NewToolWorks"
  msg -bar
  msg -ama "\e[93m         INSTALADOR UDPserver |\e[91m@EmirJorge| @PremiumVPS"
  echo -e "         \e[97mSolo Funciona en Ubuntu 20+"
  msg -bar
  echo -e "  \e[1;93m [\e[1;32m1\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -azu "Instalar UDPserver $uds")  "
  echo -e "  \e[1;93m [\e[1;32m2\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -azu " Reiniciar UDPserver")  " 
  echo -e "  \e[1;93m [\e[1;32m3\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -verm " \e[91mDetener UDPserver")  " 
  echo -e "  \e[1;93m [\e[1;32m4\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -verm " \e[91mRemover UDPserver")  "
  echo -e "  \e[1;93m [\e[1;32m5\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -verm " \e[92mActualizar Script UDPserver")  "
  echo -e "  \e[1;93m [\e[1;32m0\e[1;93m]\033[1;31m $(msg -verm2 "➛ ")$(msg -azu " VOLVER")  "
  msg -bar
  echo -ne " ►\e[1;37m Selecione una opcion: \e[33m"
	read opc
  case $opc in
  1)download_udpServer;;
  2)reset_udp;;
  3)stop_udp;;
  4)remove;;
  5) wget -O /etc/VPS-MX/protocolos/UDPserver.sh https://raw.githubusercontent.com/emirjorge/Premium-V2/master/update/UDPserver.sh &>/dev/null && chmod 777 /etc/VPS-MX/protocolos/UDPserver.sh && msg -verd "	UDPserver ACTUALIZADO" ;;
  0);;
  esac  
