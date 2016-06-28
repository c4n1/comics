#!/bin/bash


<<README
This script was made purely so I can view a load of webcomics in one place within my own network
If someone is using this on the open internet then it's not the original author and they should
probably stop as the end result has no links back to the content creators.

The only reason this has a license is in case someone trys to blame me for it breaking shit :P
I mean it shouldn't break shit but it might so if it does then it's not my fault.  

comic_creator@ellie-oli.com

Copyright 2016 Oliver V Hills 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
README

#Setting some vars for data locations these will work on my servers but not yours so change shit if you need
#Note no trailing slash
HOSTNAME=`hostname`
if [[ "$HOSTNAME" = *oli02* ]];then
  BASEDIR="/home/oli/Site_Build"
elif [[ "$HOSTNAME" = magic ]];then
  BASEDIR="/var/wwwcomic"
elif [[ "$HOSTNAME" = *ovh01* ]];then
  BASEDIR="/var/www/html/comics.ellie-oli.com"
else 
  BASEDIR=`pwd`
  echo "Using working directory as base"
fi



function 404test {
  SITE=$1  
  curl -f $SITE >/dev/null 2>&1
  OUT=$?
  if  [ $OUT -eq 0 ];then
    echo "found $SITE"
    return 0
  else
    echo "not found $SITE"
    return 1
  fi
}


#Order of the Stick 

#Gets the URL of the image from the page
function ootsgetimgurl {
  NUMBER=$1
  COMIC=$(curl -s www.giantitp.com/comics/oots$NUMBER.html |grep $NUMBER |grep png |cut -d'"' -f4)
  COMIC=http://www.giantitp.com$COMIC
  echo $COMIC
}

OOTSCURRENT=`cat $BASEDIR/saved_data/oots`
OOTSNEW=$((OOTSCURRENT + 1))
OOTSURL=http://www.giantitp.com/comics/oots$OOTSNEW.html
if 404test $OOTSURL;then
  OOTSIMGURL=`ootsgetimgurl $OOTSNEW`
  wget -O $BASEDIR/images/oots.png $OOTSIMGURL >/dev/null 2>&1
  echo $OOTSNEW > $BASEDIR/saved_data/oots
fi



#Looking for Group
LFGOLD=`cat $BASEDIR/saved_data/lfg`
LFGNEWNUM=$(($LFGOLD +1))
LFGNEW="http://www.lfg.co/page/$LFGNEWNUM/"
if 404test $LFGNEW;then
  echo $LFGNEWNUM > $BASEDIR/saved_data/lfg
  LFGIMG=`curl -s $LFGNEW |grep -A1 '<div id="comic">' |tail -n1 |cut -d'"' -f2`
  LFGIMGTYPE=`echo $LFGIMG |cut -d'.' -f4`
  rm -f $BASEDIR/images/lfg*
  wget -O $BASEDIR/images/lfg.$LFGIMGTYPE $LFGIMG >/dev/null 2>&1
fi
  


#XKCD
curl -s xkcd.com > /tmp/xkcd.html
XKCDIMG=`cat /tmp/xkcd.html |grep -A 1 'id="comic"' |tail -n1 |cut -d'"' -f2 |cut -c 3- `
XKCDTITLE=`cat /tmp/xkcd.html |grep title |grep xkcd |head -n1 |cut -d":" -f2 |cut -c2- |cut -d"<" -f1`
XKCDMO=`cat /tmp/xkcd.html |grep title |grep xkcd |cut -d'"' -f4`
XKCDOLDTITLE=`cat $BASEDIR/saved_data/xkcd`
if [ "$XKCDOLDTITLE" == "$XKCDTITLE" ];then
  echo "XKCD Same"
else
  echo $XKCDTITLE > $BASEDIR/saved_data/xkcd
  wget -O $BASEDIR/images/xkcd.png $XKCDIMG >/dev/null 2>&1
fi


#Dilbert
DILBERTIMG=`curl -s http://dilbert.com/ |grep amuniversal |head -n 1 |cut -d'"' -f16`
DILBERTOLD=`cat $BASEDIR/saved_data/dilbert`
if [ "$DILBERTOLD" == "$DILBERTIMG" ];then
  echo "Dilbert Same"
else
  echo $DILBERTIMG > $BASEDIR/saved_data/dilbert
  wget -O $BASEDIR/images/dilbert.gif $DILBERTIMG >/dev/null 2>&1
fi


#SATW
SATWIMG=`curl -s http://satwcomic.com/the-world |grep -A 9 "1 of" |head -n 10 |tail -n 1 |cut -d'"' -f 4 |sed 's,150_thumb/,,g'`
SATWOLD=`cat $BASEDIR/saved_data/satw`
if [ "$SATWOLD" == "$SATWIMG" ];then
  echo "SATW Same"
