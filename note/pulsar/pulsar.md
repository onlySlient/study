# Pulsar

## Overview

> Location: [Plusar](https://pulsar.apache.org/)  
> Github: [Plusar](https://github.com/apache/pulsar)  
> Author: [Apache](https://www.apache.org/)  
> Doc: <https://pulsar.apache.org/docs/en/standalone/>
> Pulsar 是一个分布式发布-订阅消息平台，具有非常灵活的消息模型和直观的客户端 API。

## Future（To be verified）

* Pulsar 的单个实例原生支持多个集群，可跨机房在集群间无缝地完成消息复制。
* 极低的发布延迟和端到端延迟。
* 可无缝扩展到超过一百万个 topic。
* 简单的客户端 API，支持 Java、Go、Python 和 C++。
* Multiple subscription types (exclusive, shared, and failover) for topics.
* 通过 Apache BookKeeper 提供的持久化消息存储机制保证消息传递。
  * 由轻量级的 serverless 计算框架 Pulsar Functions 实现流原生的数据处理。
  * 基于 Pulsar Functions 的 serverless connector 框架 Pulsar IO 使得数据更易移入、移出 Apache Pulsar。
  * 分层式存储可在数据陈旧时，将数据从热存储卸载到冷/长期存储（如S3、GCS）中。

## Principle

TODO

## Train

### Install On docker

Document
> <https://pulsar.apache.org/docs/en/standalone-docker/>

Cli
> docker run -itd \
  -p 6650:6650 \
  -p 8080:8080 \
  --mount source=pulsardata,target=/pulsar/data \
  --mount source=pulsarconf,target=/pulsar/conf \
  apachepulsar/pulsar:2.8.1 \
  bin/pulsar standalone

### Install On K8s

Document:
> <https://pulsar.apache.org/docs/zh-CN/kubernetes-helm>

TODO

### Install Pulsar manager

> Pulsar Manager 是一个网页式可视化管理与监测工具，支持多环境下的动态配置。可用于管理和监测租户、命名空间、topic、订阅、broker、集群等。

Document:
> <https://pulsar.apache.org/docs/zh-CN/administration-pulsar-manager/>

Cli:
> docker run -itd \
    -p 9527:9527 -p 7750:7750 \
    -e SPRING_CONFIGURATION_FILE=/pulsar-manager/pulsar-manager/application.properties \
    apachepulsar/pulsar-manager:v0.2.0

## How to use

TODO

## Thought

TODO

## Summary

TODO
