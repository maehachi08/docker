#!/bin/bash
# GO CDでDockerマシンイメージをビルドするためのスクリプト
# 
#  本スクリプトはGO CDエージェント上で実行すること想定する
#  ディレクトリ構成は以下を想定。
#    基点:
#      /var/lib/go-agent/pipelines/JavaServletHelloWorld
#
#    gitレポジトリ配布: 
#      /var/lib/go-agent/pipelines/JavaServletHelloWorld/git
#

# dockerビルド素材をコピー
mkdir -p work/docker/hello
cp -a git/docker/build/JavaServletHelloWorld/* work/docker/

# Javaアプリをコピー
cp -a git/JavaServletHelloWorld/WEB-INF work/docker/hello/

# docker build
docker build -t maehachi08/java_servlet_hello_world work/docker

