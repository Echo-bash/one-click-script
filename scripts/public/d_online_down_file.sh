#!/bin/bash
online_down_file(){
	if [[ -z ${down_url} ]];then
		diy_echo "函数online_down_file缺少down_url变量" "${error}"
		exit 1
	fi
	[[ ! -d ${tmp_dir} ]] && mkdir -p ${tmp_dir}
	down_file ${down_url} ${tmp_dir}

}