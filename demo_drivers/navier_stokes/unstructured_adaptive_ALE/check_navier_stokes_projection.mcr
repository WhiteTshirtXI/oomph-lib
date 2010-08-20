#!MC 1100



# Use png output (otherwise avi)
$!VARSET |PNG|=0

$!VARSET |dir|='Validation/RESLT'


$!VARSET |orig_step|=6

$!READDATASET  '"|dir|/soln|orig_step|.dat" '
  READDATAOPTION = NEW
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D

$!VARSET |LAST_ORIG|=|NUMZONES|

$!FIELDLAYERS SHOWMESH = NO
$!FIELDLAYERS SHOWSHADE = YES
$!FIELDLAYERS USETRANSLUCENCY = YES
$!FIELDMAP [1-|LAST_ORIG|]  GROUP = 2
$!FIELDMAP [1-|LAST_ORIG|]  EDGELAYER{COLOR = GREEN}
$!FIELDMAP [1-|LAST_ORIG|]  EDGELAYER{LINETHICKNESS = 0.02}
$!FIELDMAP [1-|LAST_ORIG|]  SHADE{COLOR = GREEN}
$!FIELDMAP [1-|LAST_ORIG|]  SHADE{COLOR = WHITE}



$!VARSET |FIRST_PROJECTED|=(|NUMZONES|+1)
$!READDATASET  '"|dir|/proj|orig_step|.dat" '
  READDATAOPTION = APPEND
  RESETSTYLE = NO
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D

$!VARSET |LAST_PROJECTED|=|NUMZONES|


$!ACTIVEFIELDMAPS += [|FIRST_PROJECTED|-|LAST_PROJECTED|]
$!FIELDMAP [|FIRST_PROJECTED|-|LAST_PROJECTED|]  EDGELAYER{COLOR = RED}
$!FIELDMAP [|FIRST_PROJECTED|-|LAST_PROJECTED|]  EDGELAYER{LINETHICKNESS = 0.02}
$!FIELDLAYERS USETRANSLUCENCY = NO
$!FIELDMAP [|FIRST_PROJECTED|-|LAST_PROJECTED|]  SHADE{COLOR = RED}
$!FIELDMAP [|FIRST_PROJECTED|-|LAST_PROJECTED|]  SHADE{COLOR = WHITE}


$!THREEDAXIS YDETAIL{SHOWAXIS = YES}
$!THREEDAXIS XDETAIL{SHOWAXIS = YES}
$!THREEDAXIS ZDETAIL{SHOWAXIS = YES}


$!VIEW FIT

$!IF |PNG|==1

        $!EXPORTSETUP EXPORTFORMAT = PNG
        $!EXPORTSETUP IMAGEWIDTH = 750
        $!EXPORTSETUP EXPORTFNAME = 'projection_check0.png'
        $!EXPORT
          EXPORTREGION = ALLFRAMES

$!ELSE

        $!EXPORTSETUP
          EXPORTREGION = ALLFRAMES
          EXPORTFORMAT = AVI
          EXPORTFNAME = "projection_check.avi"
        $!EXPORTSETUP IMAGEWIDTH = 750
        $!EXPORTSTART

$!ENDIF
$!VIEW FIT
$!REDRAWALL

$!LOOP 13

$!PROMPTFORYESNO |stop|
  INSTRUCTIONS "Bail out?"

$!IF "|stop|" == "YES"
  $!BREAK
$!ENDIF

$!VARSET |VAR|=(|LOOP|+3)

$!THREEDAXIS ZDETAIL{VARNUM = |VAR|}
$!VIEW FIT
$!REDRAWALL
         

$!IF |PNG|==1


        $!EXPORTSETUP EXPORTFORMAT = PNG
        $!EXPORTSETUP IMAGEWIDTH = 750
        $!EXPORTSETUP EXPORTFNAME = 'projection_check|LOOP|.png'
        $!EXPORT
          EXPORTREGION = ALLFRAMES

$!ELSE

        $!EXPORTNEXTFRAME

$!ENDIF


$!ENDLOOP


$!IF |PNG|==0
        $!EXPORTFINISH
$!ENDIF