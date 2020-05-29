#!/bin/bash
env_load(){
	tmp_dir=/tmp/java_tmp
	soft_name=java
	program_version=('7' '8')
}

check_java(){
	#检查旧版本
	diy_echo "正在检查预装openjava..." "${info}"
	j=`rpm -qa | grep  java | awk 'END{print NR}'`
	#卸载旧版
	if [ $j -gt 0 ];then
		diy_echo "java卸载清单:" "${info}"
		for ((i=1;i<=j;i++));
		do		
			a1=`rpm -qa | grep java | awk '{if(NR == 1 ) print $0}'`
			echo $a1
			rpm -e --nodeps $a1
		done
		if [ $? = 0 ];then
			diy_echo "卸载openjava完成." "${info}"
		else
			diy_echo "卸载openjava失败，请尝试手动卸载." "${error}"
			exit 1
		fi
	else
		diy_echo "该系统没有预装openjava." "${info}"
	fi
}

install_java(){
	check_java
	cp ${tar_dir}/* ${home_dir}
	add_sys_env "JAVA_HOME=${home_dir} JAVA_BIN=\$JAVA_HOME/bin JAVA_LIB=\$JAVA_HOME/lib CLASSPATH=.:\$JAVA_LIB/tools.jar:\$JAVA_LIB/dt.jar PATH=\$JAVA_HOME/bin:\$PATH"
	java -version
	if [ $? = 0 ];then
		diy_echo "JDK环境搭建成功.." "${info}"
	else
		diy_echo "JDK环境搭建失败." "${error}"
		exit 1
	fi
}

java_install_ctl(){
	env_load
	install_set
	install_java
	clear_install
}