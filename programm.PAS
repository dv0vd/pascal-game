uses
   graph,
   dos,
   crt;

type
   mas=array [1..30] of integer;


const
   detect=0;
   enter=#13;
   y1=#121;
   y2=#89;
   n1=#78;
   n2=#110;
   up=#72;
   upw1=#87;
   upw2=#119;
   down=#80;
   right1=#68;
   right2=#100;
   left1=#65;
   left2=#97;
   esc=#27;
   backspace=#8;


var
   gd,gm,errorcode,prov,scores:integer;
   key:char;
   name:string;
   negative_count,positive_count,c:byte;
   score_mas,coord_mas_x,coord_mas_y:mas;


procedure
   greeting;
      begin
         setbkcolor(green);
         setcolor(yellow);
         settextstyle(0,0,10);
         outtextxy(50,50,'КОЛОБОК');
         setcolor(white);
         settextstyle(7,0,4);
         outtextxy(70,200,'Здравствуй,дорогой друг!');
         outtextxy(20,250,'Готов к новым приключениям?');
         outtextxy(70,300,'Если да - жми ENTER!');
         outtextxy(5,350,'Иначе - любую другую клавишу');
      end;


procedure
   exitt;
      begin
         setfillstyle(1,8);
         bar(50,150,600,400);
         setcolor(white);
         settextstyle(0,0,2);
         outtextxy(95,175,'Вы уверены, что хотите выйти?');
         setfillstyle(1,white);
         bar(60,330,200,390);
         bar(450,330,590,390);
         setcolor(0);
         settextstyle(0,0,6);
         outtextxy(105,335,'Y');
         outtextxy(505,335,'N');
         setcolor(yellow);
         outtextxy(95,270,'Да');
         outtextxy(460,270,'Нет');
      end;


procedure
   kolobok(const y:word);
      begin
         setcolor(yellow);
         circle(180,y,40);
         setfillstyle(1,yellow);
         floodfill(180,y,yellow);
      end;



procedure
   negative_obstacle(const x:integer; const y:integer; const left:integer; const right:integer);
      var
         paint_x:integer;
         k:real;
      begin
         setfillstyle(1,red);
         setcolor(red);
         k:=((x-left)/(right-left))*640;
         paint_x:=round(k);
         circle(paint_x,y,10);
         floodfill(paint_x,y,red);
      end;



procedure
   positive_obstacle(const x:integer; const y:integer; const left:integer; const right:integer);
      var
      paint_x:integer;
      k:real;
      begin
      setcolor(yellow);
         setfillstyle(1,yellow);
         k:=((x-left)/(right-left))*640;
         paint_x:=round(k);
         circle(paint_x,y,10);
         floodfill(paint_x,y,yellow);
      end;


procedure
   wallpaper(const d:byte);
      begin
         setcolor(blue);
         setfillstyle(1,blue);
         bar(0,0,650,400);
         floodfill(5,100,blue);
         settextstyle(7,0,4);
         setcolor(white);
         outtextxy(10,10,'Скорость');
         outtextxy(450,10,'Прыжок');
         outtextxy(520,50,'W');
         outtextxy(170,50,'A');
         outtextxy(310,50,'D');
         line(200,30,300,30);
         case d of
            0:
               begin
                  setcolor(red);
                  line(200,0,200,60);
                  setcolor(blue);
                  line(250,0,250,60);
                  line(300,0,300,60);
               end;
            1:
               begin
                  setcolor(red);
                  line(250,0,250,60);
                  setcolor(blue);
                  line(200,0,200,60);
                  line(300,0,300,60);
               end;
            2:
               begin
                  setcolor(red);
                  line(300,0,300,60);
                  setcolor(blue);
                  line(250,0,250,60);
                  line(200,0,200,60);
               end;
         end;
      end;


