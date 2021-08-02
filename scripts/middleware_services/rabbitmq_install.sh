#!/bin/bash
rabbitmq_env_check(){
	erl -versio >/dev/null 2>&1
	if [[ $? = 0 ]];then
		success_log "erlang运行环境已具备"
	else
		error_log "erlang运行环境没有安装请安装"
		erlang_install_ctl
	fi
}

rabbitmq_env_load(){
	
	tmp_dir=/tmp/rabbitmq_tmp
	mkdir -p ${tmp_dir}
	soft_name=rabbitmq
	program_version=('3.7' '3.8')
	url='https://repo.huaweicloud.com/rabbitmq-server'
	select_version
	install_dir_set
	online_version

}

rabbitmq_down(){

	down_url="${url}/v${detail_version_number}/rabbitmq-server-generic-unix-${detail_version_number}.tar.xz"
	online_down_file
	unpacking_file ${tmp_dir}/rabbitmq-server-generic-unix-${detail_version_number}.tar.xz ${tmp_dir}

}


rabbitmq_install_set(){

	output_option '请选择安装模式' '单机模式 集群模式' 'deploy_mode'
	if [[ ${deploy_mode} = '1' ]];then
		input_option '请设置rabbitmq的主机名称' 'node1' 'rabbitmq_nodename'
		rabbitmq_nodename=${input_value}
	elif [[ ${deploy_mode} = '2' ]];then
		vi ${workdir}/config/rabbitmq/rabbitmq.conf
		. ${workdir}/config/rabbitmq/rabbitmq.conf
	fi

}


rabbitmq_install(){ 

	if [[ ${deploy_mode} = '1' ]];then
		home_dir=${install_dir}/rabbitmq
		mv ${tar_dir}/* ${home_dir}
		rabbitmq_config
		add_rabbitmq_service
	fi
	
}


rabbitmq_config(){

	cat ${workdir}/config/rabbitmq/rabbitmq-env.conf >${home_dir}/etc/rabbitmq/rabbitmq-env.conf
	sed -i "s?RABBITMQ_NODENAME=.*?RABBITMQ_NODENAME=rabbit@${rabbitmq_nodename}?" ${home_dir}/etc/rabbitmq/rabbitmq-env.conf

}

add_rabbitmq_service(){
	Type="forking"
	if [[ ${deploy_mode} = '1' ]];then
		ExecStart="${home_dir}/sbin/rabbitmq-server -daemon"
		ExecStop="${home_dir}/sbin/rabbitmqctl shutdown"
		conf_system_service ${home_dir}/rabbitmq.service
		add_system_service rabbitmq ${home_dir}/rabbitmq-server.service
		
	elif [[ ${deploy_mode} = '2' ]];then
		ExecStart="${home_dir}/sbin/rabbitmq-server -daemon"
		ExecStop="${home_dir}/sbin/rabbitmqctl shutdown"
		conf_system_service ${tmp}/rabbitmq-node${i}.service
	fi
	
}

rabbitmq_install_ctl(){
	rabbitmq_env_check
	rabbitmq_env_load
	rabbitmq_install_set
	rabbitmq_down
	rabbitmq_install
	
}
