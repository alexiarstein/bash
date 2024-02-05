#!/bin/bash

histfile="$HOME/.bash_history"
cant="$1"
if [ -f "$histfile" ]; then
	cmdrank=$(awk '{print $1}' "$histfile" | sort | uniq -c | sort -nr | head -n $cant) 
echo "Mis $cant comandos mas utilizados:"
echo "$cmdrank"

else

echo "No logro encontrar el bash_history"

fi


