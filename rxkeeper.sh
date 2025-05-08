#!/bin/bash
# rxkeeper.sh - ���̱���ű�
# ���ڼ��ָ�������Ƿ����У���δ����������

FILENAME=$1
if [ ! -f "$FILENAME" ] ; then
    echo "���������ļ�������"
    exit 1
fi

function _readINI(){
 INIFILE=$1
 NODE=$2
 KEY=$3
 _readIni=`awk -F '=' '/\['$NODE'\]/{a=1}a==1&&$1~/'$KEY'/{print $2;exit}' $INIFILE`
 echo ${_readIni}
}

# ��Ⲣɱ����ʬ����
function _killZombie(){
    PROC_NAME=$1
    
    pids=`ps -A -ostat,ppid,pid,cmd | grep -w "$PROC_NAME" | grep -e '^[zZ]' | tr -s " "| cut -d" " -f 3`
    for pid in $pids
    do
        echo "���ֽ�ʬ���̣�������ֹ... PID: $pid"
        kill -9 $pid 2>/dev/null
    done
}

# ��ѭ��
for i in {1..1000}
do
    _ProcName=$(echo $( _readINI $FILENAME $i ProcName ) | sed 's/"//g')
    if [ "$_ProcName" == "NONE" ] ; then 
        continue
    fi

    if [ "$_ProcName" == "" ] ; then
        exit 0
    fi

    _ProcPara=$(echo $( _readINI $FILENAME $i ProcPara ) | sed 's/"//g')
    if [ "$_ProcPara" == "NONE" ] ; then 
        _ProcPara=""
    fi
    
    _ProcPlat=$(echo $( _readINI $FILENAME $i ProcPlat ) | sed 's/"//g')
    if [ "$_ProcPlat" == "NONE" ] ; then 
        _ProcPlat=""
    fi

    _ProcPath=$(echo $( _readINI $FILENAME $i ProcPath ) | sed 's/"//g')
    _ProcLogPath=$(echo $( _readINI $FILENAME $i ProcLogPath ) | sed 's/"//g')
    _PreCmd=$(echo $( _readINI $FILENAME $i PreCmd ) | sed 's/"//g')

    _ProcNamePath="$_ProcPath"/"$_ProcName"
    echo "������״̬... `date '+%Y-%m-%d %H:%M:%S'`"

    _WriteLogFlag=0
    for j in 1 2
    do
        _killZombie $_ProcNamePath
    
        # �������Ƿ�������
        tmp_procs=`ps -ef | grep -w "$_ProcNamePath" | grep -v grep`
        
        if [ x"$_ProcPlat" != x ]; then
            tmp_procs=`echo "$tmp_procs" | grep -w "$_ProcPlat"`
        fi
        
        if [ x"$_ProcPara" != x ]; then
            tmp_para=`echo "$_ProcPara" | sed -e 's/^[-]*//g'`  # ȥ������ǰ��������ַ� '-'
            tmp_procs=`echo "$tmp_procs" | grep -w "$tmp_para"`
        fi
        
        _PCOUNT=0
        if [ x"$tmp_procs" != x ]; then
            _PCOUNT=`echo "$tmp_procs" | wc -l`
        fi
        
        if [ $_PCOUNT -ge 1 ]; then
            echo "$_ProcPlat $_ProcNamePath $_ProcPara ����������..."
            if [ $_WriteLogFlag -eq 1 ] && [ "$_ProcLogPath" != "NONE" ]; then
                _CheckTime=`date '+%Y%m%d_%H%M%S'`
                _ProcLogName="$_ProcLogPath"/"$_ProcName"_ok_$_CheckTime
                echo "12@0@`date '+%Y-%m-%d %H:%M:%S.000'`@$_ProcName start" > "$_ProcLogName"
            fi
            break
        else
            echo "$_ProcPlat $_ProcNamePath $_ProcPara δ���У���������..."
            if [ "$_ProcLogPath" != "NONE" ]; then
                _WriteLogFlag=1
                _CheckTime=`date '+%Y%m%d_%H%M%S'`
                _ProcLogName="$_ProcLogPath"/"$_ProcName"_failed_$_CheckTime
                echo "12@1@`date '+%Y-%m-%d %H:%M:%S.000'`@$_ProcName closed" > "$_ProcLogName"
            fi

            # ִ��Ԥ��������(����)
            if [ "$_PreCmd" != "NONE" ] && [ "$_PreCmd" != "" ]; then
                echo "ִ��Ԥ��������: $_PreCmd"
                eval $_PreCmd
            fi

            # ��������
            cd $_ProcPath && $_ProcPlat "$_ProcNamePath" $_ProcPara &
            
            sleep 1
        fi
    done
done