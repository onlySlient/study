# grpc-go

> [github](https://github.com/grpc/grpc-go)
> [源码分析思路](https://zhuanlan.zhihu.com/p/384472676)

## 思路

初步思路

0. http2
   1. 如何实现？
   2. 提供了什么样的功能？
1. 服务端   -1
   1. 特性
   2. 如何实现
   3. 生命周期
2. 客户端
   1. 特性
   2. 如何实现
   3. 生命周期
3. 流
   1. 服务端流
      1. 应用场景
      2. 如何实现
   2. 客户端流
      1. 应用场景
      2. 如何实现

### http2

### 服务端

`futures`

1. creds
2. codec
3. compressor and decompressor
4. interceptor
5. max Connstream/receiveSize/sendSize/headerListSize
6. keepalive
   1. params
   2. policy
7. window size
   1. window size
   2. conn window size
8. io buffer size
   1. write buffer size
   2. read buffer size
9. conn timeout
10. headerTableSize
11. server worker num

`default`

1. max receive size `1024 * 1024 * 4`, `4M`
2. max send size `math.MaxInt32` -> `1 << 31 - 1` , `2147483647`
3. timeout `120s`
4. write buffer size `32 * 1024` `32k`
5. read buffer size `32 * 1024` `32k`
6. server worker reset threshold `1 << 16` = `65536`

## Origin

1. if me, how can i impl it?

## programming thinking

1. start and close go runtime by channel
