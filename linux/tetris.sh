#!/bin/bash
# Tetris Game  // The Art Of Shell Programming

############################################################################################
#                                                                                          #
#   Author : YongYe <expertshell@gmail.com>                                                #
#   Version: 6.0 11/01/2011 BeiJing China [Updated 07/14/2012]                             #
#   License: GPLv3+                                                                        #
#   Latest Version:  https://github.com/yongye/shell                                       #
#   Download Link1:  http://bash.deta.in/Tetris_Game.sh                                    #
#   Download Link2:  http://bbs.chinaunix.net/thread-3614425-1-1.html                      #
#                                                                                          #
#                                                                         [][][]           #
#   Algorithm:  [][][]                                                [][][][]             #
#               []                  [][][]                      [][][]    [][]             #
#   [][] [][]   []  [][][][]  [][][][][]    [][]              [][][]      []   [][] [][]   #
#   [] row []   []  [] (x-m)*zoomx  [][]    []  cos(a) -sin(a)  [][]      []   []  m  []   #
#   []     [] = []  []              []   *  []                  []        [] + []     []   #
#   [] col []   []  [] (y-n)*zoomy  []      []  sin(a)  cos(a)  []        []   []  n  []   #
#   [][] [][]   []  [][][][]  [][][][]      [][]              [][]        []   [][] [][]   #
#               []                                                        []               #
#               [][][]                                                [][][]               #
#                                                                                          #
############################################################################################

box0=(4 30)
box1=(4 30 4 32)
box2=(4 30 5 32)
box3=(4 28 4 30 4 32)
box4=(4 28 4 30 5 30)
box5=(4 28 5 30 6 32)
box6=(4 30 5 28 5 32)
box7=(4 28 5 30 6 32 7 34)
box8=(4 30 5 28 5 30 5 32)
box9=(4 30 5 28 5 32 6 30)
box10=(4 28 4 30 4 32 4 34)
box11=(4 28 5 28 5 30 5 32)
box12=(4 28 4 30 5 30 5 32)
box13=(4 28 4 30 5 28 5 30)
box14=(4 28 4 34 5 30 5 32)
box15=(4 26 4 28 4 30 4 32 4 34)
box16=(4 30 5 28 5 30 5 32 6 30)
box17=(4 28 4 32 5 30 6 28 6 32)
box18=(4 28 4 32 5 28 5 30 5 32)
box19=(4 28 4 30 5 30 6 30 6 32)
box20=(4 28 5 28 6 28 6 30 6 32)
box21=(4 28 4 30 5 30 5 32 6 32)
box22=(4 26 4 34 5 28 5 30 5 32)
box23=(4 26 4 34 5 28 5 32 6 30)
box24=(4 26 5 28 6 30 7 32 8 34)
box25=(4 28 4 32 5 26 5 30 5 34)
box26=(4 28 4 34 5 30 5 32 6 30 6 32 7 28 7 34)
box27=(4 30 5 28 5 32 6 26 6 30 6 34 7 28 7 32 8 30)
box28=(4 30 5 28 5 30 5 32 6 26 6 28 6 30 6 32 6 34 7 28 7 30 7 32 8 30)
box29=(4 26 4 28 4 30 4 34 5 30 5 34 6 26 6 28 6 30 6 32 6 34 7 26 7 30 8 26 8 30 8 32 8 34)
box30=(4 30 5 28 6 26 6 34 7 28 7 32 7 36 8 22 8 30 8 38 9 24 9 28 9 32 10 26 10 34 11 32 12 30)

unit=[]
toph=3
modw=5
width=25
height=30
scorelevel=0
prelevel=${3:-6} 
speedlevel=${4:-0}
((hh=2*width+modw+6))
coltab=(1\;{30..37}\;{40..47}m)
((prelevel=prelevel<1?6:prelevel))
((speedlevel=speedlevel>30?0:speedlevel))

