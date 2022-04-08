#!/bin/bash
#���ݿ�IP
dbserver='127.0.0.1'
#���ݿ��û���
dbuser='root'
#��������
dbpasswd='********'
#���ݿ�,���ж�����ÿո�ֿ�
dbname='back01'
#����ʱ��
backtime=`date +%Y%m%d`
#���������־·��
logpath='/data/mysqlbak/'


echo "################## ${backtime} #############################" 
echo "��ʼ����" 
#��־��¼ͷ��
echo "" >> ${logpath}/mysqlback.log
echo "-------------------------------------------------" >> ${logpath}/mysqlback.log
echo "����ʱ��Ϊ${backtime},�������ݿ�� ${dbname} ��ʼ" >> ${logpath}/mysqlback.log
#��ʽ�������ݿ�
for table in $dbname; do
source=`mysqldump -h ${dbserver} -u ${dbuser} -p${dbpasswd} ${table} > ${logpath}/${backtime}.sql` 2>> ${logpath}/mysqlback.log;
#���ݳɹ����²���
if [ "$?" == 0 ];then
cd $datapath
#Ϊ��ԼӲ�̿ռ䣬�����ݿ�ѹ��
tar zcf ${table}${backtime}.tar.gz ${backtime}.sql > /dev/null
#ɾ��ԭʼ�ļ���ֻ��ѹ�����ļ�
rm -f ${datapath}/${backtime}.sql
#ɾ������ǰ���ݣ�Ҳ����ֻ����7���ڵı���
find $datapath -name "*.tar.gz" -type f -mtime +7 -exec rm -rf {} \; > /dev/null 2>&1
echo "���ݿ�� ${dbname} ���ݳɹ�!!" >> ${logpath}/mysqlback.log
else
#����ʧ����������²���
echo "���ݿ�� ${dbname} ����ʧ��!!" >> ${logpath}/mysqlback.log
fi
done
echo "��ɱ���"
echo "################## ${backtime} #############################"