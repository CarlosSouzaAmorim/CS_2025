#!/bin/bash

#sudo apt install wbrazilian
# Gerar nomes aleatórios e ordenar
( 
    for i in {1..1000}; do 
        primeiro_nome=$(shuf -n 1 /usr/share/dict/brazilian | grep -E '^[A-Za-z]{4,}$' | sed 's/.*/\u&/'); 
        sobrenome=$(shuf -n 1 /usr/share/dict/brazilian | grep -E '^[A-Za-z]{4,}$' | sed 's/.*/\u&/'); 
        echo "$primeiro_nome $sobrenome"; 
    done 
) | sort -u | head -n 1000 > nomes_ficticios.txt