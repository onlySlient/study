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
workDirs=(arc-cmpt arc-device arc-fm arc-fusion arc-schedule arc-spatial arc-tool arc-util arc-workorder go-lib)

lintPath=`pwd`/z_lint
timeSeq=`date "+%Y-%m-%d_%H:%M:%S"`

outputPath="${lintPath}/${timeSeq}"
mkdir -p $outputPath

for workDir in ${workDirs[@]}
do 
    pushd $workDir
    go mod tidy
    golangci-lint run > "${outputPath}/${workDir}"
    popd > /dev/null
done

echo "lint successfully."
```