else
  echo $SATWIMG > $BASEDIR/saved_data/satw
  wget -O $BASEDIR/images/satw.png $SATWIMG >/dev/null 2>&1
fi


#Dungeon Running
DRIMG=`curl -s http://www.dungeonrunning.com/ |grep png |head -n5 |tail -n1 |cut -d'"' -f2`
DROLD=`cat $BASEDIR/saved_data/dr`
if [ "$DRIMG" == "$DROLD" ];then
  echo "DR Same"
else
  echo $DRIMG > $BASEDIR/saved_data/dr
  wget -O $BASEDIR/images/dr.png $DRIMG >/dev/null 2>&1
fi



#D20 Monkey
D2IMGOLD=`cat $BASEDIR/saved_data/d2`
D2IMG=`curl -s http://www.d20monkey.com/ |grep jpg |sed '2q;d' |cut -d'"' -f2`
D2MO=`curl -s http://www.d20monkey.com/ |grep jpg |sed '2q;d' |cut -d'"' -f4`
if [ "$D2IMG" == "$D2IMGOLD" ];then
  echo "D20 Monkey Same"
else
  echo $D2IMG >$BASEDIR/saved_data/d2
  wget -O $BASEDIR/images/d2.jpg $D2IMG >/dev/null 2>&1
fi



#Penny Arcade
curl -s https://www.penny-arcade.com/comic >/tmp/pa.html
PAOLD=`cat $BASEDIR/saved_data/pa`
PANEW=`cat /tmp/pa.html |grep "Pa-comics" |cut -d'"' -f4`
PAWIDTH=`cat /tmp/pa.html |grep "Pa-comics" |cut -d'"' -f8`
if [ "$PANEW" == "$PAOLD" ];then
  echo "PA Same"
else
  echo $PANEW >$BASEDIR/saved_data/pa
  #wget -O $BASEDIR/images/pa.jpg $PANEW >/dev/null 2>&1
  #images/pa.jpg $PANEW >/dev/null 2>&1
  curl -o $BASEDIR/images/pa.jpg $PANEW >/dev/null 2>&1
fi


#Oglaf
OGLAFOLD=`cat $BASEDIR/saved_data/oglaf`
OGLAFNEW=`curl -s http://oglaf.com/ |head -n 1 |rev |cut -d '"' -f 2 |rev`
if [ "$OGLAFNEW" == "$OGLAFOLD" ];then
  echo "Oglaf Same"
else
  echo $OGLAFNEW >$BASEDIR/saved_data/oglaf
  wget -O $BASEDIR/images/oglaf.jpg $OGLAFNEW >/dev/null 2>&1
fi



#QC
QCOLD=`cat $BASEDIR/saved_data/qc`
QCNEW=`curl -s http://www.questionablecontent.net/ |grep comics |cut -d'"' -f2`
if [ "$QCNEW" == "$QCOLD" ];then
  echo "QC Same"
else
  echo $QCNEW >$BASEDIR/saved_data/qc
  wget -O $BASEDIR/images/qc.png $QCNEW >/dev/null 2>&1
fi



#Manly Guys Doing Manly Things
MGMTOLD=`cat $BASEDIR/saved_data/mgmt`
MGMTNEW=`curl -s http://thepunchlineismachismo.com/ |grep -A2 comic-table |tail -n1 |cut -d'"' -f2`
if [ "$MGMTOLD" == "$MGMTNEW" ];then
  echo "MGMT Same"
else
  echo $MGMTNEW >$BASEDIR/saved_data/mgmt
  wget -O $BASEDIR/images/mgmt.jpg $MGMTNEW >/dev/null 2>&1
fi



#MA3
MA3OLD=`cat $BASEDIR/saved_data/ma3`
MA3NEW=`curl -s -L http://www.ma3comic.com |grep 'http://zii.ma3comic.com/comics/' |cut -d'"' -f2`
if [ "$MA3OLD" == "$MA3NEW" ];then
  echo "MA3 Same"
else
  echo $MA3NEW >$BASEDIR/saved_data/ma3
  wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0' -O $BASEDIR/images/ma3.png $MA3NEW >/dev/null 2>&1
fi


#Misfile
MFOLD=`cat $BASEDIR/saved_data/mf`
MFNEW=`curl -s http://www.misfile.com/ |grep 'comics' |head -n1| cut -d\' -f6 | sed 's,^,http://www.misfile.com/,'`
if [ "$MFOLD" == "$MFNEW" ];then
  echo "Misfile Same"
