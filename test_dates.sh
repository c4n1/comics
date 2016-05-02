
echo '
<html>
<body>
<Title>Comics Page</Title>


<meta http-equiv="cache-control" content="no-cache, must-revalidate, post-check=0, pre-check=0">
<meta http-equiv="expires" content="'$EXPIRETIME'">
<meta http-equiv="pragma" content="no-cache">


<font size="6">

' >index.html


for image in $( ls -t images);do
  
  if [ "$image" == "d2.jpg" ];then
    echo '

    D20 Monkey
    <br>
    <img src="images/d2.jpg">
    <font size="2">'$D2MO'</font>
    <br><br><br>

    ' >>index.html
  fi

  if [ "$image" == "dilbert.jpg" ];then
      echo '

    Dilbert
    <br>
    <img src="images/dilbert.gif">
    <br><br><br>


    ' >>index.html
  fi

  if [ "$image" == "dr.png" ];then
    echo '

    Dungeon Running
    <br>
    <img src="images/dr.png">
    <br><br><br>

    ' >>index.html
  fi
  
  if [ "$image" == "lfg.jpg" ];then
    echo '

    Looking For Group
    <br>
    <img src="images/lfg.jpg">
    <br><br><br>

    ' >>index.html
  fi
  
  if [ "$image" == "oglaf.jpg" ];then
    echo '

    Oglaf
    <br>
    <img src="images/oglaf.jpg">
    <br><br><br>

    ' >>index.html 
 fi
  
  if [ "$image" == "oots.png" ];then
    echo '

    The Order of The Stick
    <br>
    <img src="images/oots.png">
    <br><br><br>


    ' >>index.html
  fi

  if [ "$image" == "pa.jpg" ];then
    echo '

    Penny Arcade
    <br>
    <img src="images/pa.jpg" width="'$PAWIDTH'">
    <br><br><br>

    ' >>index.html
  fi

  if [ "$image" == "qc.png" ];then
    echo '

    Questionable Content
    <br>
    <img src="images/qc.png">
    <br><br><br>

    ' >>index.html
  fi

  if [ "$image" == "satw.png" ];then
    echo '

    Scandinavia and the World
    <br>
    <img src="images/satw.png">
    <br><br><br>

    ' >>index.html
  fi

  if [ "$image" == "xkcd.png" ];then
    echo '

    XKCD
    <br>
    <font size="2">
    '$XKCDTITLE'
    <br>
    <img src="images/xkcd.png">
    <br>
    '$XKCDMO'
    </font>
    <br><br><br>

    ' >>index.html
  fi

done

echo '
</font>


</body>
</html>
'>index.html
