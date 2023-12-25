#!/bin/bash
#
# A ver que se les ocurre.
# Sientanse libres de mejorarlo, repensarlo y hacer un PR :3

wget --quiet -O /tmp/tmp.subte https://www.enelsubte.com/estado/
grep  "estado-subtes-pastilla" /tmp/tmp.subte | awk -F '>' '{print $2}' | tr '</div' ' ' > /tmp/tmp.letras
grep -m7 "estado-subtes-estado" /tmp/tmp.subte | awk -F '>' '{print $2}' | sed "s/<\/div//g" > /tmp/tmp.estados

verde=$(tput setaf 02)
rojo=$(tput setaf 01)
naranja=$(tput setaf 03)
azul=$(tput setaf 04)
violeta=$(tput setaf 05)
celeste=$(tput setaf 06)
amarillo=$(tput setaf 11)
reset=$(tput init)
declare -A colorcitos=(
["A"]="${celeste}Linea A  ${reset}  "
["B"]="${rojo}Linea B  ${reset}  "
["C"]="${azul}Linea C  ${reset}  "
["D"]="${verde}Linea D  ${reset}  "
["E"]="${violeta}Linea E  ${reset}  "
["H"]="${amarillo}Linea H ${reset}  "
["P"]="${naranja}Premetro   ${reset}  "
)
declare -A tradu=(
["Partly cloudy"]="Parcialmente Nublado"
["Mostly clear"]="Cielo Despejado"
)

while read i; do echo ${colorcitos[$i]}; done < /tmp/tmp.letras  > /tmp/tmp.letras2
echo -e "\nEstado de la red de subterraneos de Buenos Aires\n" > /tmp/tmp.subtes
paste /tmp/tmp.letras2 /tmp/tmp.estados >> /tmp/tmp.subtes
cat /tmp/tmp.subtes

wget --quiet -O /tmp/tmp.clima https://clima.com/argentina/buenos-aires/buenos-aires
temp=$(grep currentTemperature /tmp/tmp.clima | awk -F ':' '{print $2}' | sed "s/[',]//g")
estado=$(grep weatherForecast /tmp/tmp.clima | awk -F ':' '{print $2}' | sed "s/[',]//g")
echo -e "\nTemperatura Actual:        ${celeste} $temp (${tradu[$estado]}) ${reset}" 

wget --quiet -O /tmp/tmp.dolar https://dolarhoy.com/i/cotizaciones/dolar-blue
dolarBlue=$(grep -Po '<div class="data__valores"><p>\K\d+(\.\d+)?(?=<span>)' /tmp/tmp.dolar)
echo -e "Valor del Dolar Blue Hoy:  ${verde} \$${dolarBlue}${reset}\n" 
rm /tmp/tmp.*