else
  echo $MFNEW >$BASEDIR/saved_data/mf
  wget -O $BASEDIR/images/mf.jpg $MFNEW >/dev/null 2>&1
fi



#Cyanide and Happiness
CHOLD=`cat $BASEDIR/saved_data/ch`
CHNEW=`curl -s http://explosm.net/ |grep 'files.explosm.net/comics' |cut -d'"' -f6 |cut -d'?' -f1 |sed 's/^..//' |sed 's/^/http:\/\//'`
if [ "$CHOLD" == "$CHNEW" ];then
  echo "Cyanide Same"
else
  echo $CHNEW >$BASEDIR/saved_data/ch
  wget -O $BASEDIR/images/ch.png $CHNEW >/dev/null 2>&1
fi



#The Oatmeal
OMOLD=`cat $BASEDIR/saved_data/om`
OMNEW=`curl -s http://theoatmeal.com/comics |grep -A1 bg_comic |head -n2 |cut -d'"' -f2 |tail -n 1 |sed 's/^/http:\/\/theoatmeal.com/'`
if [ "$OMOLD" == "$OMNEW" ];then
  echo "Oatmeal Same"
else
  echo $OMNEW >$BASEDIR/saved_data/om
  curl -s $OMNEW |grep 'theoatmeal-img/comics' | grep panel > /dev/null
  rm -Rf tmp_images
  mkdir tmp_images
  if [ $? -eq 0 ]; then
    #This is a single panel comic (e.g. http://theoatmeal.com/comics/dog_speeds)
    wget -O tmp_images/0.png `curl -s $OMNEW |grep -A13 meat |tail -n 1 |cut -d'"' -f4`
  else
    #This is a multi panel comic (e.g. http://theoatmeal.com/comics/dogs_as_men2)
    i=0
    curl -s $OMNEW |grep 'theoatmeal-img/comics' | cut -d'"' -f2 | while read img_url; do 
      wget -O tmp_images/$i.png $img_url
      i=$((i+1))
    done
  fi
  convert -gravity center -append `find tmp_images -type f | sort -n` $BASEDIR/images/om.png
fi



#SMBC
SMBCOLD=`cat $BASEDIR/saved_data/smbc`
SMBCNEW=`curl -s http://www.smbc-comics.com/ |grep 'comics/../comics/' |head -n 1 |sed 's/^.*src/src/' |cut -d'"' -f2 |sed 's/^/http:\/\/www.smbc-comics.com\//'`
if [ "$SMBCOLD" == "$SMBCNEW" ];then
  echo "SMBC Same"
else
  echo $SMBCNEW >$BASEDIR/saved_data/smbc
  wget -O $BASEDIR/images/smbc.png $SMBCNEW >/dev/null 2>&1
fi



#Dark Legacy
DLCURRENT=`cat $BASEDIR/saved_data/dl`
DLNEW=$((DLCURRENT + 1))
DLURL="http://darklegacycomics.com/comics/$DLNEW.jpg"
if 404test $DLURL;then
  wget -O $BASEDIR/images/dl.jpg $DLURL >/dev/null 2>&1
  echo $DLNEW > $BASEDIR/saved_data/dl
fi



#Diesel Sweeties
DSOLD=`cat $BASEDIR/saved_data/ds`
DSNEW=`curl -s http://www.dieselsweeties.com/ |grep xomic |head -n1 |sed 's/^.*src=//' |cut -d'"' -f2 |sed 's/^/http:\/\/www.dieselsweeties.com/'`
if [ "$DSOLD" == "$DSNEW" ];then
  echo "Diesel Sweeties Same"
else
  echo $DSNEW >$BASEDIR/saved_data/ds
  wget -O $BASEDIR/images/ds.png $DSNEW >/dev/null 2>&1
fi



#PHD Comics
PHDOLD=`cat $BASEDIR/saved_data/phd`
PHDNEW=`curl -s -A "Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0" http://phdcomics.com/comics.php |grep '/comics/archive/' |head -n1 |cut -d'"' -f4`
if [ "$PHDOLD" == "$PHDNEW" ];then
  echo "PHD Same"
else
  echo $PHDNEW >$BASEDIR/saved_data/phd
  wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0' -O $BASEDIR/images/phd.gif $PHDNEW >/dev/null 2>&1
fi



#Commit Strip
CSOLD=`cat $BASEDIR/saved_data/cs`
CSNEW=`curl -s http://www.commitstrip.com/en/? |grep og:url |cut -d'"' -f4 |xargs curl -s |grep -A1 '"entry-content' |tail -n1 |cut -d'"' -f2`
if [ "$CSOLD" == "$CSNEW" ];then
  echo "Commit Strip Same"
