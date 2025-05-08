<!--
 * @Author: zhangming025251 rongc5@users.noreply.github.com
 * @Date: 2025-05-08 14:38:40
 * @LastEditors: zhangming025251 rongc5@users.noreply.github.com
 * @LastEditTime: 2025-05-08 14:43:14
 * @FilePath: /rxkeeper/README.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# RXKeeper 进程保活工具

RXKeeper是一个轻量级的进程保活工具，用于监控和自动重启已停止的进程。适用于需要持续运行的服务和应用程序。

## 功能特点

- 自动检测进程状态并重启已停止的进程
- 支持进程启动前执行自定义命令（如激活Python虚拟环境）
- 自动清理僵尸进程
- 详细的日志记录
- 简单易用的配置文件格式

## 安装和配置

1. 将`rxkeeper.sh`和`prockeepercfg.ini`文件复制到您的工作目录
2. 确保`rxkeeper.sh`有执行权限：
   ```
   chmod +x rxkeeper.sh
   ```
3. 根据需要编辑`prockeepercfg.ini`配置文件

## 配置文件格式

配置文件采用INI格式，每个需要监控的进程都有一个独立的部分，格式如下：

```ini
[序号]
Plat="进程类型"          # 描述性标记，用于标识进程类型，如"python"，不影响实际执行
ProcPlat="执行平台"      # 程序的执行器路径，如Python解释器路径，会在执行时使用，如不需要则设为"NONE"
ProcName="进程名称"      # 进程的文件名
ProcPara="启动参数"      # 启动进程时传递的参数，如不需要则设为"NONE"
ProcPath="进程路径"      # 进程所在的目录路径
ProcLogPath="日志路径"   # 日志存储路径
PreCmd="预启动命令"      # 启动进程前执行的命令，如激活虚拟环境，如不需要则设为"NONE"
```

### 参数说明

- **Plat** 与 **ProcPlat** 区别：
  - **Plat**：纯描述性参数，帮助管理员识别进程类型，不参与实际执行
  - **ProcPlat**：实际执行时使用的解释器或执行平台路径，参与构建执行命令

## 使用方法

### 手动运行

```bash
./rxkeeper.sh /path/to/prockeepercfg.ini
```

### 通过Crontab设置定时任务

添加以下行到crontab以每分钟检查一次进程状态：

```
*/1 * * * * cd /path/to/directory && ./rxkeeper.sh /path/to/prockeepercfg.ini
```

设置crontab的方法：

```bash
crontab -e
```

## 配置实例

以下是配置文件示例：

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

## 日志格式

每次检测到进程停止或启动成功时，都会在`ProcLogPath`指定的目录下生成日志文件。日志文件名格式为：
- 进程启动成功：`<进程名>_ok_<时间戳>`
- 进程启动失败：`<进程名>_failed_<时间戳>` 