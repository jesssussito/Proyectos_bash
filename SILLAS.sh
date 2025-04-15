#!/bin/bash
//FALLA LA COMPROBACION DE SI CONFIG TIENE PERMISOS Y QUE LOG ES UN FICHERO NO UNA RUTA
if test -e config.cfg
then
	if test $# -gt 1
	then
		echo "Excedes los parametros."
		echo "Modo de empleo del programa: sillas.sh [-g]"
		echo "*Los corchetes indican que el argumento -g es opcional."
		exit
	elif test $# -eq 1 && test "$1" = "-g"
	then
		echo "Alumnos Participantes:" 
		echo "• Jesús Chapa Valiente     (PA2)"
		echo "• Jaime González Domínguez (PA2)"
		echo ""
		echo "El campo ADEFINIR nos indica el TIEMPO TOTAL que ha pasado jugando cada JUGADOR."
		exit
	elif test $# -eq 1 && test "$1" != "-g"
	then
		echo "Argumento incorrecto."
		echo "Modo de empleo del programa: sillas.sh [-g]"
		echo "*Los corchetes indican que el argumento -g es opcional."
		exit
	else
		CONTPARTIDAS=0
		nombres=("ANA" "JUAN" "PABLO" "LUIS" "CARMEN" "ELENA" "DORI" "BLAS" "ZOE" "FRAN")
		jugando=()
		while test $caso!="S"
		do
			echo "|--------------------------------------------------|"
    		echo "|               JUEGO DE LAS SILLAS                |"
    		echo "|--------------------------------------------------|"
    		echo "|                  C) CONFIGURACIÓN                |"
    		echo "|                  J) JUGAR                        |"
    		echo "|                  E) ESTADISTICAS                 |"
    		echo "|                  S) SALIR                        |"
    		echo "|--------------------------------------------------|"
    		echo "|       Introduzca una opcion                      |"
			echo "|--------------------------------------------------|"
		
			read caso
			case $caso in 
				C|c) 
					cambio=a
					echo "|--------------------------------------------------|"
					echo "|------------------CONFIGURACIÓN-------------------|"
					echo "|--------------------------------------------------|"
					RUTA=$(pwd)

					source config.cfg

					VALIDOS=0

					#Explicación de ordenes no vistas en clase:
    				#Este if se asegura de que el valor de la variable introducida
    				#sea un valor numérico.
					#Para ello utiliza "=~" para comparar la variable con una expresión regular
					#que con "^" y "$" para marca el inicio y el final de una cadena que 
					#contiene 1 o mas digitos entre 1 y 9 ("[0-9]+").
					if [[ "$JUGADORES" =~ ^[0-9]+$ ]]
					then
						if test "$JUGADORES" -ge 2 && test "$JUGADORES" -le 10
						then
							echo "Hay $JUGADORES jugadores."
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de JUGADORES no válido."
						fi
					else
						echo "Tu fichero config.cfg tiene un valor de JUGADORES no válido."
					fi

					if [[ "$TIEMPO" =~ ^[0-9]+$ ]]
					then
						if test "$TIEMPO" -ge 0 && test "$TIEMPO" -le 10
						then
							echo "Hay $TIEMPO segundos hasta que se pare la música."
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de TIEMPOO no válido."
						fi
					else
						if test "$TIEMPO" = "i" || test "$TIEMPO" = "v"
						then
							if test "$TIEMPO" = "v"
							then
								echo "El tiempo está a velocidad máxima ($TIEMPO)."
							elif test "$TIEMPO" = "i" 
							then
								echo "La música se parará cuando se indique de manera interactiva ($TIEMPO)."
							fi
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de TIEMPO no válido."
						fi
					fi

					if test -f $LOG && test -r $LOG && test -w $LOG
					then
						echo "La ruta del fichero log es $LOG."
						((VALIDOS = $VALIDOS + 1))
					else
						echo "Tu fichero config.cfg tiene una ruta no válida para el fichero log."
					fi

					if test $VALIDOS -lt 3
					then
						echo "Alguno de los valores del fichero config.cfg no son válidos,"
						echo "desea modificarlos? Si no lo hace el juego no podrá ejecutarse. [s/n]"
						read cambio
					else
						echo "Desea cambiar algo? [s/n]"
						read cambio
					fi
					
					valor1=0
					valor2=0
					valor3=0
					while test $cambio != "n"
					do
					case $cambio in
						s)
							while test $valor1 -eq 0
							do
								echo "Cuántos jugadores quieres que haya? (2-10)"
								read JUGADORES

								if [[ "$JUGADORES" =~ ^[0-9]+$ ]]
								then
									if test "$JUGADORES" -ge 2 && test "$JUGADORES" -le 10
									then
										echo "Usted ha selecionado $JUGADORES Jugadores"
										echo ""
										valor1=1
									else
										echo "El número de jugadores tiene que estar entre 2 y 10."
										echo ""
									fi
								else
									echo "Debes introducir un número, no una cadena de caracteres."
									echo ""
								fi
							done
							while test $valor2 -eq 0
							do
								echo "Cuánto tiempo quieres que esté sonando la música?"
								echo "(número entre 0 y 10 / 'v'--> velocidad máxima / 'i'--> pausa interactiva)"
								read TIEMPO
								if [[ "$TIEMPO" =~ ^[0-9]+$ ]]
								then
									if test "$TIEMPO" -ge 0 && test "$TIEMPO" -le 10
									then
										echo "La musica sonará durante $TIEMPO segundos"
										valor2=1
									else
										echo "No valido, vuelva a introducir un tiempo:"
										echo ""
									fi
								else
									if test "$TIEMPO" = "i" || test "$TIEMPO" = "v"
									then
										if test "$TIEMPO" = "i"
										then
											echo "Usted ha selecionado tiempo iterativo"
											echo ""
											valor2=1
										else
											echo "Usted ha selecionado velocidad maxima"
											echo ""
											valor2=1
										fi
									else
										echo "No valido, vuelva a introducir un tiempo:"
										echo ""
									fi
								fi
							done
							while test $valor3 -eq 0
							do
								echo "Cual quiere que sea la ruta del fichero log"
								read LOG
								if test -f $LOG && test -r $LOG && test -w $LOG
								then
									echo "La ruta seleccionada es : $LOG"
									echo ""
									valor3=1
								else
									echo "La ruta que ha escrito no es válida,"
									echo "escriba una válida o comprueba que exista"
									echo "y que tenga los permisos necesarios."
									echo ""
								fi
							done
							{
								echo "JUGADORES=$JUGADORES"
								echo "TIEMPO=$TIEMPO"
								echo "LOG=$LOG"
							} > "$RUTA/config.cfg"
							
							cambio="n"
						;;
						n)
							echo ""
						;;
						*)
							echo "Desea cambiar algo? [s/n]"
							read cambio
						;;
					esac
				done
					;;
				J|j)
					echo "|--------------------------------------------------|"
					echo "|----------------------JUGAR-----------------------|"
					echo "|--------------------------------------------------|"
					
					#Utilizo "source" para leer los datos del fichero config.cfg
					source config.cfg

					VALIDOS=0
					if [[ "$JUGADORES" =~ ^[0-9]+$ ]]
					then
						if test "$JUGADORES" -ge 2 && test "$JUGADORES" -le 10
						then
							echo "Hay $JUGADORES jugadores."
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de JUGADORES no válido."
						fi
					else
						echo "Tu fichero config.cfg tiene un valor de JUGADORES no válido."
					fi

					if [[ "$TIEMPO" =~ ^[0-9]+$ ]]
					then
						if test "$TIEMPO" -ge 0 && test "$TIEMPO" -le 10
						then
							echo "Hay $TIEMPO segundos hasta que se pare la música."
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de TIEMPO no válido"
						fi
					else
						if test "$TIEMPO" = "i" || test "$TIEMPO" = "v"
						then
							if test "$TIEMPO" = "v"
							then
								echo "El tiempo está a velocidad máxima ($TIEMPO)."
							elif test "$TIEMPO" = "i" 
							then
								echo "La música se parará cuando se indique de manera interactiva ($TIEMPO)."
							fi
							((VALIDOS = $VALIDOS + 1))
						else
							echo "Tu fichero config.cfg tiene un valor de TIEMPOO no válido"
						fi
					fi

					if test -f $LOG && test -r $LOG && test -w $LOG
					then
						echo "La ruta del fichero log es $LOG."
						((VALIDOS = $VALIDOS + 1))
					else
						echo "Tu fichero config.cfg tiene una ruta no válida para el fichero log."
					fi

					if test $VALIDOS -lt 3
					then
						echo "Alguno de los valores del fichero config.cfg no son válidos."
						echo "Debe ir al apartado CONFIGURACIÓN para modificarlo."
					else

						for ((i=0;i<$JUGADORES;i++))
						do
							jugando[i]=${nombres[RANDOM % ${#nombres[*]}]}

								for ((j=0;j<$i;j++))
								do
									if test "${jugando[i]}" = "${jugando[j]}"
									then
											((i = $i - 1))
									fi
								done
						done

						echo Se han seleccionado los siguientes jugadores:
						echo "${jugando[*]}"
						echo ""
						POS=0
						SILLAS=$((JUGADORES - 1))
						salvados=()
						pos_ranking=()

						echo "Pulsa ENTER para que empieze a sonar la música..."
						read

						TIEMPO_INICIAL=$SECONDS

						while test ${#jugando[*]} -gt 1
						do
							if test "$TIEMPO" = "i"
							then
								echo "Pulsa ENTER cuando quieras que se pare la música ♫ ♪ ♩..."
								read
							elif test "$TIEMPO" != "v" 
							then
								for ((j=$TIEMPO;j>0;j--))
								do
									echo "El tiempo se acaba en $j"
									sleep 1
								done
							fi
							
							echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
							#BUCLE PRINCIPAL DEL JUEGO CON COMENTARIOS EXPLICATIVOS
							for ((k=0;k<$SILLAS;k++))
							do
								num_persona=$((RANDOM % ${#jugando[*]})) #Numero aleatorio entre 0 y tamaño del array jugando.
								POS=$((RANDOM % $SILLAS))				 #Numero aleatorio entre 0 y numero de sillas.

								#Se comprueba q no esté ocupada la posicion de la silla.
								while test -n "${salvados[POS]}"
								do
									POS=$((RANDOM % $SILLAS))
								done
								salvados[POS]=${jugando[$num_persona]}	 #Los jugadores que se encuentren en la posicion aleatoria
																		 #se van metiendo en un array de salvados.
								
								
								echo "SILLA : $(($POS + 1))"
								echo ""
								echo "................%@+......................................"
								echo "................%@+......................................"
								echo "................*@#......................................"
								echo "................%@+......................................"
								echo "................*@#......................................"
								echo "................+@%.....${jugando[num_persona]}.............................."
								echo "................:@@......................................"
								echo ".................@@@#***###%@@@@@@@@@@@@@@%.............."
								echo ".................*@@@@@@%%##*+=--:::....=@@.............."
								echo ".................=@@....................=@@.............."
								echo ".................-@@:...................=@@.............."
								echo ".................:@@:...................=@@.............."
								echo ".................:@@:...................=@@.............."
								echo ".................:@@:...................=@@.............."
								echo ".................-@@-:::::::::::::::::::+@@.............."
								echo ".................=@@++++++++++++++++++++#@@.............."
								echo "...............  %@*....................+@@.............."
								echo ""
								#ASCII ART obtenido de: (https://www.asciiart.eu/image-to-ascii)

								unset jugando[$num_persona]			#Se elimina el jugador salvado del array jugando para que
																	#no pueda volver a salir aleatoriamente

								#Se recoloca el array para que los jugadores salvados entren dentro del tamaño del array
								for ((j=0;j<${#jugando[*]};j++))
								do
									if test -z "${jugando[j]}"
									then
										jugando[j]=${jugando[j+1]}
										unset jugando[j+1]
									fi
								done
							done
							sleep 2
							echo "${jugando[0]} se ha quedado sin silla"
							echo "......"
							sleep 1
							echo "${jugando[0]} ha sido eliminado/a ☹"
							echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
							pos_ranking[${#salvados[*]}]=${jugando[0]}

							#El array de salvados de la ronda anterior pasa a ser el array de jugadores de la siguiente ronda
							#y se vacia el array de salvados.
							unset jugando #Por si acaso el jugador salvado estaba en la ultima posición

							for ((j=0;j<${#salvados[*]};j++))
							do
								jugando[j]=${salvados[j]}
							done 
							unset salvados
							((SILLAS = $SILLAS - 1))

							

							if test ${#jugando[*]} -ne 1
							then
								echo "Pulsa ENTER para que vuelva a sonar la música..."
								read
							else
								echo ""
								echo "FIN DE LA PARTIDA"
								echo "pulsa ENTER para ver el resultado de la partida..."
								read
							fi
						done

						pos_ranking[0]=${jugando[0]}
						echo "|---------Clasificación---------|"
						for ((i=0;i<${#pos_ranking[*]};i++))
						do
							echo "|$(($i + 1))º-----${pos_ranking[i]}|"
						done
						echo "|-------------------------------|"
						TIEMPO_FINAL=$SECONDS
						TIEMPO_TOTAL=$(($TIEMPO_FINAL - $TIEMPO_INICIAL))

						echo "Pulsa ENTER para volver al menú principal."
						read

						#VOLCADO DE INFORMACION AL LOG
						echo -n "$(date +"%d%m%y")|$(date +"%H:%M:%S")|" >> $LOG

						for ((i=0;i<${#nombres[*]};i++))
						do
							POSICION="-"
							for ((j=0;j<${#pos_ranking[*]};j++))
							do
								if test "${nombres[i]}" = "${pos_ranking[j]}"
								then
									POSICION="$((j+1))"
								fi
							done
							echo -n "$POSICION|" >> $LOG
						done

						echo "$TIEMPO_TOTAL|$JUGADORES|${pos_ranking[0]}" >> $LOG

						CONTPARTIDAS=$(($CONTPARTIDAS + 1))	
					
					fi

					;;
				E|e)
					echo "|---------------------------------------------------------|"
					echo "|----------------------ESTADISTICAS-----------------------|"
					echo "|---------------------------------------------------------|"
					#INICIALICACIÓN EN 0 DE LAS VARIABLES Y ARRAYS QUE SEA NECESARIO
					RUTA=$(pwd)
					CANT_PARTIDAS=0
					MEDIA=0
					CANT_JUGADORES=0

					for ((i=0;i<=8;i++))
					do
					    cantjugadores[i]=0  
					done

					for ((i=0;i<=9;i++))
					do
					    ganadas[i]=0
					    ultimo[i]=0
					    finalista[i]=0 
					    cantpartidasjugador[i]=0
					    canttiempojugador[i]=0
					done

					#porcentajecantjugadores=()
					#contadortiempos=()

					#BUCLE ENCARGADO DE LEER EL FICHERO LOG
					while read linea
					do	
					    #ARRAY DE DURACIÓN DE CADA PARTIDA
						contadortiempos[CANT_PARTIDAS]=$(echo $linea | cut -f 13 -d "|")

					    #VARIABLE CONTADORA DEL NUMERO DE PARTIDAS
					    if [[ "${contadortiempos[CANT_PARTIDAS]}" =~ ^[0-9]+$ ]]
					    then
					       CANT_PARTIDAS=$(($CANT_PARTIDAS + 1))
					    fi

					    #VARIABLE QUE ALMACENA LA CANTIDAD DE JUGADORES DE CADA PARTIDA
					    CANT_JUGADORES=$(echo $linea | cut -f 14 -d "|")
					    #ARRAY DE CANTIDAD DE PARTIDAS RESPECTO AL NUMERO DE JUGADORES
					    case $CANT_JUGADORES in 
					    2)
					        cantjugadores[0]=$((${cantjugadores[0]} + 1))
					        ;;
					    3)
					        cantjugadores[1]=$((${cantjugadores[1]} + 1))
					        ;;
					    4) 
					        cantjugadores[2]=$((${cantjugadores[2]} + 1))
					        ;;
					    5)
					        cantjugadores[3]=$((${cantjugadores[3]} + 1))
					        ;;
					    6)
					        cantjugadores[4]=$((${cantjugadores[4]} + 1))
					        ;;
					    7)
					        cantjugadores[5]=$((${cantjugadores[5]} + 1))
					        ;;
					    8)
					        cantjugadores[6]=$((${cantjugadores[6]} + 1))
					        ;;
					    9)
					        cantjugadores[7]=$((${cantjugadores[7]} + 1))
					        ;;
					    10)
					        cantjugadores[8]=$((${cantjugadores[8]} + 1))
					        ;;
					    esac

					    #ARRAYS PARA LAS ESTADISTICAS DE CADA JUGADOR (GANADAS, FINALISTA, ULTIMO)
					    for ((i=3;i<=12;i++))
					    do
					        POS=$(echo $linea | cut -f $i -d "|")
					        if [[ "$POS" =~ ^[0-9]+$ ]]
					        then
					            if test "$POS" -eq 1
					            then
					                ganadas[$(($i-3))]=$((${ganadas[$(($i-3))]} + 1))
					            fi
					            if test "$POS" -eq 2
					            then
					                finalista[$(($i-3))]=$((${finalista[$(($i-3))]} + 1))
					            fi
					            if test "$POS" -eq $CANT_JUGADORES
					            then
					                ultimo[$(($i-3))]=$((${ultimo[$(($i-3))]} + 1))
					            fi

					            cantpartidasjugador[$(($i-3))]=$((${cantpartidasjugador[$(($i-3))]} + 1))

					            canttiempojugador[$(($i-3))]=$((${canttiempojugador[$(($i-3))]} + $(echo $linea | cut -f 13 -d "|")))
					        fi

					    done

					done < "$RUTA/log/fichero.log"

					#ALGORITMO PARA 


					if test $CANT_PARTIDAS -ne 0 #Compruebo que la cantidad de partidas no sea 0
					then
					    #ARRAY DE PORCENTAJES DE PARTIDAS RESPECTO AL NUMERO DE JUGADORES
					    for ((i=0;i<=8;i++))
					    do
					        porcentajecantjugadores[i]=$(( (${cantjugadores[i]}*100) / $CANT_PARTIDAS))
					    done

					    #CÁLCULO DE LA MEDIA DE LOS TIEMPOS DE TODAS LAS PARTIDAS
						for ((i=0;i<$CANT_PARTIDAS;i++))
						do
							MEDIA=$((${contadortiempos[i]} + $MEDIA))
						done
						MEDIA=$(($MEDIA / $CANT_PARTIDAS))

					    #CÁLCULO DEL TIEMPO MÁXIMO Y MÍNIMO
						#inicializacion de valores con el contenido de la primera celda
					    TMIN=${contadortiempos[0]}
					    TMAX=${contadortiempos[0]}

					    for ((i=0;i<$CANT_PARTIDAS;i++))
						do
							if test "${contadortiempos[i]}" -le "$TMIN"
							then
								TMIN=${contadortiempos[i]}
							fi
							if test "${contadortiempos[i]}" -ge "$TMAX"
							then
								TMAX=${contadortiempos[i]}
							fi
						done

					    #PRESENTACIÓN DE RESULTADOS

					    if test "$CANT_PARTIDAS" -eq 1
					    then
					        echo "• Solo se ha jugado una partida."
					    else
					        echo "• Se han jugado un total de $CANT_PARTIDAS partidas."
					    fi
						
						echo "• La media de los tiempos de todas las partidas"
						echo "es aproximadamente de $MEDIA segundos."
						
						if test "$TMAX" -eq 1
					    then
							echo "• La partida más larga ha durado $TMAX segundo."
						else
							echo "• La partida más larga ha durado $TMAX segundos."
						fi

						if test "$TMIN" -eq 1
					    then
							echo "• La partida más corta ha durado $TMIN segundo."
						else
							echo "• La partida más corta ha durado $TMIN segundos."
						fi

					    echo "• Porcentajes de partidas respecto al número de jugadores:"
					    for ((i=0;i<=8;i++))
					    do
					        echo " - $(($i + 2)) jugadores: ${porcentajecantjugadores[i]}%"
					    done

					    echo ""
					    echo "• TABLA DE DATOS DE LOS JUGADORES:"
					    echo "--------------------------------------------------------------------------------------------"
					    echo "| NOMRE  | GANADAS | FINALISTA | ÚLTIMO | %GANADAST   | %GANADAS    | TIEMPO TOTAL JUGANDO |"
					    echo "--------------------------------------------------------------------------------------------"
					    for ((i=0;i<=9;i++))
					    do 
					        #La orden "printf" no la hemos visto en clase pero usando el manual de BASH es facil saber como se utiliza.
					        printf "| %-7s| %-8d| %-10d| %-7d| " "${nombres[i]}" "${ganadas[i]}" "${finalista[i]}" "${ultimo[i]}"

					        if test "${cantpartidasjugador[i]}" -eq 0
					        then
					            printf "%-11s| %-11s| " "N/A" "N/A"
					        else
					            printf "%-3d%% (%d/%2d) | %-3d%% (%d/%2d) | " "$(( (${ganadas[i]}*100)/$CANT_PARTIDAS ))" "${ganadas[i]}" "$CANT_PARTIDAS" "$(( (${ganadas[i]}*100)/${cantpartidasjugador[i]} ))" "${ganadas[i]}" "${cantpartidasjugador[i]}"
					        fi

					        printf "%-21d|\n" "${canttiempojugador[i]}"
					    done
					    echo "--------------------------------------------------------------------------------------------"
					else
						echo "Todavía no has jugado ninguna partida."
					fi

					;;
				S|s)
					echo "|--------------------------------------------------|"
					echo "|----------------GRACIAS POR JUGAR-----------------|"
					echo "|--------------------------------------------------|"
					exit
					;;
				*)
					;;
			esac
		done
	fi
		
else
	echo "El fichero config.cfg no existe"
	exit
fi



