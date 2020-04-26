#! /bin/bash


echo "--- 发布组件 ---"


sources="https://github.com/CocoaPods/Specs.git"
binary_server_path="http://localhost:8080/frameworks"


# 输入信息
echo "请输入组件名字"
read -p "> " pod_name
echo -e "\033[32m组件名字：${pod_name} \033[0m"

echo "请输入要发布的组件的版本"
read -p "> " pod_version
echo -e "\033[32m组件版本：${pod_version} \033[0m"


# 创建二进制 podspec
pod bin spec create


# 构建二进制包
echo -e "\n开始构建二进制包"
pod bin archive $pod_name.podspec --sources=$sources
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
pod bin spec lint --binary "${pod_name}.binary.podspec.json" --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m验证二进制podspec失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m验证二进制podspec成功 \033[0m"
fi

# 发布二进制组件
echo -e "\n开始发布二进制组件"
pod bin repo push --binary "${pod_name}.binary.podspec.json" --sources=$sources --allow-warnings
if [ $? -ne 0 ]; then
    echo -e "\033[31m发布二进制组件失败 \033[0m" 
    exit 1
else
    echo -e "\033[32m发布二进制组件成功 \033[0m"
    rm -f ./{pod_name}.binary.podspec.json
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













