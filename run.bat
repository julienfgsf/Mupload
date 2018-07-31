::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJFSR5E4/KR9oXwGWKXuGC6AM5Of666SOoUJ9
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJH+x3mtwCStkcCmXLGe1B7Eguaap0/iSrAMYTOdf
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
REM @echo off
SETLOCAL
SET VERSION=0

del /q version > nul
del /q update.cmd > nul
rmdir /S /Q upd > nul
cls

Title Mupload v%VERSION%

IF "%1"=="-?" GOTO README
IF "%1"=="-u" set ONLINEUPD=%2
	IF NOT DEFINED ONLINEUPD set ONLINEUPD=https://github.com/julienfgsf/Mupload/raw/master/version

bitsadmin /transfer version %ONLINEUPD% "%cd%\version"


mode con: lines=24 cols=91
cls
					echo.
					echo       ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
					echo       º                                                                             º
					echo       º             ÛÛ»   ÛÛ»ÛÛÛÛÛÛ» ÛÛÛÛÛÛ»  ÛÛÛÛÛ» ÛÛÛÛÛÛÛÛ»ÛÛÛÛÛÛÛ»              º
					echo       º             ÛÛº   ÛÛºÛÛÉÍÍÛÛ»ÛÛÉÍÍÛÛ»ÛÛÉÍÍÛÛ»ÈÍÍÛÛÉÍÍ¼ÛÛÉÍÍÍÍ¼              º
					echo       º             ÛÛº   ÛÛºÛÛÛÛÛÛÉ¼ÛÛº  ÛÛºÛÛÛÛÛÛÛº   ÛÛº   ÛÛÛÛÛ»                º
					echo       º             ÛÛº   ÛÛºÛÛÉÍÍÍ¼ ÛÛº  ÛÛºÛÛÉÍÍÛÛº   ÛÛº   ÛÛÉÍÍ¼                º
					echo       º             ÈÛÛÛÛÛÛÉ¼ÛÛº     ÛÛÛÛÛÛÉ¼ÛÛº  ÛÛº   ÛÛº   ÛÛÛÛÛÛÛ»              º
					echo       º              ÈÍÍÍÍÍ¼ ÈÍ¼     ÈÍÍÍÍÍ¼ ÈÍ¼  ÈÍ¼   ÈÍ¼   ÈÍÍÍÍÍÍ¼              º
					echo       º                                                                             º
					echo       ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
					echo       Mupload ver %VERSION%
					echo.
					echo.

		for /f "tokens=2 delims= " %%a in ('findstr "ver" "version"') do set NEWVER=%%a
		IF %VERSION% LSS %NEWVER%	(	echo Une nouvelle version est disponible ^(%NEWVER%^) !
										Choice /C:on /M:"Voulez-vous effectuer la mise … jour ?" )
											IF %errorlevel%==1 GOTO UPDATE

GOTO DEBUTLOG