else
  echo $CSNEW >$BASEDIR/saved_data/cs
  wget -O $BASEDIR/images/cs.jpg $CSNEW >/dev/null 2>&1
fi



#User Friendly
UFOLD=`cat $BASEDIR/saved_data/uf`
UFNEW=`curl -s http://www.userfriendly.org/ |grep 'Latest Strip' |cut -d'"' -f10`
if [ "$UFOLD" == "$UFNEW" ];then
  echo "User FriendlySame"
else
  echo $UFNEW >$BASEDIR/saved_data/uf
  wget -O $BASEDIR/images/uf.gif $UFNEW >/dev/null 2>&1
fi




#By The Book
BTBOLD=`cat $BASEDIR/saved_data/btb`
BTBNEW=`curl -s http://www.btbcomic.com/ |grep -A1 'id="comic"' |tail -n1 |cut -d'"' -f2`
if [ "$BTBOLD" == "$BTBNEW" ];then
  echo "By The Book"
else
  echo $BTBNEW >$BASEDIR/saved_data/btb
  wget -O $BASEDIR/images/btb.jpg $BTBNEW >/dev/null 2>&1
fi





EXPIRETIME=`date --date="14 minutes" +%a," "%d" "%b" "%Y" "%H:%M:%S" "%Z`


echo '
<html>
<body>
<Title>Comics Page</Title>


<meta http-equiv="cache-control" content="no-cache, must-revalidate, post-check=0, pre-check=0">
<meta http-equiv="expires" content="'$EXPIRETIME'">
<meta http-equiv="pragma" content="no-cache">

<head>
<style>

img.resize90{
   max-width:90%;
}

</style>
</head>


<font size="6">

' >$BASEDIR/index.html


for image in $( ls -t $BASEDIR/images);do
  
  if [ "$image" == "d2.jpg" ];then
    echo '

    D20 Monkey
    <br>
    <img src="images/d2.jpg">
    <font size="2">'$D2MO'</font>
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "dilbert.gif" ];then
      echo '

    Dilbert
    <br>
    <img src="images/dilbert.gif">
    <br><br><br>


    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "dr.png" ];then
    echo '

    Dungeon Running
    <br>
    <img class="resize90" src="images/dr.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi
  
  if [[ "$image" == *"lfg"* ]];then
    echo '

    Looking For Group
    <br>
    <img src="images/'$image'">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi
  
  if [ "$image" == "oglaf.jpg" ];then
    echo '

    Oglaf
    <br>
    <img src="images/oglaf.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html 
 fi
  
  if [ "$image" == "oots.png" ];then
    echo '

    The Order of The Stick
    <br>
    <img src="images/oots.png">
    <br><br><br>


    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "pa.jpg" ];then
    echo '

    Penny Arcade
    <br>
    <img src="images/pa.jpg" width="'$PAWIDTH'">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "qc.png" ];then
    echo '

    Questionable Content
    <br>
    <img src="images/qc.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "satw.png" ];then
    echo '

    Scandinavia and the World
    <br>
    <img src="images/satw.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
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

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "mgmt.jpg" ];then
    echo '

    Manly Guys Doing Manly Things
    <br>
    <img src="images/mgmt.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "ma3.png" ];then
    echo '

    Menage a 3
    <br>
    <img src="images/ma3.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "mf.jpg" ];then
    echo '

    Misfile
    <br>
    <img src="images/mf.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "ch.png" ];then
    echo '

    Cyanide & Happiness
    <br>
    <img src="images/ch.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "om.png" ];then
    echo '

    The Oatmeal
    <br>
    <img src="images/om.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "smbc.png" ];then
    echo '

    SMBC
    <br>
    <img src="images/smbc.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "dl.jpg" ];then
    echo '

    Dark Legacy
    <br>
    <img src="images/dl.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "ds.png" ];then
    echo '

    Diesel Sweeties
    <br>
    <img class="resize90" src="images/ds.png">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "phd.gif" ];then
    echo '

    PHD Comics
    <br>
    <img src="images/phd.gif">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "cs.jpg" ];then
    echo '

    Commit Strip
    <br>
    <img src="images/cs.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "uf.gif" ];then
    echo '

    User Friendly
    <br>
    <img src="images/uf.gif">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi

  if [ "$image" == "btb.jpg" ];then
    echo '

    By The Book
    <br>
    <img src="images/btb.jpg">
    <br><br><br>

    ' >>$BASEDIR/index.html
  fi





done

echo '
</font>


</body>
</html>
'>>$BASEDIR/index.html
