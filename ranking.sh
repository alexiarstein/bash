#!/bin/bash

histfile="$HOME/.bash_history"

if [ -n "$1" ]; then
    cant="$1"

if [ -f "$histfile" ]; then
	cmdrank=$(awk '{print $1}' "$histfile" | sort | uniq -c | sort -nr | head -n $cant) 
echo "Mis $cant comandos mas utilizados:"
echo "$cmdrank"

else

echo "No logro encontrar el bash_history"

fi

else
	echo "Necesitas poner el numero de rankings que queres mostrar, ej bash ranking.sh 3 mostrara los primeros 3 comandos mas utilizados"
fi