:README
echo.
echo Mupload v%VERSION%
echo.
echo Description :
echo    Upload automatique des BAT client vers MEGA.nz
echo.
echo.
echo Utilisation :
echo    RestoreAll.exe [-u http://url]
echo.
echo ParamŠtres
echo    -u    http://url		 Sp‚cifie l'url de t‚l‚chargement de la mise
echo                             … jour.
echo.
echo    -?                       Affiche ce message d'aide.
GOTO EOF

:DEBUTLOG
cls
REM ===========> Initialisation du LOG
echo ========================================================== >> log.txt
echo ========================================================== >> log.txt
echo ========================================================== >> log.txt
echo Starting %date% ^| %time% >> log.txt
echo. >> log.txt
echo. >> log.txt
set ERRCOUNT=0
set FILECOUNT=0

:DEBUT
REM Initialisation des variables
set FOLDER=
set MID=
set MPWD=
set MDIR=
set MAILFROM=


REM Lecture du fichier mupload.ini et ‚criture des variables
	REM FOLDER : Dossier local … surveiller
	REM MID : Login MEGA
	REM MPWD : Pasword MEGA
	REM MDIR : Dossier distant, sur MEGA, vers lequel seront uploader les fichiers
	REM MAILFROM : Adresse E-mail depuis laquelle seront ‚mis les E-mail avec le lien MEGA … destination des clients
	REM SPLASH : Choix du Splash Screen
	for /f "tokens=2 delims==" %%i in ('findstr "Folder" "mupload.ini"') do set FOLDER=%%i
		IF NOT DEFINED FOLDER goto ERR
		set FOLDER=%FOLDER%\
		set FOLDER=%FOLDER:\\=\%
	for /f "tokens=2 delims==" %%j in ('findstr "MegaID" "mupload.ini"') do set MID=%%j
		IF NOT DEFINED MID goto ERR
	for /f "tokens=2 delims==" %%k in ('findstr "MegaPwd" "mupload.ini"') do set MPWD=%%k
		IF NOT DEFINED MPWD goto ERR
	for /f "tokens=2 delims==" %%l in ('findstr "MegaDir" "mupload.ini"') do set MDIR=%%l
		IF NOT DEFINED MDIR goto ERR
		set MDIR=%MDIR:\=/%
	for /f "tokens=2 delims==" %%m in ('findstr "Email" "mupload.ini"') do set MAILFROM=%%m
		IF NOT DEFINED MAILFROM goto ERR
	for /f "tokens=2 delims==" %%n in ('findstr "Splash" "mupload.ini"') do set SPLASH=%%n
		IF NOT DEFINED SPLASH set SPLASH=2

REM D‚marrage du serveur MEGA
start /min  megacmdserver.exe
	REM Login
	megaclient login %MID% %MPWD%
	REM Cr‚ation des dossiers sur MEGA
	megaclient mkdir "%MDIR%" -p

REM Cr‚ation des dossiers Backup et Erreur locaux
IF NOT EXIST "%FOLDER%backup" mkdir "%FOLDER%backup"
IF NOT EXIST "%FOLDER%backup\erreur" mkdir "%FOLDER%backup\erreur"




REM ##########################################
REM ##########################################

REM            D‚but de la boucle

REM ##########################################
REM ##########################################


:START

REM Couleur al‚atoire
Set /a num=(%Random% %%9)
IF %num%==7 set /a num=%num%+1
color F%num%

REM Mise … z‚ro des variables de boucle
	REM JDFFILE : Fichier JDF avec chemin absolut
	REM PDFFILE : Fichier PDF avec chemin absolut
	REM PDFFILEPATH : Fichier PDF seul, sans chemin d'accŠs
	REM MAILTO : Adresse E-mail extraite du fichier JDF

	Set JDFFILE=
	Set PDFFILE=
	Set PDFFILEPATH=
	Set MAILTO=

REM Splash Screen
Set /a num=(%Random% %%9)
IF %num%==7 set /a num=%num%+1
color F%num%

CLS
IF %SPLASH%==1 (	mode con: lines=22 cols=81
					echo            __  ___            __                __ 
					echo           /  ^|/  /_  _ ____  / /___  _____ ___ / / 
					echo          / /^|_/ / / / / __ \/ / __ \/ __  / __' /  
					echo         / /  / / /_/ / /_/ / / /_/ / /_/ / /_/ /   
					echo        /_/  /_/\__,_/ .___/_/\____/\__,_/\__,_/                            
					echo                    /_/                                                 ver %VERSION%
					echo.
					echo.
					echo.
					echo.
				)

IF %SPLASH%==2 (	mode con: lines=24 cols=81
					echo  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
					echo  º                __  __                 _                    _                º
					echo  º               ^|  \/  ^|  _   _  _____ ^| ^| _____  _____  ___^| ^|               º
					echo  º               ^| ^|\/^| ^| ^| ^| ^| ^|^|  _  \^| ^|/  _  \/  _` ^|/  _` ^|               º
					echo  º               ^| ^|  ^| ^| ^| ^|_^| ^|^| ^|_^| ^|^| ^|^| ^|_^| ^|^| ^|_^| ^|^| ^|_^| ^|               º
					echo  º               ^|_^|  ^|_^| \_____/^| ,___/^|_^|\_____/\___,_^|\___,_^|               º
					echo  º                               ^|_^|                                           º
					echo  º                                                                      ver %VERSION%º
					echo  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
					echo.
					echo.
					echo.
					echo.
				)
				
IF %SPLASH%==3 (	mode con: lines=33 cols=81
					echo  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
					echo  º                                                                             º
					echo  º                                          .::::.                             º
					echo  º                                        .::::::::.                           º
					echo  º                                        :::::::::::                          º
					echo  º                                        ':::::::::::..                       º
					echo  º                                         :::::::::::::::'                    º
					echo  º                                          ':::::::::::.                      º
					echo  º                                            .::::::::::::::'                 º
					echo  º                                          .:::::::::::...                    º
					echo  º                                         ::Mupload:::::''                    º
					echo  º                             .:::.       '::::::::''::::                     º
					echo  º                           .::::::::.      ':::::'  '::::                    º
					echo  º                          .::::':::::::.    :::::    '::::.                  º
					echo  º                        .:::::' ':::::::::. :::::      ':::.                 º
					echo  º                      .:::::'     ':::::::::.:::::       '::.                º
					echo  º                    .::::''         '::::::::::::::       '::.               º
					echo  º                   .::''              '::::::::::::         :::...           º
					echo  º                ..::::                  ':::::::::'        .:' ''''          º
					echo  º             ..''''':'                    ':::::.'                           º
					echo  º                                                                      ver %VERSION%º
					echo  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
				)
				
IF %SPLASH%==4 (	mode con: lines=24 cols=81
					echo.
					echo.
					echo         ÛÛÛ»   ÛÛÛ»ÛÛ»   ÛÛ»ÛÛÛÛÛÛ» ÛÛ»      ÛÛÛÛÛÛ»  ÛÛÛÛÛ» ÛÛÛÛÛÛ» 
					echo         ÛÛÛÛ» ÛÛÛÛºÛÛº   ÛÛºÛÛÉÍÍÛÛ»ÛÛº     ÛÛÉÍÍÍÛÛ»ÛÛÉÍÍÛÛ»ÛÛÉÍÍÛÛ»
					echo         ÛÛÉÛÛÛÛÉÛÛºÛÛº   ÛÛºÛÛÛÛÛÛÉ¼ÛÛº     ÛÛº   ÛÛºÛÛÛÛÛÛÛºÛÛº  ÛÛº
					echo         ÛÛºÈÛÛÉ¼ÛÛºÛÛº   ÛÛºÛÛÉÍÍÍ¼ ÛÛº     ÛÛº   ÛÛºÛÛÉÍÍÛÛºÛÛº  ÛÛº
					echo         ÛÛº ÈÍ¼ ÛÛºÈÛÛÛÛÛÛÉ¼ÛÛº     ÛÛÛÛÛÛÛ»ÈÛÛÛÛÛÛÉ¼ÛÛº  ÛÛºÛÛÛÛÛÛÉ¼
					echo         ÈÍ¼     ÈÍ¼ ÈÍÍÍÍÍ¼ ÈÍ¼     ÈÍÍÍÍÍÍ¼ ÈÍÍÍÍÍ¼ ÈÍ¼  ÈÍ¼ÈÍÍÍÍÍ¼ 
					echo                                                                         ver %VERSION%
					echo.
					echo.
					echo.
					echo.
				)
				
IF %SPLASH%==5	(	mode con: lines=27 cols=81
					echo.
					echo       /$$      /$$                     /$$                           /$$
					echo      ^| $$$    /$$$                    ^| $$                          ^| $$
					echo      ^| $$$$  /$$$$ /$$   /$$  /$$$$$$ ^| $$  /$$$$$$   /$$$$$$   /$$$$$$$
					echo      ^| $$ $$/$$ $$^| $$  ^| $$ /$$__  $$^| $$ /$$__  $$ ^|____  $$ /$$__  $$
					echo      ^| $$  $$$^| $$^| $$  ^| $$^| $$  \ $$^| $$^| $$  \ $$  /$$$$$$$^| $$  ^| $$
					echo      ^| $$\  $ ^| $$^| $$  ^| $$^| $$  ^| $$^| $$^| $$  ^| $$ /$$__  $$^| $$  ^| $$
					echo      ^| $$ \/  ^| $$^|  $$$$$$/^| $$$$$$$/^| $$^|  $$$$$$/^|  $$$$$$$^|  $$$$$$$
					echo      ^|__/     ^|__/ \______/ ^| $$____/ ^|__/ \______/  \_______/ \_______/
					echo                             ^| $$                                        
					echo                             ^| $$                                        
					echo                             ^|__/                                 ver %VERSION%
					echo.
					echo.
					echo.
					echo.
				)
				
IF %SPLASH%==6	(	mode con: lines=30 cols=95
					echo       ___           ___           ___           ___       ___           ___           ___     
					echo      /\__\         /\__\         /\  \         /\__\     /\  \         /\  \         /\  \    
					echo     /::^|  ^|       /:/  /        /::\  \       /:/  /    /::\  \       /::\  \       /::\  \   
					echo    /:^|:^|  ^|      /:/  /        /:/\:\  \     /:/  /    /:/\:\  \     /:/\:\  \     /:/\:\  \  
					echo   /:/^|:^|__^|__   /:/  /  ___   /::\~\:\  \   /:/  /    /:/  \:\  \   /::\~\:\  \   /:/  \:\__\ 
					echo  /:/ ^|::::\__\ /:/__/  /\__\ /:/\:\ \:\__\ /:/__/    /:/__/ \:\__\ /:/\:\ \:\__\ /:/__/ \:^|__^|
					echo  \/__/~~/:/  / \:\  \ /:/  / \/__\:\/:/  / \:\  \    \:\  \ /:/  / \/__\:\/:/  / \:\  \ /:/  /
					echo        /:/  /   \:\  /:/  /       \::/  /   \:\  \    \:\  /:/  /       \::/  /   \:\  /:/  / 
					echo       /:/  /     \:\/:/  /         \/__/     \:\  \    \:\/:/  /        /:/  /     \:\/:/  /  
					echo      /:/  /       \::/  /                     \:\__\    \::/  /        /:/  /       \::/__/   
					echo      \/__/         \/__/                       \/__/     \/__/         \/__/         ~~       
					echo.
					echo.
					echo                                                                  ver %VERSION%
					echo.
				)
				
echo.
echo  Dossier surveill‚ :      %FOLDER%
echo  Dossier de destination : %MDIR:/=\%
echo  Compte MEGA :            %MID%
echo  E-mail envoy‚ depuis :   %MAILFROM%
echo  Fichiers trait‚s :       %FILECOUNT%
echo.
echo.
echo.
IF %ERRCOUNT% NEQ 0 ( echo Q : Quitter    ^|    E : Edit Config    ^|    L : LOG            ^( Erreurs : %ERRCOUNT% ^)) ELSE (echo  Q : Quitter    ^|    E : Edit Config    ^|    L : LOG )

IF %SPLASH%==X Set SPLASH=x 
IF %SPLASH%==x (	mode con: lines=56 cols=81
					cls
					echo    $$$$$$$$$$$$$$h$$$$$$$$9$$$$$$$;   f$$$$$$$\$$$;$/
					echo   J$$$$$$$$$$$$$$$$$$$$$$$$$$$;C9$;  ;"J$$$JP  $$$;$$
					echo   $$$$$$$$$$$$$$J$$$$$$$$$$$$?$;$$;, ;         $$$$:\
					echo  J$$$$$$$$$$$$$C$$$$$$$$$$$$C;?;$$;, '        .$$;$j'
					echo  $$$$$$$$$$$$$$?$$$$$$$$$$$$??;9$C;  '        J$?;$:
					echo $$$$$$$$$$$$$$C$$$$$$$$$$$$C;;;$$;'          .$C;J\l
					echo $$$$$$$$$$$$$$?$$$$$$$$$$$$;J;3$$ cc         $$;;hj:
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$;$P'""""""     ;$$C;$'\
					echo $$$$$$$$$$$$$?$$$$$$$$$$$$$$;$$             $$$F;9j'
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$$;$P  ,J$$$$$C   :$$$;;9`
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$S$"?$Mupload$P"  J$$$;;$
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$$"   "?;;;;J"   ;$$$$;;$
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$               .$$$$$;jF
					echo $$$$$$$$$$$$$$$$$$$$$$$$$$,             ;$$$$$;;$'
					echo $$$$$$$$$$$$$$$$$$$$$$$$?;?h.          J$$$$$C;;F
					echo $$$$$$$$$$$$$$$$$$$$$$$;;;;;?$c,_   ,,$$$$$$$;;jF
					echo $$$$$$$$$$$$$$$$$$$$$"`.`.;;;;;.`""$$$$$$$$$;;;$'
					echo $$$$$$$$$$$$$$$$$$P"`.`.`.`.`.`.`.`$$$$$$$$;;;;P
					echo $3$$$$?$$$$$$$??;;;.`.`.`.`.`.`.`.?$$$$$$C;;;;J
					echo  j''  ?;;;;;;'`';;;.`      .`.`.`.$$$$$$?;;;;9F
					echo J"  z$;;;,       `:         `.`.  $$$$?;;;;;i"
					echo    ?hPi;;;;;;;;,.           `.`   C$  `"?hiJF
					echo       ;f;;;,  ``.;;;;;,     `.`   $;???c   `""$.
					echo     c="    `;;,              .`.   ";;;;"c,    $.
					echo    $                         .`.`   `;;;;;?h  .  3c
					echo    $  J?$                     `.`.`.  `:`.`?$."""  "._
					echo  \P' $$  $                      `.`.   .`.`.`"c       "c
					echo   L  $$   ?                             `.`.`.`$,.  ..  "h
					echo   $ .$$h   ?.                            .`.`.`.`hJ""?cCL ".
					echo   ? \$$$h   ?.              .             `.`.`.`.?.     "?$c,.
					echo   ?. $$$$    `"=c          ;;;;,           .`.`.`.`3cc,       `"=c,.
					echo    ?.$$$$$"     `L         ;;;;;;;,          .`.`.`.`$;??h,_        `h
					echo     ?$$$$$       ""'       `;;;;;;;;,         `.`.`.`.hJ"  `"??cc,    $
					echo ?"???"??"          j'       :;;;;;;;;;;,       .`.`.`.`$               $
					echo ;;,                 $        :;;;;;;;;;;;,      `.`.`.`.$c,,__          $
					echo i;;,                 h         `':;;;;;;;;;,      `.`.`.`h    `"         ?c
					echo `$;;;;,              $r           `:;;;;;;;;,      .`.`.`.$
					echo   J$i;;h             $;             `:;;;;;;;,      `.`.`.`$""=,
					echo .$$$$h;,            ,C;       .j???c, `;t;;;;,        `.`.`.?c
					echo $$$$$$h;,           $;,       J;;;;i;L. :?/;;,           .`.`.?h,_
					echo $$$$$$$;           j';        $;;;$h9;L `:?/;;,                ,C?h.
					echo ?$$$$$$;           $;,        `$;?ii$;;h `;L;;,                \C;;?h
					echo  3$$$$?;          J?;,         `h;;;;;;P  :;L;,                `$;;$?L
					echo .$$$$;;'         ,C;;,           `?CjjF   `;3;,                 $;;?h$
					echo $$$$;;:          $;;;,                    `;3;                  `h;;;F
					echo $$$?;;        `.JF;;;,                     ;3;                   `hiF    J"
					echo $$?;'     .`.`.c$h;;;;,                   ;;f;,                 ,;iF   z" z
					echo C;;       .`.`JCCC$;;;;;                 ;;$;;;; `;i;,         ;;J"   J' J'
					echo ;;      .`.` JF;;??$hi;;;;.            .;;$;;;;;, ;?$;;;,    ,;;i$   J'.P
					echo '      `.`. ,C;;;;,  `"h;;;;;;;;;;;;;;;i$?;;;;;;;, :;?h;;;;;;;;9"?. j','
					echo       .`.` .$;;;;'       "??iijjjjii?""`.`;;;;;;;,  `;;?h;;;;iP   $,'.P
					echo      `.`. ,C;;;,                             `;;;;,  `;;;J""'     `h $
					echo     .`.  ,C;;;;'                               ;;,    ;;;9         $$    ver %VERSION%
					echo                                                         Fichiers trait‚s : %FILECOUNT%
					IF %ERRCOUNT% NEQ 0 ( echo Q : Quitter    ^|    E : Edit Config    ^|    L : LOG            ^( Erreurs : %ERRCOUNT% ^)) ELSE (echo  Q : Quitter    ^|    E : Edit Config    ^|    L : LOG )
				)

choice /c:pQEL /n /t:3 /d:p > nul
	if %errorlevel%==2		GOTO EOF
	if %errorlevel%==3 (	notepad mupload.ini
							GOTO DEBUT)
	if %errorlevel%==4		start notepad log.txt

							
REM Recherche des fichies .JDF dans le dossier %FOLDER%
for %%f in (%FOLDER%*.jdf) do ( set JDFFILE=%%f
								REM Cr‚ation des variables PDFFILE et PDFFILEPATH
								Call set PDFFILE=%%JDFFILE:.jdf=.pdf%%
								Call set PDFFILEPATH=%%PDFFILE:%FOLDER%=%%
								REM Transmission des variables … la commande IFCMD
								Call IFCMD.cmd
								)

GOTO START									

:ERR
REM Arrˆt des process
REM Recr‚ation du fichier mupload s'il n'existe pas
IF NOT EXIST mupload.ini (	echo ## Dossier a surveiller ex:  D:\PDF Export\ > mupload.ini
							echo Folder=>> mupload.ini
							echo. >> mupload.ini
							echo ## Login du compte MEGA ex:  adresse@email.com >> mupload.ini
							echo MegaID=>> mupload.ini
							echo. >> mupload.ini
							echo ## Mot de passe du compte MEGA >> mupload.ini
							echo MegaPwd=>> mupload.ini
							echo. >> mupload.ini
							echo ## Dossier d'exportation sur le disque nuagique ex: pdf-export ou files\pdfexport>> mupload.ini
							echo MegaDir=>> mupload.ini
							echo.  >> mupload.ini
							echo ## Adresse e-mail depuis laquelle seront emis les messages envoyes aux clients  >> mupload.ini
							echo Email=>> mupload.ini 
							echo.  >> mupload.ini
							echo Splash=>> mupload.ini  )

REM Affichage de l'erreur
cls
echo.
echo  ÛÛÛÛÛÛÛ»ÛÛÛÛÛÛ» ÛÛÛÛÛÛ» ÛÛÛÛÛÛÛ»ÛÛ»   ÛÛ»ÛÛÛÛÛÛ»     ÛÛ»
echo  ÛÛÉÍÍÍÍ¼ÛÛÉÍÍÛÛ»ÛÛÉÍÍÛÛ»ÛÛÉÍÍÍÍ¼ÛÛº   ÛÛºÛÛÉÍÍÛÛ»    ÛÛº
echo  ÛÛÛÛÛ»  ÛÛÛÛÛÛÉ¼ÛÛÛÛÛÛÉ¼ÛÛÛÛÛ»  ÛÛº   ÛÛºÛÛÛÛÛÛÉ¼    ÛÛº
echo  ÛÛÉÍÍ¼  ÛÛÉÍÍÛÛ»ÛÛÉÍÍÛÛ»ÛÛÉÍÍ¼  ÛÛº   ÛÛºÛÛÉÍÍÛÛ»    ÈÍ¼
echo  ÛÛÛÛÛÛÛ»ÛÛº  ÛÛºÛÛº  ÛÛºÛÛÛÛÛÛÛ»ÈÛÛÛÛÛÛÉ¼ÛÛº  ÛÛº    ÛÛ»
echo  ÈÍÍÍÍÍÍ¼ÈÍ¼  ÈÍ¼ÈÍ¼  ÈÍ¼ÈÍÍÍÍÍÍ¼ ÈÍÍÍÍÍ¼ ÈÍ¼  ÈÍ¼    ÈÍ¼
echo.

echo.
echo Le fichier mupload.ini n'est pas correctement configur‚ !
echo.
echo.
echo.
echo.
echo.
echo Appuyer sur E pour ‚diter le fichier de configuration
echo Eppuyer sur R pour r‚initialiser le fichier de configuration
echo Appuyer sur Q pour quitter
echo.
choice /c:ERQ
	if %errorlevel%==1 (	notepad mupload.ini
							GOTO DEBUT)
	if %errorlevel%==2 ( 	del mupload.ini
							GOTO ERR)
	if %errorlevel%==3		GOTO EOF


:UPDATE

echo Mise … jour en cours...
ping 127.0.0.0 > nul

mkdir upd

for /f "tokens=2 delims= " %%a in ('findstr "url" "version"') do set UPDATE=%%a
for /f "tokens=*" %%b in ('bitsadmin /transfer upd "%UPDATE%" "%cd%\upd\update.bin"') do set RESULT="%%b"
echo R‚sultat : %RESULT%
pause
del /q version

IF %RESULT% EQU ERROR GOTO UPD_ERR

7z e "upd\update.bin" -oupd\tmp\
	IF %errorlevel% NEQ 0 GOTO UPD_ERR

	
									
        ECHO @echo off> upd\update.cmd
		ECHO ping 127.0.0.1 ^> nul >> upd\update.cmd
		ECHO move /y mupload.ini upd\tmp\>> upd\update.cmd
		ECHO del /q *.*>>upd\update.cmd
		ECHO move /y upd\tmp\*.*>>upd\update.cmd
		ECHO start run.exe>> upd\update.cmd
		ECHO exit>> upd\update.cmd
		
pause
start upd\update.cmd
GOTO EOF

:UPD_ERR
echo !! Erreur lors de la mise … jour !!
RMDIR /S /Q upd
pause
GOTO DEBUTLOG

:EOF
megaclient logout
taskkill /IM megacmdserver.exe
exit