value(){ echo $?; }      
pause(){ kill -${1} ${pid}; }
limit(){ ((map[u/2-toph]=0)); }
initi(){ ((map[index]=(pam[index]=0))); }
check(){ (( map[index] == 0 )) && break; }
erase(){ printf "${oldpie//${unit}/  }\e[0m\n"; }
piece(){ eval box=(\${box$((RANDOM%runlevel))[@]}); }
resum(){ stty ${oldtty}; printf "\e[?25h\e[36;4H\n"; }
stime(){ (( ${1} == ${2} )) && { ((++${3})); ((${1}=0)); }; }
ptbox(){ oldpie="${cdn}"; printf "\e[${colpie}${cdn}\e[0m\n"; }
point(){ ((${1}=mid[${#mid[@]}/2])); ((${2}=mid[${#mid[@]}/2${3}1])); }

quit()
{
   case ${#} in
        0) printf "\e[?25h\e[36;26HGame Over!\e[0m\n" ;;
        1) pause 22
           resum ;;
        2) resum ;;
   esac
           exit
}

getrunlevel()
{
   local k
   k=${1:-31}
   ((runlevel=(k < 0 || k > 30)?31:k+1))
}

lowerside()
{
   local i row col
   for((i=0; i!=${#box[@]}; i+=2)); do
      (( col[box[i+1]] < box[i] )) && ((col[box[i+1]]=box[i]))
         row[box[i+1]]="${col[box[i+1]]} ${box[i+1]}"
   done
   echo ${row[@]}
}

update()
{ 
   local coor
   coor="\e[${i};${j}H"
   (( map[index] == 0 )) && printf "${coor}  " || printf "${coor}\e[${pam[index]}${unit}\e[0m"
}

replace()
{ 
   local uplink downlink
   ((downlink=(j-toph)*width+u/2-toph))
   ((uplink=(j-toph-1)*width+u/2-toph))
   ((map[downlink]=map[uplink]))
   eval pam[downlink]=\"${pam[uplink]}\"
}

loop()
{
   local i j index
   for((i=toph+1; i<=height+toph; ++i)); do
        for((j=modw+1; j<=2*(width-1)+modw+1; j+=2)); do
             ((index=(i-toph-1)*width+j/2-toph))
             ${1}
        done
        ${2}  
   done
}

cycle()
{
   local u 
   for((u=modw+1; u<=2*(width-1)+modw+1; u+=2)); do
        ${1} 
   done
}

mappiece()
{
   (( j <= 2*(width-1)+modw+1 )) && continue
   ((++line))
   for((j=i-1; j>=toph+1; --j)); do
        cycle replace
   done
        cycle limit
}

preview()
{
   local i vor clo
   vor=(${!1})
   for((i=0; i!=${#vor[@]}; i+=2)); do
        ((clo=vor[i+1]-(${3}-hh)))
        smobox+="\e[$((vor[i]-1));${clo}H${unit}"
   done
   printf "${!2//${unit}/  }\e[${!4}${smobox}\e[0m\n"
}

pipepiece()
{
   smobox=""
   (( ${5} != 0 )) && {
   piece
   eval ${1}="(${box[@]})"
   colpie="${coltab[RANDOM%${#coltab[@]}]}"
   eval ${6}=\"${colpie}\"
   preview box[@] ${3} ${4} colpie
   } || {
   eval ${1}="(${!2})"
   eval ${6}=\"${!7}\"
   preview ${2} ${3} ${4} ${7}
   }
   eval ${3}=\"${smobox}\"
}

invoke()
{
   local i arya aryb
   for((i=0; i!=prelevel-1; ++i)); do
        arya=(rpvbox$((i+1)) rpvbox$((i+2))[@] pvbox$((i+1)))
        aryb=($((12*(2-i))) ${1} s${arya[0]} srpvbox$((i+2))) 
        pipepiece ${arya[@]} ${aryb[@]} 
   done
}

showpiece()
{
   local smobox 
   colpie="${srpvbox1}"
   olbox=(${rpvbox1[@]})
   invoke ${#}
   smobox=""
   piece
   eval rpvbox${prelevel}="(${box[@]})"
   eval srpvbox${prelevel}=\"${coltab[RANDOM%${#coltab[@]}]}\"
   preview box[@] crsbox $(((3-prelevel)*12)) srpvbox${prelevel}
   crsbox="${smobox}"
   box=(${olbox[@]})
}

drawpiece()
{
   (( ${#} == 1 )) && {
      piece
      colpie="${coltab[RANDOM%${#coltab[@]}]}"
      coordinate box[@]
   } || {
   colpie="${srpvbox1}"
   coordinate rpvbox1[@]
   }
   ptbox 
   if ! movepiece; then
        kill -22 ${PPID}
        pause 22
        quit
   fi
}

bmob()
{
   local i x y u v 
   ((u=vor[0]))
   ((v=vor[1]))
   for((i=0; i!=${#vor[@]}; i+=2)); do
        if (( x <= vor[i] )); then 
           ((x=vor[i]))
           (( y < vor[i+1] )) && ((y=vor[i+1]))
        fi
        if (( u >= vor[i] )); then 
           ((u=vor[i]))
           (( v > vor[i+1] )) && ((v=vor[i+1]))
        fi
   done
   if (( x-u == 3 && y-v == 6 )); then
         vor=($((x-3)) $((y-6)) $((x-3)) ${y} ${x} $((y-6)) ${x} ${y})
   fi
}

bomb()
{
   local j p q scn vor sbos index boolp boolq
   sbos="\040\040"
   vor=(x-1 y-2 x-1 y x-1 y+2 x y-2 x y x y+2 x+1 y-2 x+1 y x+1 y+2)
   for((j=0; j!=${#vor[@]}; j+=2)); do
        ((p=vor[j]))
        ((q=vor[j+1]))
        ((index=(p-toph-1)*width+q/2-toph))
        boolp="p > toph && p <= height+toph"
        boolq="q <= 2*width+modw && q > modw"
        if (( boolp && boolq )); then
              scn+="\e[${p};${q}H${sbos}"
              initi 
        fi
   done
   sleep 0.03; printf "${scn}\n"
} 

delrow()
{
   local i x y len vor index line
   vor=(${locus[@]})
   len=${#vor[@]}
   (( len == 16 )) && bmob
   for((i=0; i!=${#vor[@]}; i+=2)); do
        ((x=vor[i]))
        ((y=vor[i+1]))
        (( len == 16 )) && bomb || {
           ((index=(x-toph-1)*width+y/2-toph))
           ((map[index]=1))
           pam[index]="${colpie}"
        }
   done
   line=0
   loop check mappiece
   (( line == 0 )) && return
   printf "\e[1;34m\e[$((toph+10));$((hh+36))H$((scorelevel+=line*200-100))\e[0m\n"
   (( scorelevel%5000 < line*200-100 && speedlevel < 20 )) && printf "\e[1;34m\e[$((toph+10));$((hh+24))H$((++speedlevel))\e[0m\n"
   loop update
}        

gettime()
{
   local i d h m s vir Time color
   trap "quit" 22 
   ((d=0, h=0, m=0, s=0))
   vir=----------------
   color="\e[1;33m"
   printf "\e[2;6H${color}${vir}[\e[2;39H${color}]${vir}\e[0m\n"
   while :; do
         sleep 1 &
         stime s 60 m
         stime m 60 h
         stime h 24 d
         for i in ${d} ${h} ${m} ${s}; do
             (( ${#i} != 2 )) && Time[i]="0${i}" || Time[i]="${i}"
         done    
         printf "\e[2;23H${color}Time ${Time[d]}:${Time[h]}:${Time[m]}:${Time[s]}\e[0m\n"
         wait; ((++s))
   done
}
 
persig()
{
   local i j pid sig sigswap
   pid=${1} 
   for i in {23..31}; do
       trap "sig=${i}" ${i}
   done
   trap "pause 22; quit" 22
   while :; do
         for ((j=0; j!=30-speedlevel; ++j)); do
              sleep 0.02
              sigswap=${sig}
              sig=0
              case ${sigswap} in
              23)  transform -1                   ;;
              24)  transform  1                   ;;
              25)  transform -2                   ;;
              26)  transform  1/2                 ;;
              27)  transform  0 -2                ;;
              28)  transform  0  2                ;;
              29)  transform  1  0                ;;
              30)  transform -1  0                ;;
              31)  transform $(value $(bottom)) 0 ;;
              esac
         done
         transform 1  0
   done
}

getsig()
{
   local sig pid key arry pool oldtty
   pid=${1}; arry=(0 0 0)
   pool="$(printf "\e")"; oldtty="$(stty -g)"
   trap "quit 0" INT TERM; trap "quit 0 0" 22
   printf "\e[?25l"
   while read -s -n 1 key; do
         arry[0]=${arry[1]}; arry[1]=${arry[2]}
         arry[2]=${key}; sig=0
         if   [[ "x${key}" == x ]]; then sig=31      
         elif [[ "${key}${arry[1]}" == "${pool}${pool}" ]]; then quit 0
         elif [[ "${arry[0]}" == "${pool}" && "${arry[1]}" == "[" ]]; then
                 case ${key} in
                 A)    sig=23     ;;
                 B)    sig=29     ;;
                 D)    sig=27     ;;
                 C)    sig=28     ;;
                 esac
         else
                 case ${key} in
                 W|w)  sig=23     ;;
                 T|t)  sig=24     ;;
                 M|m)  sig=25     ;;
                 N|n)  sig=26     ;;
                 S|s)  sig=29     ;;
                 A|a)  sig=27     ;;
                 D|d)  sig=28     ;; 
                 U|u)  sig=30     ;; 
                 P|p)  pause  19  ;;
                 R|r)  pause  18  ;;
                 Q|q)  quit   0   ;;
                 esac
         fi
                 (( sig != 0 )) && pause ${sig}
   done
}

bottom()
{  
   local i j max col row 
   max=($(lowerside))
   for((i=0; i!=height; ++i)); do
        for((j=0; j!=${#max[@]}; j+=2)); do 
             row="max[j]+i == height+toph"
             col="map[(max[j]+i-toph)*width+max[j+1]/2-toph] == 1"
             (( col || row )) && return ${i}
        done 
   done
}

movepiece()
{
   local i j x y index boolx booly 
   len=${#locus[@]}
   for((i=0; i!=len; i+=2)); do    
        ((x=locus[i]+dx)) 
        ((y=locus[i+1]+dy))
        ((index=(x-toph-1)*width+y/2-toph))
        (( index < 0 || index > 749 )) && return 1
        boolx="x <= toph || x > height+toph"
        booly="y > 2*width+modw || y <= modw"
        (( boolx || booly )) && return 1
        if (( map[index] == 1 )); then
              if (( len == 2 )); then
                    for((j=height+toph; j>x; --j)); do
                         (( map[(j-toph-1)*width+y/2-toph] == 0 )) && return 0
                    done
              fi
              return 1
        fi
   done 
   return 0  
}

cross()
{
   local i j index
   ((i=locus[0]))
   ((j=locus[1]))
   ((index=(i-toph-1)*width+j/2-toph))
   (( map[index] == 1 )) && printf "\e[${i};${j}H\e[${pam[index]}${unit}\e[0m\n"
}

coordinate()
{
   local i
   locus=(${!1})
   for((i=0; i!=${#locus[@]}; i+=2)); do    
        cdn+="\e[${locus[i]};${locus[i+1]}H${unit}"
   done
}

optimize()
{
   for j in dx dy; do
       if (( j != 0 )); then
             case ${j} in
                  dx) k=i   ;;
                  dy) k=i+1 ;;
             esac
             ${1}
       fi
   done
}

addbox()
{
   for((i=0; i!=${#vbox[@]}; i+=2)); do
        ((vbox[k]+=j))
   done
}

increment()
{
   local i j k
   (( len == 2 )) && cross
   vbox=(${box[@]})
   optimize addbox
   coordinate vbox[@]
   box=(${vbox[@]})
}

move()
{
   if movepiece; then
        erase
        increment
        ptbox
   else
        (( dx == 1 )) && {
        delrow  
        drawpiece 
        showpiece
        }
   fi
}

midpoint()
{
   local mid
   mid=(${!1})
   (( ${#mid[@]}%4 == 0 )) && point ${2} ${3} + || point ${3} ${2} -
}

multiple()
{
   local i mid vor
   mid=(${!1})
   vor=(${!1})
   for((i=0; i!=${#mid[@]}-2; i+=2)); do
        ((mid[i+3]=mid[i+1]+(vor[i+3]-vor[i+1])${2}2))
   done
   vbox=(${mid[@]})
}

algorithm()
{
   local i                              # row=(x-m)*zoomx*cos(a)-(y-n)*zoomy*sin(a)+m
   for((i=0; i!=${#vbox[@]}; i+=2)); do # col=(x-m)*zoomx*sin(a)+(y-n)*zoomy*cos(a)+n
        ((mox[i]=m+vbox[i+1]-n))        # a=-pi/2 zoomx=+1 zoomy=+1 dx=0 dy=0
        ((mox[i+1]=(vbox[i]-m)*dx+n))   # a=-pi/2 zoomx=-1 zoomy=+1 dx=0 dy=0 
   done                                 # a=+pi/2 zoomx=+1 zoomy=-1 dx=0 dy=0
}

midplus()
{
   local i j k dx dy
   ((dx=mp-p))
   ((dy=nq-q))
   optimize addbox
}

abstract()
{
   multiple ${1} "${2}"
   midpoint vbox[@] ${3} ${4} 
}

rotate()
{     
   local m n p q mp nq mox
   (( arg == 2 )) && return
   midpoint box[@] mp nq 
   abstract box[@] "/" m n
   algorithm; dx=0
   abstract mox[@] "*" p q
   midplus; locus=(${vbox[@]})
   if movepiece; then
       erase; coordinate vbox[@]
       ptbox; box=(${locus[@]})
   else
       locus=(${box[@]})
   fi
}

transform()
{ 
   local dx dy cdn len arg vbox 
   dx=${1}
   dy=${2}
   arg=${#}
   (( arg == 2 )) && move || rotate 
}

matrix()
{
   one=" "
   sr="\e[0m"
   trx="[][]"
   two="${one}${one}"
   tre="${one}${two}"
   cps="${two}${tre}"
   spc="${cps}${cps}"         
   colbon="\e[1;36m"
   mcol="\e[1;33;40m"
   fk5="${spc}${spc}"
   fk4="${mcol}[]${sr}"
   fk0="${colbon}[]${sr}"
   fk1="${colbon}${trx}${sr}"
   fk6="${mcol}[]${trx}${sr}"
   fk2="${colbon}[]${trx}${sr}"
   fk3="${colbon}${trx}${trx}${sr}"
   fk="${tre}${fk0}${two}${fk3}${two}${fk3}"
   fk7="${fk1}${one}${fk1}${fk}${fk4}${two}${two}"
   fk8="${fk0}${one}row${one}${fk0}${tre}${fk0}${two}${fk0}${one}(x-m)*zoomx${two}"
   fk9="${one}=${one}${fk0}${two}${fk0}${spc}${tre}${one}${fk0}${tre}*${two}"
   fk10="${spc}${cps}${two}${fk0}${two}${fk0}${one}+${one}${fk0}${cps}${fk0}"
   fk11="${tre}${one}${fk0}${two}cos(a)${one}sin(a)${two}${fk0}${two}${fk0}${tre}${fk0}${two}m${two}${fk0}"
   fk12="${one}col${one}${fk0}${tre}${fk0}${two}${fk0}${one}(y-n)*zoomy${two}${fk0}${cps}${one}"
   fk13="${one}-sin(a)${one}cos(a)${two}${fk0}${two}${fk0}${tre}${fk0}${two}n${two}${fk0}"
   fk14="${fk1}${one}${fk1}${fk}${cps}${one}"
   fk15="${fk1}${two}${fk0}${tre}${fk1}${one}${fk1}"
   printf "\e[$((toph+23));${hh}H${colbon}Algorithm:${two}${fk2}${one}${fk5}${fk5}${fk2}${fk4}\n"
   printf "\e[$((toph+30));${hh}H${spc}${two}${fk0}${two}${two}${cps}${fk5}${fk5}${fk0}\n"
   printf "\e[$((toph+25));${hh}H${fk7}${fk1}${spc}${tre}${fk1}${two}${fk0}${tre}${fk1}${one}${fk1}\n"
   printf "\e[$((toph+26));${hh}H${fk8}${fk0}${fk4}${fk11}\e[$((toph+28));${hh}H${fk0}${fk12}${fk0}${fk13}\n"
   printf "\e[$((toph+24));${hh}H${two}${spc}${fk0}${spc}${tre}${two}${tre}${fk6}${fk5}${cps}${fk0}${fk4}\n"
   printf "\e[$((toph+22));${hh}H${tre}${fk5}${fk5}${fk5}${fk6}\e[$((toph+29));${hh}H${fk14}${fk1}${spc}${tre}${fk15}\n"
   printf "\e[$((toph+27));${hh}H${fk0}${cps}${fk0}${fk9}${fk0}${fk10}\e[$((toph+31));${hh}H${spc}${two}${fk2}${fk5}${fk5} ${fk2}\n"
}

boundary()
{
   clear
   boucol="\e[1;36m"
   for((i=modw+1; i<=2*width+modw; i+=2)); do
        printf "${boucol}\e[${toph};${i}H==\e[$((height+toph+1));${i}H==\e[0m\n"
   done
   for((i=toph; i<=height+toph+1; ++i)); do
        printf "${boucol}\e[${i};$((modw-1))H||\e[${i};$((2*width+modw+1))H||\e[0m\n"
   done
}

instruction()
{
   printf "\e[1;31m\e[$((toph+9));${hh}HRunLevel\e[1;31m\e[$((toph+9));$((hh+10))HPreviewLevel\e[0m\n"
   printf "\e[1;31m\e[$((toph+9));$((hh+24))HSpeedLevel\e[1;31m\e[$((toph+9));$((hh+36))HScoreLevel\e[0m\n"
   printf "\e[1;34m\e[$((toph+10));$((hh+36))H${scorelevel}\e[1;34m\e[$((toph+10));$((hh+24))H${speedlevel}\e[0m\n"
   printf "\e[1;34m\e[$((toph+10));${hh}H$((runlevel-1))\e[1;34m\e[$((toph+10));$((hh+10))H${prelevel}\e[0m\n"
   printf "\e[$((toph+12));${hh}HM|m      ===   double         N|n          ===   half\n"
   printf "\e[$((toph+13));${hh}HQ|q|ESC  ===   exit           U|u          ===   one step up\n"
   printf "\e[$((toph+14));${hh}HP|p      ===   pause          S|s|down     ===   one step down\n"
   printf "\e[$((toph+15));${hh}HR|r      ===   resume         A|a|left     ===   one step left\n"
   printf "\e[$((toph+16));${hh}HW|w|up   ===   rotate         D|d|right    ===   one step right\n"
   printf "\e[$((toph+17));${hh}HT|t      ===   transpose      Space|enter  ===   drop all down\n"
   printf "\e[1;36m\e[$((toph+19));${hh}HTetris Game  Version 6.0\n"
   printf "\e[$((toph+20));${hh}HYongYe <expertshell@gmail.com>\e[$((toph+21));${hh}H11/01/2011 BeiJing China [Updated 07/14/2012]\n"
}

   case ${1} in
   -h|--help)    echo "Usage: bash ${0} [runlevel] [previewlevel] [speedlevel]"
                 echo "Range: [ 0 =< runlevel <= 30 ]   [ previewlevel >= 1 ]   [ speedlevel <= 30 ]" ;;
   -v|--version) echo "Tetris Game  Version 6.0 [Updated 07/14/2012]" ;;
   ${PPID})      getrunlevel ${2}; loop initi 
                 boundary; instruction
                 showpiece 0; drawpiece 0
                 matrix; gettime &
                 persig ${!} ;;
   *)            bash ${0} ${$} ${1} ${2} ${3} &
                 getsig ${!} ;;
   esac
