REM Fichier de commande IFCMD

	REM Recherche du fichier PDF
	REM Recherche de l'Email
	REM Upload des fichier et envoi du mail
	REM Traitement des erreurs
	
REM R‚initialisation des varaibles Mail URL et Erreur
	REM Erreur 1 : Pas de Mail
	REM Erreur 2 : Pas de PDF
	REM Erreur 3 : Erreur upload MEGA
	REM Erreur 4 : Erreur partage MEGA
	REM Erreur 5 : Erreur d'envoi de mail
set MAILTO=
set ERR=0
set URL=



	REM Recherche du PDF correspondant au nom du JDF
	
	IF EXIST "%PDFFILE%"	(	set /a FILECOUNT=%FILECOUNT%+1
								REM Si un fichier PDF est trouv‚ :
								REM ===========> Renseignement du LOG
								echo ------------------------------------------------------------------------------------------ >> log.txt
								echo %date% ^| %time% >> log.txt
								echo Find PDF file : "%PDFFILE%" >> log.txt
								
								REM Recherche de l'E-mail dans le fichier JDF
								for /f "tokens=5 delims==" %%i in ('findstr "Email" "%JDFFILE%" ^| findstr /i "Locator"') do set MAILTO=%%i
								
									REM Si l'E-mail est trouv‚e
									IF DEFINED MAILTO GOTO PROCESS
									
									REM Si pas de mail : Erreur 1
									Set ERR=1
									GOTO EOF 
							)
								
	REM Si pas de PDF : Erreur 2
	SET ERR=2
	GOTO EOF
	
	
:PROCESS

REM Nettoyage de l'adresse E-mail
set MAILTO=%MAILTO:"/>=%
set MAILTO=%MAILTO:"=%
REM Si pas de mail, Erreur 1
IF NOT DEFINED MAILTO	(	Set ERR=1
							GOTO EOF )
			REM ===========> Renseignement du LOG
			echo Customer Mail : %MAILTO% >> log.txt
	
	
	REM Upload du fichier .PDF sur MEGA
	megaclient put "%PDFFILE%" "%MDIR%" >> log.txt
	IF %errorlevel% NEQ 0 ( Set ERR=3
							GOTO EOF )
			REM ===========> Renseignement du LOG
			echo Upload successfully to : %MDIR% >> log.txt
	
	
	
	REM Cr‚ation du lien de partage
	for /f "tokens=2 delims=#" %%j in ('megaclient export -a "%MDIR%/%PDFFILEPATH%"') do set URL=%%j
	IF NOT DEFINED URL	(	Set ERR=4
							GOTO EOF )
	Set URL=https://mega.nz/#%URL%
			REM ===========> Renseignement du LOG
			echo Link created successfully : %URL% >> log.txt
			
	REM Envoi du mail et renseignement du LOG
	mailsend -f %MAILFROM% -smtp 127.0.0.1 -t %MAILTO% -sub "BAT PDF" -M "Votre fichier BAT ( %PDFFILE% ) est disponible … l'adreese suivante :" -M "%url%" -log log.txt
	If %errorlevel% NEQ 0 Set ERR=5

	
:EOF

	REM Gestion des erreurs
	REM Erreur 0 : Pas d'erreur
	IF %ERR%==0	(	IF NOT EXIST "%FOLDER%backup\%MAILTO%" mkdir "%FOLDER%backup\%MAILTO%" > nul
					move /y "%PDFFILE%" "%FOLDER%backup\%MAILTO%\" > nul
					move /y "%JDFFILE%" "%FOLDER%backup\%MAILTO%\" > nul
				)
				
	REM Erreur 1 : Pas d'email
	IF %ERR%==1	(	echo No E-mail address found in "%JDFFILE%" >> log.txt
					echo Failed with error 1 >> log.txt
					echo No E-mail address found in "%JDFFILE%" > "%FOLDER%backup\erreur\%PDFFILEPATH:.pdf=.txt%"
					move /y "%PDFFILE%" "%FOLDER%backup\erreur\" > nul
					move /y "%JDFFILE%" "%FOLDER%backup\erreur\" > nul
					set /a ERRCOUNT=%ERRCOUNT%+1
				)
	
	REM Erreur 2 : Pas de fichier PDF
	IF %ERR%==2	(	SET PDFFILE=
					SET PDFFILEPATH=
				)
	
	REM Erreur 3 : Erreur d'upload
	IF %ERR%==3	(	echo Failed with error 3 >> log.txt
					IF NOT EXIST "%FOLDER%backup\%MAILTO%" mkdir "%FOLDER%backup\%MAILTO%" > nul
					IF NOT EXIST "%FOLDER%backup\%MAILTO%\erreur" mkdir "%FOLDER%backup\%MAILTO%\erreur" > nul
					echo Failed to upload file to MEGA > "%FOLDER%backup\%MAILTO%\erreur\%PDFFILEPATH:.pdf=.txt%"
					move /y "%PDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					move /y "%JDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					set /a ERRCOUNT=%ERRCOUNT%+1
				)

	REM Erreur 4 : Erreur cr‚ation du lien
	IF %ERR%==4	(	echo Link creation failed >> log.txt
					echo Failed with error 4 >> log.txt
					IF NOT EXIST "%FOLDER%backup\%MAILTO%" mkdir "%FOLDER%backup\%MAILTO%" > nul
					IF NOT EXIST "%FOLDER%backup\%MAILTO%\erreur" mkdir "%FOLDER%backup\%MAILTO%\erreur" > nul
					echo MEGA Link creation failed ! > "%FOLDER%backup\%MAILTO%\erreur\%PDFFILEPATH:.pdf=.txt%"
					move /y "%PDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					move /y "%JDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					set /a ERRCOUNT=%ERRCOUNT%+1
				)

	REM Erreur 5 : Erreur d'envoi de mail
	IF %ERR%==5	(	echo Failed with error 5 >> log.txt
					IF NOT EXIST "%FOLDER%backup\%MAILTO%" mkdir "%FOLDER%backup\%MAILTO%" > nul
					IF NOT EXIST "%FOLDER%backup\%MAILTO%\erreur" mkdir "%FOLDER%backup\%MAILTO%\erreur" > nul
					echo Error sending mail ! > "%FOLDER%backup\%MAILTO%\erreur\%PDFFILEPATH:.pdf=.txt%"
					move /y "%PDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					move /y "%JDFFILE%" "%FOLDER%backup\%MAILTO%\erreur" > nul
					set /a ERRCOUNT=%ERRCOUNT%+1
				)