procedure
   game;
      var
        d,t,x:byte;
        coord_x,w,y,i,j:integer;
        hr,wr:real;
        h:longint;
      begin
        coord_x:=30;
        setlinestyle(0,0,3);
        line(0,400,700,400);
        setfillstyle(1,green);
        floodfill(5,410,blue);
        d:=0;
        x:=0;
        t:=0;
        i:=1;
        y:=359;
        scores:=0;
        repeat
           wallpaper(d);
           if (x=1)
              then
                 if ((y>219) and (t=0))
                    then
                       y:=y-10
                    else
                       if (y<359)
                          then
                             begin
                                t:=1;
                                y:=y+10;
                             end
                          else
                             if (y>=359)
                                then
                                   begin
                                      x:=0;
                                      t:=0;
                                   end;
           kolobok(y);
           for i:=1 to negative_count+positive_count do
              begin
                 if (((coord_x-20)<coord_mas_x[i]) and ((coord_x+150)>coord_mas_x[i]))
                    then
                       begin
                          if score_mas[i]=1
                             then
                                positive_obstacle(coord_mas_x[i],coord_mas_y[i],coord_x-20,coord_x+150);
                          if score_mas[i]=-1
                             then
                                negative_obstacle(coord_mas_x[i],coord_mas_y[i],coord_x-20,coord_x+150);
                          h:=coord_mas_x[i]-coord_x-25;
                          hr:=h;
                          w:=(coord_mas_y[i]-y);
                          wr:=w;
                          if ((hr*hr*36+wr*wr)<=2500)
                             then
                                begin
                                   if (score_mas[i]=1)
                                      then
                                         scores:=scores+1
                                   else
                                      if (score_mas[i]=-1)
                                         then
                                            scores:=scores-1;
                                   score_mas[i]:=0;
                                end;
                       end;
              end;
              coord_x:=coord_x+3;
              case d of
                 0:
                    delay(350);
                 1:
                    delay(250);
                 2:
                    delay(150);
              end;
              while (keypressed) do
                 begin
                    key:=readkey;
                    if ((key=right1) or (key=right2))
                       then
                          case d of
                             0:
                                d:=1;
                             1:
                                d:=2;
                          end
                    else
                       if ((key=left1) or (key=left2))
                          then
                             case d of
                                1:
                                   d:=0;
                                2:
                                   d:=1;
                             end
                       else
                          if ((key=upw1) or (key=upw2))
                             then
                                x:=1;
               end;
        until (coord_x>prov);
      end;


