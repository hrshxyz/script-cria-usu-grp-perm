#!/bin/bash

# Verifica se o script está sendo executando com o usuário root.
if [[ $(id -u) -ne 0 ]] ; then
	echo -e "\n -- Por favor rode o script como root. -- "
	echo -e " ==> Exemplo: sudo ./$(basename $0)\n"
	exit 1
fi

# Diretórios que serão criados.
DIRRAIZ="/"
DIR="adm ven sec"
DIRPUBLICO="publico"

# Dono de todos diretórios
DONO="root"

# Usuários por grupo
USUARIOS_ADM="carlos maria joao"
USUARIOS_VEN="debora sebastiana roberto"
USUARIOS_SEC="josefina amanda rogerio"

# Senha padrão
SENHAPADRAO="Senha123"

# Permissões Dono, Grupo e Outros
PERMTOTAL="777"
PERMDG="770"

# Grupos 
GRP="GRP_"

echo " -- Criando Grupos de trabalho -- "

# Cria Grupos no S.O
for GRUPO in $DIR; do
	echo "Criando Grupo ${GRP}${GRUPO^^}"
        groupadd "${GRP}${GRUPO^^}"
done
echo -e "\n"

echo " -- Criando diretórios de trabalho -- "

# Loop para cria o diretórios publico e com permissão 777.
for DIRETORIO in $DIRPUBLICO; do
	echo " -- Criando Grupo ${DIRRAIZ}${DIRETORIO} com persmissão 777 -- "
        mkdir -v -m ${PERMTOTAL} ${DIRRAIZ}${DIRETORIO}
done
echo -e "\n"

# Loop para criar os diretórios conforme a lista na variavel DIR.
for DIRETORIO in $DIR; do
        echo " -- Criando Grupo ${DIRRAIZ}${DIRETORIO} -- "
	mkdir -v -m ${PERMDG} ${DIRRAIZ}${DIRETORIO}
done
echo -e "\n"

# Loop definir o dono de todos diretórios.
for DIRETORIO in $DIR; do
        echo " -- Ajustando dono e group dos diretórios ${DIRRAIZ}${DIRETORIO} => ${DONO}:${GRP}${DIRETORIO^^} -- "
        chown ${DONO}:${GRP}${DIRETORIO^^} ${DIRRAIZ}${DIRETORIO}
done
echo -e "\n"

# Criando usuário e adicionando no grupo suplementar.
echo " -- Criando usuários -- "

for GRUPO in $DIR; do
	VARUSU="USUARIOS_${GRUPO^^}"
	VARGRP="${GRP}${GRUPO^^}"
	eval "VARUSU=\$${VARUSU}"
	for USUARIO in ${VARUSU}; do
	        echo " -- Criando usuario ${USUARIO} e adicionando grupo suplementar ${VARGRP} -- "
		useradd ${USUARIO} -c "${USUARIO}" -G ${VARGRP} -s /bin/bash -m -p $(openssl passwd -6 ${SENHAPADRAO})
		echo " -- Ajustando expiração da senha do ${USUARIO}, para que seja trocado no próximo login -- "
                passwd ${USUARIO} -e
	done
done
echo -e "\n -- Finalizando criação de usuários, diretórios e permissões! -- "
