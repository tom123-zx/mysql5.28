youqingtishi(){
            echo -e "\033[1;41m 运行此脚本必须装有mysql数据库! \033[0m "
            echo -e "\033[1;41m 第一次运行数据库中不能存在zhongqiu库和zhongqiuxf表,不然会报错! \033[0m "
            echo -e "\033[1;41m 鉴于作者比较菜,有bug请联系作者!谢谢 \033[0m "
            echo -e "\033[1;41m 第一次登陆必须先注册,不然会报错! \033[0m "
            read  -p "如果你同意以上协议请按回车继续! "  answer
            sleep 1
}
zhuce(){
   while true
   do
   read  -p "  请输入您要注册的用户名    " username
   mysql -u$databasename -p$databasepasswd -e "select name from zhongqiu.zhongqiuxf"  2>/dev/null |grep $username > /dev/null 
   if [ $? -eq 0 ];then
       echo "用户名 $username 已经存在,请重新输入您的用户名!"
       continue;
   else  
      echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
      read  -p "如果你同意以上协议请按回车继续! "  answer
      sleep 1
      read  -s -p "  请设置您的密码    " passwd1
      echo -e "\n" 
      read  -s -p "  请重复您的密码    " passwd2
      echo -e "\n"
      if [[ "$passwd1" = "$passwd2" ]] && [[ -n $passwd1 ]] ;then      
          YZ_passwd=`echo "$passwd1" | sed "s/[^[:alnum:]]//g"`
          if [  "$YZ_passwd" != "$passwd1" ];then
              echo "您输入的密码不合法请重新输入!"
          elif [ ${#passwd1} -le 7 ];then
              echo "您输入的密码不足8位,请重新输入!" 
          elif [[ "$passwd1" =~  ^[^A-Z].*  ]];then
              echo "您输入的密码不是以大写字母开头,请重新输入!"
          else
              mysql -u$databasename -p$databasepasswd -e "insert into zhongqiu.zhongqiuxf(name,passwd,jine) values ('$username',md5('$passwd1'),100 )"  2>/dev/null
              echo "注册成功!数据已经录入数据库,已经赠送100元到您的账户"
              sleep 1
              yunxing
           fi
      elif [ -z $passwd1 ];then
            echo "密码不能为空哦~"
      else    
         echo "您两次输入的密码不相同哦~请重新注册~"
         continue;
        fi
   fi
   done
   }
denglu(){
   jishu=0
   while true
   do   
     read -p "请输入您的用户名:    " dlusername
     echo -e "\n"
     jieguoname=`mysql -u$databasename -p$databasepasswd -e "select name from zhongqiu.zhongqiuxf"  2>/dev/null|grep $dlusername`
     read -s -p "请输入您的密码:      " dlpasswd   
     echo -e "\n"
     jieguopasswd1=`echo -n $dlpasswd |openssl md5|awk '{print $2}'`
     jieguopasswd2=`mysql -u$databasename -p$databasepasswd -e "select passwd from zhongqiu.zhongqiuxf where name = '$dlusername' " 2>/dev/null|awk NR==2`
     if [[ -n $jieguoname ]] && [[ "$jieguopasswd1" == "$jieguopasswd2" ]];then
        echo "登陆成功!"
        zhucaidan
     else
        jishu=$(($jishu+1))
        shengyu=$((3-$jishu))
        if [ $jishu -eq 3 ];then
            jishu=0
            echo "您已经连续输错3次,将退出本程序!"
            exit
        else
          echo "您输入的用户名或密码有误!请重新输入!您还有 $shengyu 次机会"
        fi
     fi 
    done
   }
   zhucaidan(){
       while true
       do
       echo "                    +-------------------------------------------------------------------------+"
       echo "                    |                                主菜单                                   |"
       echo "                    +-------------------------------------------------------------------------+"
       echo "                    |                               1. 查寻                                   |"
       echo "                    |                               2. 充值                                   |"
       echo "                    |                               3. 消费                                   |"
       echo "                    |                               4. 退出登录,并返回主菜单                  |"
       echo "                    |                               5. 修改密码                               |"
       echo "                    |                               6. 退出本程序                             |"
       echo "                    +-------------------------------------------------------------------------+"
printf "\e[1;31m 请选择您要做的操作: \e[0m" && read var
case "$var" in
  "1")  
        jine=`mysql -u$databasename -p$databasepasswd -e "select jine from zhongqiu.zhongqiuxf where name='$dlusername' " 2>/dev/null |awk NR==2`
        echo -n "                                               "
        echo -e  "\033[1;44m 您的余额还有 $jine 元 \033[0m"
        echo ""
        ;;
  "2")
        echo -n "                                        "
        echo -e  "\033[1;41m 注意:充值的金额只能是50的整数倍!\033[0m"
        read -p "请输入您要充值的金额: " chongzhijine
        expr $chongzhijine "+" 10 &> /dev/null
        if [ $? -eq 0 ];then
            if (($chongzhijine%50 == 0));then
                mysql -u$databasename -p$databasepasswd -e "update zhongqiu.zhongqiuxf  set jine=jine+$chongzhijine where name='$dlusername'" 2>/dev/null
                jine=`mysql -u$databasename -p$databasepasswd -e "select jine from zhongqiu.zhongqiuxf where name='$dlusername' " 2>/dev/null |awk NR==2`
                echo -n "                                          "
                echo -e  "\033[1;44m 充值成功!您当前的余额还有 $jine 元 \033[0m"
                echo ""
            else   
            echo -n "                                          "
            echo -e "\033[1;41m 您输入的 $chongzhijine 不是50的倍数!请重新输入! \033[0m "
            echo  ""
            fi
        else
            echo -n "                                          "
            echo -e "\033[1;41m 您输入的 $chongzhijine 不是数字! \033[0m "
            echo  ""
        fi
        ;;
  "3")
        echo -n "                                        "
        echo -e  "\033[1;41m 注意:消费的金额只能是整数!\033[0m"
        read -p "请输入您要消费的金额:"  xiaofeijine
        expr $xiaofeijine "+"  10 &> /dev/null
        if [ $? -eq 0 ];then
            jine=`mysql -u$databasename -p$databasepasswd -e "select jine from zhongqiu.zhongqiuxf where name='$dlusername' " 2>/dev/null |awk NR==2`
            shengyu=$(($jine - $xiaofeijine))
            if [ $shengyu -ge 0 ];then
                mysql -u$databasename -p$databasepasswd -e "update zhongqiu.zhongqiuxf  set jine=jine-$xiaofeijine where name='$dlusername'" 2>/dev/null
                echo "您当前消费 $xiaofeijine 元,您账户上还剩余 $shengyu 元"
            else 
                echo -n "                                        "
                echo -e "\033[1;41m 您当前的余额不足!请充值后再进行消费!\033[0m"
            fi
        else
            echo "请输入正确的消费金额!"
        fi
        ;;
  "4")
        yunxing
        ;;
  "5")  
        genggaimima
        ;;
  "6")  
        exit;
        ;;
    *)
        printf "请按照上方提供的选项输入!!!\n"
        ;;
