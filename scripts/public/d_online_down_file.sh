#!/bin/bash
online_down_file(){

	if [[ -z ${down_url} ]];then
		diy_echo "函数online_down_file缺少down_url变量" "${error}"
		exit 1
	fi
	if [[ -z ${down_url} ]];then
		tmp_dir=/tmp
	fi
	down_url=`eval echo ${down_url}`
	
	[[ ! -d ${tmp_dir} ]] && mkdir -p ${tmp_dir}
	
	if [[ -z ${down_filename} ]];then
		down_filename=${down_url##*/}
	fi
	down_file ${down_url} ${tmp_dir}/${down_filename}

}