procedure
   output_data;
      var
         h,m,s,hund,k:word;
         temp,strin:string;
         i:byte;
         f,f_temp:text;
      begin
         c:=0;
         if (scores<0)
            then
               scores:=0;
         setfillstyle(1,8);
         bar(50,150,600,400);
         setcolor(white);
         settextstyle(0,0,2);
         outtextxy(150,175,'Ваш счёт:');
         str(scores,temp);
         outtextxy(300,175,temp);
         outtextxy(150,200,'Сохранить результаты?');
         setfillstyle(1,white);
         bar(60,330,200,390);
         bar(450,330,590,390);
         setcolor(green);
         settextstyle(0,0,6);
         outtextxy(105,335,'Y');
         outtextxy(505,335,'N');
         setcolor(yellow);
         outtextxy(95,270,'Да');
         outtextxy(460,270,'Нет');
         repeat
             key:=readkey;
             if ((key<>y1) and (key<>y2) and (key<>n1) and (key<>n2) and (key<>y1) and (key<>y2))
                then
                   begin
                      sound(400);
                      delay(150);
                      nosound;
                   end
                else
                   if ((key=n1) or (key=n2))
                      then
                         exit
                      else
                         begin
                            k:=0;
                            assign(f,'y:/kolobok/results.txt');
                            {$i-};
                            reset(f);
                            {$i+};
                            if ioresult<>0
                               then
                                  begin
                                     setfillstyle(1,8);
                                     bar(50,150,600,400);
                                     setcolor(white);
                                     settextstyle(0,0,2);
                                     outtextxy(70,175,'Произошла ошибка');
                                     outtextxy(70,200,'Результаты не будут сохранены');
                                     setcolor(yellow);
                                     settextstyle(0,0,6);
                                     outtextxy(270,300,'OK');
                                     repeat
                                        key:=readkey;
                                           if (key<>enter)
                                              then
                                                 begin
                                                    sound(400);
                                                    delay(150);
                                                    nosound;
                                                 end
                                              else
                                                 exit;
                                     until (key=enter)
                                  end
                               else
                                  begin
                                     while not eof(f) do
                                        begin
                                           readln(f,strin);
                                           k:=k+1;
                                        end ;
                                     close(f);
                                     if (k<(7*20))
                                        then
                                           begin
                                              append(f);
                                              temp:='';
                                              gettime(h,m,s,hund);
                                              str(m,temp);
                                              if (length(temp)=1)
                                                 then
                                                    temp:='0'+temp;
                                              write(f,'User: ');
                                              writeln(f,name);
                                              write(f,'Time: ');
                                              write(f,h);
                                              write(f,':');
                                              writeln(f,temp);
                                              write(f,'Date: ');
                                              getdate(h,m,s,hund);
                                              write(f,s);
                                              write(f,'/');
                                              str(m,temp);
                                              if (length(temp)=1)
                                                 then
                                                    temp:='0'+temp;
                                              write(f,temp);
                                              write(f,'/');
                                              writeln(f,h);
                                              write(f,'Number of positive obstacles: ');
                                              writeln(f,positive_count);
                                              write(f,'Number of negative obstacles: ');
                                              writeln(f,negative_count);
                                              write(f,'Score: ');
                                              writeln(f,scores);
                                              writeln(f,'--------------------------------------------- ');
                                              close(f);
                                           end
                                        else
                                           begin
                                              assign(f_temp,'y:/kolobok/reselts_temp.txt');
                                              rewrite(f_temp);
                                              reset(f);
                                              for i:=1 to 7 do
                                                 readln(f,strin);
                                              while not eof(f) do
                                                 begin
                                                    readln(f,strin);
                                                    writeln(f_temp,strin);
                                                 end;
                                              temp:='';
                                              gettime(h,m,s,hund);
                                              str(m,temp);
                                              if (length(temp)=1)
                                                 then
                                                    temp:='0'+temp;
                                              write(f_temp,'User: ');
                                              writeln(f_temp,name);
                                              write(f_temp,'Time: ');
                                              write(f_temp,h);
                                              write(f_temp,':');
                                              writeln(f_temp,temp);
                                              write(f_temp,'Date: ');
                                              getdate(h,m,s,hund);
                                              write(f_temp,s);
                                              write(f_temp,'/');
                                              str(m,temp);
                                              if (length(temp)=1)
                                                 then
                                                    temp:='0'+temp;
                                              write(f_temp,temp);
                                              write(f_temp,'/');
                                              writeln(f_temp,h);
                                              write(f_temp,'Number of positive obstacles: ');
                                              writeln(f_temp,positive_count);
                                              write(f_temp,'Number of negative obstacles: ');
                                              writeln(f_temp,negative_count);
                                              write(f_temp,'Score: ');
                                              writeln(f_temp,scores);
                                              writeln(f_temp,'--------------------------------------------- ');
                                              close(f);
                                              close(f_temp);
                                              erase(f);
                                              rename(f_temp,'y:/kolobok/results.txt');
                                           end;
                                  end;
                         end
         until ((key=n1) or (key=n2) or (key=y1) or (key=y2))
      end;


procedure
   instractions;
      begin
         cleardevice;
         setbkcolor(green);
         setcolor(yellow);
         settextstyle(0,0,7);
         outtextxy(40,50,'Инструкции');
         settextstyle(0,0,5);
         outtextxy(250,350,'Ясно');
         setcolor(white);
         setfillstyle(1,yellow);
         bar(20,130,50,160);
         settextstyle(7,0,4);
         outtextxy(70,120,' -тесто,укрепляет силы');
         outtextxy(120,150,'колобка; +1 очко');
         setfillstyle(1,red);
         bar(20,190,50,220);
         outtextxy(70,180,' -опасные хищники,наносят');
         outtextxy(120,210,'урон колобку; -1 очко');
         setfillstyle(1,white);
         bar(200,400,450,470);
         settextstyle(0,0,6);
         setcolor(brown);
         outtextxy(210,415,'ENTER');
      end;


