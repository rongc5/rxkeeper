<!--
 * @Author: zhangming025251 rongc5@users.noreply.github.com
 * @Date: 2025-05-08 14:38:40
 * @LastEditors: zhangming025251 rongc5@users.noreply.github.com
 * @LastEditTime: 2025-05-08 14:43:14
 * @FilePath: /rxkeeper/README.md
 * @Description: ����Ĭ������,������`customMade`, ��koroFileHeader�鿴���� ��������: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# RXKeeper ���̱����

RXKeeper��һ���������Ľ��̱���ߣ����ڼ�غ��Զ�������ֹͣ�Ľ��̡���������Ҫ�������еķ����Ӧ�ó���

## �����ص�

- �Զ�������״̬��������ֹͣ�Ľ���
- ֧�ֽ�������ǰִ���Զ�������缤��Python���⻷����
- �Զ�����ʬ����
- ��ϸ����־��¼
- �����õ������ļ���ʽ

## ��װ������

1. ��`rxkeeper.sh`��`prockeepercfg.ini`�ļ����Ƶ����Ĺ���Ŀ¼
2. ȷ��`rxkeeper.sh`��ִ��Ȩ�ޣ�
   ```
   chmod +x rxkeeper.sh
   ```
3. ������Ҫ�༭`prockeepercfg.ini`�����ļ�

## �����ļ���ʽ

�����ļ�����INI��ʽ��ÿ����Ҫ��صĽ��̶���һ�������Ĳ��֣���ʽ���£�

```ini
[���]
Plat="��������"          # �����Ա�ǣ����ڱ�ʶ�������ͣ���"python"����Ӱ��ʵ��ִ��
ProcPlat="ִ��ƽ̨"      # �����ִ����·������Python������·��������ִ��ʱʹ�ã��粻��Ҫ����Ϊ"NONE"
ProcName="��������"      # ���̵��ļ���
ProcPara="��������"      # ��������ʱ���ݵĲ������粻��Ҫ����Ϊ"NONE"
ProcPath="����·��"      # �������ڵ�Ŀ¼·��
ProcLogPath="��־·��"   # ��־�洢·��
PreCmd="Ԥ��������"      # ��������ǰִ�е�����缤�����⻷�����粻��Ҫ����Ϊ"NONE"
```

### ����˵��

- **Plat** �� **ProcPlat** ����
  - **Plat**���������Բ�������������Աʶ��������ͣ�������ʵ��ִ��
  - **ProcPlat**��ʵ��ִ��ʱʹ�õĽ�������ִ��ƽ̨·�������빹��ִ������

## ʹ�÷���

### �ֶ�����

```bash
./rxkeeper.sh /path/to/prockeepercfg.ini
```

### ͨ��Crontab���ö�ʱ����

��������е�crontab��ÿ���Ӽ��һ�ν���״̬��

```
*/1 * * * * cd /path/to/directory && ./rxkeeper.sh /path/to/prockeepercfg.ini
```

����crontab�ķ�����

```bash
crontab -e
```

## ����ʵ��

�����������ļ�ʾ����

```ini
[1]
Plat="NONE"
ProcPlat="NONE"
ProcName="rxsysmon"
ProcPara="NONE"
ProcPath="/home/user/app/bin"
ProcLogPath="/home/user/app/logs"
PreCmd="NONE"

[2]
Plat="python"
ProcPlat="/home/user/venv/bin/python"
ProcName="server.py"
ProcPara="NONE"
ProcPath="/home/user/app"
ProcLogPath="/home/user/app/logs"
PreCmd="source /home/user/venv/bin/activate"
```

## ��־��ʽ

ÿ�μ�⵽����ֹͣ�������ɹ�ʱ��������`ProcLogPath`ָ����Ŀ¼��������־�ļ�����־�ļ�����ʽΪ��
- ���������ɹ���`<������>_ok_<ʱ���>`
- ��������ʧ�ܣ�`<������>_failed_<ʱ���>` 