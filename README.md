# kylin-run
kylin 自包含 挂载运行

1.执行 ./kylin-run.sh xxx     xxx  为kylin-container下的应用ID,也是运行命令，或程序名，会进入沙盒文件系统。  在沙盒内执行命令  可运行程序。

2.修改 /bin/sh  为 $1  可直接执行程序      #此处有漏洞，无法获知未知应用可执行命令的具体名字,$1为包名。

3.暂时读写绑定 /run    
     否则-->
	测试程序Vlc 报错：
	QStandardPaths: could not set correct permissions on runtime directory /run/user/1000: 只读文件系统
	(process:3): dconf-CRITICAL **: 10:38:09.772: unable to create file '/run/user/1000/dconf/user': 只读文件系统.  dconf will not work properly.

4./app/usr/share  与 unionfs 生成的 /usr/share  有重复--ro-bind。
     否则-->
	仅配置变量  XDG_DATA_DIRS=/app/usr/share:/usr/share 无法满足需求，如测试程序gnome-chess
	Failed to load piece svg: 打开文件 /usr/share/gnome-chess/pieces/simple/whitePawn.svg 时出错：没有那个文件或目录