procedure
   input_positive_count;
      begin
         cleardevice;
         setbkcolor(green);
         setcolor(yellow);
         settextstyle(7,0,6);
         outtextxy(140,10,'Количество');
         outtextxy(70,60,'положительных');
         outtextxy(110,110,'препятствий');
         setcolor(white);
         line(0,170,700,170);
         setcolor(yellow);
         settextstyle(7,0,6);
         outtextxy(300,210,'5');
         c:=1;
         setcolor(white);
         outtextxy(280,280,'10');
         outtextxy(280,350,'15');
         repeat
            key:=readkey;
            if (((c=1) and (key=down)) or ((c=3) and (key=up)))
               then
                   begin
                      setcolor(yellow);
                      outtextxy(280,280,'10');
                      setcolor(white);
                      outtextxy(300,210,'5');
                      outtextxy(280,350,'15');
                      c:=2;
                   end
            else
               if ((c=2) and (key=down))
                  then
                     begin
                        setcolor(yellow);
                        outtextxy(280,350,'15');
                        setcolor(white);
                        outtextxy(280,280,'10');
                        outtextxy(300,210,'5');
                        c:=3;
                     end
               else
                  if ((c=2) and (key=up))
                     then
                        begin
                           setcolor(yellow);
                           outtextxy(300,210,'5');
                           setcolor(white);
                           outtextxy(280,280,'10');
                           outtextxy(280,350,'15');
                           c:=1;
                        end
         until (key=enter);
         if (c=1)
            then
               positive_count:=5
            else
               if (c=2)
                  then
                     positive_count:=10
                  else
                     positive_count:=15;
      end;


procedure
   input_negative_count;
      begin
         cleardevice;
         setbkcolor(green);
         setcolor(yellow);
         settextstyle(7,0,6);
         outtextxy(140,10,'Количество');
         outtextxy(70,60,'отрицательных');
         outtextxy(110,110,'препятствий');
         setcolor(white);
         line(0,170,700,170);
         setcolor(yellow);
         settextstyle(7,0,6);
         outtextxy(300,210,'5');
         c:=1;
         setcolor(white);
         outtextxy(280,280,'10');
         outtextxy(280,350,'15');
         repeat
            key:=readkey;
            if (((c=1) and (key=down)) or ((c=3) and (key=up)))
               then
                   begin
                      setcolor(yellow);
                      outtextxy(280,280,'10');
                      setcolor(white);
                      outtextxy(300,210,'5');
                      outtextxy(280,350,'15');
                      c:=2;
                   end
            else
               if ((c=2) and (key=down))
                  then
                     begin
                        setcolor(yellow);
                        outtextxy(280,350,'15');
                        setcolor(white);
                        outtextxy(280,280,'10');
                        outtextxy(300,210,'5');
                        c:=3;
                     end
               else
                  if ((c=2) and (key=up))
                     then
                        begin
                           setcolor(yellow);
                           outtextxy(300,210,'5');
                           setcolor(white);
                           outtextxy(280,280,'10');
                           outtextxy(280,350,'15');
                           c:=1;
                        end
         until (key=enter);
         if (c=1)
            then
               negative_count:=5
            else
               if (c=2)
                  then
                     negative_count:=10
                  else
                     negative_count:=15;
      end;


procedure
   input_mas;
      var
         i,l,k,j:byte;
         temp:word;
         buffer_mas:mas;
      begin
         randomize;
         for i:=1 to negative_count do
            buffer_mas[i]:=-1;
         for i:=(negative_count+1) to (negative_count+positive_count) do
            buffer_mas[i]:=1;
         l:=negative_count+positive_count;
         case l of
            10:
               begin
                  for i:=1 to l do
                     coord_mas_x[i]:=150+random(500);
                  prov:=670;
               end;
            15:
               begin
                  for i:=1 to l do
                     coord_mas_x[i]:=150+random(1000);
                  prov:=1170;
               end;
            20:
               begin
                  for i:=1 to l do
                    coord_mas_x[i]:=150+random(1500);
                  prov:=1670;
               end;
            25:
               begin
                  for i:=1 to l do
                    coord_mas_x[i]:=150+random(2000);
                  prov:=2170;
               end;
            30:
               begin
                  for i:=1 to l do
                     coord_mas_x[i]:=150+random(2500);
                  prov:=2620;
               end;
         end;
         for i:=1 to l do
            coord_mas_y[i]:=200+random(150);
         for i:=1 to l-1 do
            for j:=i+1 to l do
               if coord_mas_x[i]>coord_mas_x[j]
                  then
                     begin
                        temp:=coord_mas_x[i];
                        coord_mas_x[i]:=coord_mas_x[j];
                        coord_mas_x[j]:=temp;
                     end;
         for i:=1 to l do
            begin
              k:=random(l)+1;
              score_mas[i]:=buffer_mas[k];
              for j:=k to (l-1) do
                 buffer_mas[j]:=buffer_mas[j+1];
              l:=l-1;
            end;
      end;


