#	label_extraction (January 2014)
#
# 	Reads sound files and its TextGrid tier for each of the sounds and it can get:
#		a) labels form a point tier, 
#		b) labels from a the interval to which the point correspond. 
# 		
#	
# 
# 								INSTRUCTIONS
#	0. You need a .wav with its Textgrid saved in the same folder and with at least 1 point tier and 1 interval tier.
#	1. Run
#	2. FORM EXPLANATIONS:
#		In the first field you must write the path of the folder where your files are kept
#		The second allows you to choose the name of the txt that will be created
#		
#	Any feedback is welcome, please if you notice any mistakes or come up with anything that can improve this script, let me know!
#
#		Wendy Elvira-García
#		Laboratory of Phonetics (University of Barcelona)
#		wendyelviragarcia@gmail.com
#		
#		
##############################################################################################################





#Limpia los objetos que te has olvidado en el Praat antes de empezar, sí, tb los que no guardaste.
select all
if numberOfSelected() > 0
	Remove
endif

if praatVersion < 5363
exit This script works only in Praat  5363 or later
endif

folder$ = chooseDirectory$ ("Elige la carpeta donde están los archivos que quieres analizar:")

form Labels
		comment txt name (it will be created in the same folder where the files are kept): 
	text txtname labels
	comment ¿Which data do you want to extract?
		comment Tier number for interval tier labels (usually syllable transcription):
	integer tier_interval 1
		comment Tier number for point tier labels:
	integer point_tier 2

endform


#########################		CREA ARCHIVO DE TABLA Y ENCABEZADOS	#########################################



# Crea el archivo txt y dejo preparados 2 encabezados.
arqout$ = folder$ + "/" + txtname$ + ".txt"
if fileReadable (arqout$)
	pause There is already a file with that name, you will overwrite it
	deleteFile: arqout$
endif

	appendFileLine: arqout$, "Filename", tab$, "point-label", tab$, "interval-label", tab$, newline$

##################################	BUCLE	#####################################


#  bucle principal ciérrame al final del script
# Crea la lista de objetos desde el string
Create Strings as file list... list 'folder$'/*.wav
#Hace el bucle con ello
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	select Strings list
	file$ = Get string... ifile
	base$ = file$ - ".wav"
	fil$ = folder$ + file$
	

	#lee el archivo de sonido
	Read from file... 'folder$'/'file$'
	base$ = selected$ ("Sound")

	#lee el texgrid
	filegrid$ = base$ + ".TextGrid"
	Read from file... 'folder$'/'filegrid$'

	
		############################# 		ETIQUETAS 		#############################
	
		select TextGrid 'base$'
		numberOfPoints = Get number of points: point_tier
		for point to numberOfPoints
			etiquetapunto$ = Get label of point: point_tier, point
			point_time = Get time of point: point_tier, point
			interval = Get interval at time: tier_interval, point_time
			etiquetaintervalo$ = Get label of interval: tier_interval, interval
			appendFile: arqout$, base$, tab$, etiquetapunto$, tab$, etiquetaintervalo$, newline$
			
		endfor
		
	
	
	select all
	minus Strings list
	Remove

	
#fin del bucle general
endfor

#limpieza final borra el Strings list
select all
Remove
echo Ya puedes abrir el archivo
