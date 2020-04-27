#! /bin/bash


echo "--- 发布组件 ---"


sources="https://github.com/CocoaPods/Specs.git"
binary_server_path="http://localhost:8080/frameworks"


# 读取组件名
# 参数1: 路径；参数2: 文件后缀名
function searchFileInFolder(){
    for element in `ls $1`
    do  
        file_path=$1"/"$element
        f_extension=${file_path##*.}
        if [[ $f_extension == $2 ]]; then
        	file_name=$element
        fi
    done
}
# 文件夹路径，pwd表示当前文件夹
folder="$(pwd)"
# 文件后缀名
file_extension="podspec"
# 获取到的文件路径
file_name=""
searchFileInFolder $folder $file_extension
if [ -z "$file_name" ]; then
    echo -e "\033[31m当前目录 ${folder} 没有找到${file_extension}文件 \033[0m" 
    exit 1
else
	echo "podspec文件：${file_name}"
fi
# 组件名
pod_name=${file_name%.*}
echo -e "\033[32m组件名：${pod_name} \033[0m"


# 读取podspec版本
pod_version=""
search_str="s.version"
target_file="${file_name}" 
while read target_line
do
	# 查找到包含的内容，正则表达式获取以 ${search_str} 开头的内容
	result=$(echo ${target_line} | grep "^${search_str}")
	if [[ "$result" != "" ]]
	then
   		# echo "\n ${target_line} 包含 ${search_str}"
   		# 分割字符串，是变量名称，不是变量的值; 前面的空格表示分割的字符，后面的空格不可省略
		array=(${result// / })  
		# 数组长度
		count=${#array[@]}
		# 获取最后一个元素内容
		version=${array[count - 1]}
		# 去掉 '
		version=${version//\'/}
		pod_version=$version
	fi
done < $target_file
# 获取到的组件版本
if [ -z "$pod_version" ]; then
    echo -e "\033[31m读取组件版本异常 \033[0m" 
    exit 1
else
	echo -e "\033[32m组件版本：${pod_version} \033[0m"
fi


# 创建二进制 podspec
pod bin spec create


# 构建二进制包
echo -e "\n开始构建二进制包"
pod bin archive ${pod_name}.podspec --sources=$sources
if [ $? -ne 0 ]; then
    echo -e "\033[31m构建二进制包失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m构建二进制包成功 \033[0m"
fi


# 上传二进制包
echo -e "\n开始上传二进制包"
echo "开始清除"
curl -X 'DELETE' "${binary_server_path}/${pod_name}/${pod_version}" -O -J
rm -f ./${pod_version}
echo "清除成功"
curl $binary_server_path -F "name=${pod_name}" -F "version=${pod_version}" -F "file=@./${pod_name}.framework.zip"
rm -f ./${pod_name}.framework.zip
if [ $? -ne 0 ]; then
    echo -e "\033[31m\n上传二进制包失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m\n上传二进制包成功 \033[0m"
fi


# 验证二进制podspec
echo -e "\n开始验证二进制podspec"
pod bin spec lint --binary ${pod_name}.binary.podspec.json --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m验证二进制podspec失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m验证二进制podspec成功 \033[0m"
fi

# 发布二进制组件
echo -e "\n开始发布二进制组件"
pod bin repo push --binary ${pod_name}.binary.podspec.json --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m发布二进制组件失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m发布二进制组件成功 \033[0m"
    rm -f ./${pod_name}.binary.podspec.json
fi


# 验证源码podspec
echo -e "\n开始验证源码podspec"
pod bin spec lint "${pod_name}.podspec" --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m验证源码podspec失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m验证源码podspec成功 \033[0m"
fi

# 发布源码组件
echo -e "\n开始发布源码组件"
pod bin repo push "${pod_name}.podspec" --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m发布源码组件失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m发布源码组件成功 \033[0m"
fi