procedure
   input_name;
      begin
         name:='';
         cleardevice;
         setbkcolor(green);
         settextstyle(7,0,6);
         setcolor(white);
         outtextxy(10,100,'Введите Ваше имя');
         rectangle(10,170,629,250);
         outtextxy(220,300,'Далее');
         setfillstyle(1,white);
         bar(190,380,440,450);
         settextstyle(0,0,6);
         setcolor(brown);
         outtextxy(200,390,'ENTER');
         settextstyle(0,0,6);
         setcolor(yellow);
         setfillstyle(green,0);
         repeat
            key:=readkey;
            if (key=backspace)
               then
                  begin
                     if (ord(name[0])>0)
                        then
                           begin
                              name[0]:=chr(ord(name[0]) - 1);
                              bar(11,171,628,249);
                              outtextxy(30,190,name)
                           end
                  end
               else
                  begin
                     if ((ord(name[0])<12) and (key<>enter))
                        then
                           begin
                              name:=name+key;
                              outtextxy(30,190,name);
                           end
                  end;
            if ((ord(name[0])=0) and (key=enter))
               then
                  begin
                     setfillstyle(1,8);
                     bar(50,150,600,400);
                     settextstyle(1,0,7);
                     setcolor(white);
                     outtextxy(190,175,'Ошибка');
                     settextstyle(1,0,6);
                     outtextxy(55,250,'Повторите попытку');
                     key:=readkey;
                     input_name;
                  end;
         until (key=enter);
         exit;
      end;


procedure
   top;
      type
         tops=record
                 name,temp:string;
                 scores:integer;
              end;
         mas=array[1..20] of tops;
      var
         f:text;
         a:mas;
         s,temp,temp_name:string;
         i:byte;
         code,t,j:integer;
      begin
         j:=1;
         for i:=1 to 20 do
            begin
               a[i].name:='';
               a[i].scores:=0;
            end;
         assign(f,'y:/kolobok/results.txt');
         {$i-};
         reset(f);
         {$i+};
         if ioresult<>0
            then
               begin
                  setfillstyle(1,8);
                  bar(50,150,600,400);
                  setcolor(white);
                  settextstyle(0,0,2);
                  outtextxy(70,175,'Произошла ошибка');
                  outtextxy(70,200,'Отсутствует файл с результатами');
                  setcolor(yellow);
                  settextstyle(0,0,6);
                  outtextxy(270,300,'OK');
               end
         else
            begin
               while not eof(f) do
                  begin
                     temp:='';
                     temp_name:='';
                     readln(f,s);
                     for i:=7 to length(s) do
                        temp_name:=temp_name+s[i];
                     for i:=2 to 5 do
                        readln(f,s);
                     readln(f,s);
                     for i:=8 to length(s) do
                        temp:=temp+s[i];
                     val(temp,t,code);
                     readln(f,s);
                     a[j].name:=temp_name;
                     a[j].scores:=t;
                     j:=j+1;
                  end;
               close(f);
               for i:=1 to 19 do
                  for j:=i+1 to 20 do
                     if a[i].scores<a[j].scores
                        then
                           begin
                              t:=a[i].scores;
                              a[i].scores:=a[j].scores;
                              a[j].scores:=t;
                              temp_name:=a[i].name;
                              a[i].name:=a[j].name;
                              a[j].name:=temp_name;
                           end;
               cleardevice;
               setbkcolor(green);
               setcolor(yellow);
               settextstyle(0,0,7);
               outtextxy(180,10,'ТОП-5');
               settextstyle(0,0,5);
               outtextxy(280,350,'OK');
               setcolor(white);
               line(0,70,650,70);
               line(0,340,650,340);
               line(320,70,320,340);
               settextstyle(7,0,4);
               outtextxy(100,75,'Имя');
               outtextxy(380,75,'Результат');
               line(0,115,640,115);
               settextstyle(0,0,4);
               j:=120;
                  for i:=1 to 5 do
                     if (length(a[i].name)>0)
                        then
                           begin
                              str(a[i].scores,temp);
                              outtextxy(20,j,a[i].name);
                              outtextxy(450,j,temp);
                              j:=j+40;
                           end;
               setfillstyle(1,white);
               bar(200,400,450,470);
               settextstyle(0,0,6);
               setcolor(brown);
               outtextxy(210,415,'ENTER');
            end;
      end;


