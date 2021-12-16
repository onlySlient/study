# gometalinter 

> <https://github.com/golangci/golangci-lint>

## Install

> go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0

## script for project

```shell
#!/bin/bash

[ ! -e z_lint ] && mkdir z_lint && echo "mkdir z_lint"

# clean
rm -rf z_lint/* && echo "clean"

# 配置路径
workDirs=()

lintPath=`pwd`/z_lint
timeSeq=`date "+%Y-%m-%d_%H:%M:%S"`

outputPath="${lintPath}/${timeSeq}"
mkdir -p $outputPath

for workDir in ${workDirs[@]}
do 
    cd $workDir && echo "${workDir}"
    go mod tidy
    # 生成代码质量信息
    # FIXME 多维度代码质量
    golangci-lint run > "${outputPath}/${workDir}"
    cd .. && echo `pwd`
done

echo "lint successfully."
```