esac
done
   }
yunxing(){
  while true
  do    
       echo "                    +-------------------------------------------------------------------------+"
       echo "                    |                                主程序                                   |"
       echo "                    +-------------------------------------------------------------------------+"
       echo "                    |                               1. 注册                                   |"
       echo "                    |                               2. 登录                                   |"
       echo "                    |                               3. 退出                                   |"
       echo "                    +-------------------------------------------------------------------------+"
       printf "\e[1;31m 请选择您要做的操作: \e[0m" && read canshu
case "$canshu" in
  "1")
      zhuce
      ;;
  "2")
      denglu
      ;;
  "3")
      exit
      ;; 
    *)
      printf "请按照上方提供的选项输入!!!\n"
      ;;
  esac
done
   }
   genggaimima(){ 
      echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
      read  -p "如果你同意以上协议请按回车继续! "  answer
      sleep 1
      while true
      do
      read  -s -p "  请设置您的密码    " passwd3
      echo -e "\n" 
      read  -s -p "  请重复您的密码    " passwd4
      echo -e "\n"
      if [[ "$passwd3" = "$passwd4" ]] && [[ -n $passwd3 ]] ;then      
          YZ_passwd1=`echo "$passwd3" | sed "s/[^[:alnum:]]//g"`
          if [  "$YZ_passwd1" != "$passwd3" ];then
              echo "您输入的密码不合法请重新输入!"
              echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
          elif [ ${#passwd3} -le 7 ];then
              echo "您输入的密码不足8位,请重新输入!" 
              echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
          elif [[ "$passwd3" =~  ^[^A-Z].*  ]];then
              echo "您输入的密码不是以大写字母开头,请重新输入!"
              echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
          else
              mysql -u$databasename -p$databasepasswd -e "update zhongqiu.zhongqiuxf set passwd = md5('$passwd3') where name= '$dlusername' "  2>/dev/null
              echo "密码修改成功!即将返回登录界面,请重新登录"
              sleep 1
              yunxing
           fi
      elif [ -z $passwd3 ];then
            echo "密码不能为空哦~"
      else    
         echo "您两次输入的密码不相同哦~请重新注册~"
         echo -e "\033[1;41m 注意！密码必须以大写字母开头,长度8位以上,密码不支持特殊字符！如输入特殊字符则会提示不合法！ \033[0m "
         continue;
        fi
    done
   }
shujgl(){
   youqingtishi
  while true
  do
   read -p "请输入您数据库的用户名   " databasename
   read -s  -p  "请输入您数据库的密码     " databasepasswd
   echo ""
   mysql -u $databasename -p$databasepasswd -e "show databases"  2>/dev/null
   if [ $? -eq  0  ];then
       echo "数据库登录成功!"
       mysql -u$databasename -p$databasepasswd -e "show databases" 2>/dev/null|grep zhongqiu > /dev/null
       if [ $? -eq 0 ];then
             mysql -u$databasename -p$databasepasswd -e "use zhongqiu;show tables;" 2>/dev/null|grep zhongqiuxf > /dev/null
             if [ $? -eq 0 ];then
                  echo "数据库已经存在!即将进入开始界面!"
                  sleep 3
                  yunxing
             else
                 mysql -u$databasename -p$databasepasswd -e "use zhongqiu;create table zhongqiuxf(name varchar(20),passwd varchar(100),jine int)" 2>/dev/null
                 echo "数据库创建成功!即将进入开始界面!"
                 sleep 3
                 yunxing
             fi
       else
           mysql -u$databasename -p$databasepasswd -e "create database zhongqiu" 2>/dev/null
           mysql -u$databasename -p$databasepasswd -e "use zhongqiu;create table zhongqiuxf(name varchar(20),passwd varchar(100),jine int)" 2>/dev/null
       echo "数据库创建成功!即将进入开始界面!"
       sleep 3
       yunxing
       fi
   else
       echo "用户名或密码错误,请重新登录!" 
   fi
 done
}

shujgl