procedure
   menu;
      var
         c:byte;
      begin
         cleardevice;
         setbkcolor(green);
         setcolor(yellow);
         settextstyle(0,0,10);
         outtextxy(50,50,'КОЛОБОК');
         setcolor(yellow);
         settextstyle(7,0,6);
         outtextxy(200,140,'Играть');
         c:=1;
         setcolor(white);
         outtextxy(220,300,'ТОП-5');
         outtextxy(130,220,'Инструкции');
         outtextxy(210,370,'Выход');
         repeat
            key:=readkey;
            if (((c=1) and (key=down)) or ((c=3) and (key=up)))
               then
                   begin
                      setcolor(yellow);
                      outtextxy(130,220,'Инструкции');
                      setcolor(white);
                      outtextxy(200,140,'Играть');
                      outtextxy(210,370,'Выход');
                      outtextxy(220,300,'ТОП-5');
                      c:=2;
                   end
            else
               if ((c=3) and (key=down))
                  then
                     begin
                        setcolor(yellow);
                        outtextxy(210,370,'Выход');
                        setcolor(white);
                        outtextxy(130,220,'Инструкции');
                        outtextxy(200,140,'Играть');
                        outtextxy(220,300,'ТОП-5');
                        c:=4;
                     end
               else
                  if ((c=2) and (key=up))
                     then
                        begin
                           setcolor(yellow);
                           outtextxy(200,140,'Играть');
                           setcolor(white);
                           outtextxy(130,220,'Инструкции');
                           outtextxy(210,370,'Выход');
                           outtextxy(220,300,'ТОП-5');
                           c:=1;
                        end
                     else
                        if (((c=2) and (key=down)) or ((c=4) and (key=up)))
                           then
                              begin
                                 setcolor(yellow);
                                 outtextxy(220,300,'ТОП-5');
                                 outtextxy(200,140,'Играть');
                                 setcolor(white);
                                 outtextxy(200,140,'Играть');
                                 outtextxy(130,220,'Инструкции');
                                 outtextxy(210,370,'Выход');
                                 c:=3;
                              end;
         until (key=enter);
         if (c=4)
            then
               begin
                  repeat
                     exitt;
                     key:=readkey;
                     if ((key<>y1) and (key<>y2) and (key<>n1) and (key<>n2) and (key<>y1) and (key<>y2))
                        then
                           begin
                              sound(400);
                              delay(150);
                              nosound;
                           end
                        else
                           if ((key=n1) or (key=n2))
                              then
                                 begin
                                    cleardevice;
                                    menu;
                                    c:=1;
                                    exit;
                                 end
                              else
                                 begin
                                    closegraph;
                                    exit;
                                 end
                  until ((key=n1) or (key=n2) or (key=y1) or (key=y2))
               end
         else
            if c=2
               then
                  begin
                     repeat
                        instractions;
                        key:=readkey;
                     until (key=enter);
                     menu
                  end
               else
                  if (c=1)
                     then
                        begin
                           input_name;
                           exit;
                        end
                     else
                        if c=3
                           then
                              begin
                                 repeat
                                    top;
                                    key:=readkey;
                                 until (key=enter);
                                 menu;
                              end;
      end;


begin
   clrscr;
   gd:=detect;
   initgraph(gd,gm,'');
   if errorcode=0
      then
         begin
            cleardevice;
            greeting;
            repeat
               key:=readkey;
               if ( (key<>enter))
                 then
                    begin
                        repeat
                           exitt;
                           key:=readkey;
                           if ((key<>y1) and (key<>y2) and (key<>n1) and (key<>n2) and (key<>y1) and (key<>y2))
                              then
                                 sound(400);
                                 delay(150);
                                 nosound;
                           if  ((key<>y1) and (key<>y2))
                              then
                                 begin
                                    cleardevice;
                                    greeting
                                 end
                           else
                              closegraph;
                        until ((key=n1) or (key=n2) or (key=y1) or (key=y2))
                     end
                 else
                    begin
                       repeat
                          menu;
                          input_positive_count;
                          input_negative_count;
                          input_mas;
                          game;
                          output_data;
                       until (c<>0);
                    end
            until (key=enter);
         end
      else
         begin
            writeln('ERROR');
            writeln(grapherrormsg(errorcode));
            halt(1);
         end;
      closegraph;
end.