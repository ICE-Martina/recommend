#!/bin/bash
# 重启 CommunityIBCF 算法程序

# 案例 ./CommunityIBCF.sh "/home/hadoop/app/recommend/recommend-2.0/target/scala-2.10/recommend-2.0.jar"

# jar 的地址
JAR_PATH=$1

# 删除 spark 提交时的临时文件
rm -rf /tmp/spark-*

# 原来的 进程
ps -aux | grep 'com.angejia.dw.recommend.community.CommunityIBCF' | awk '{print $2}' | while read pid;
  do
    echo "old pid: ${pid}"
    kill -15 $pid;
  done


# 提交任务给集群 yarn 客户端模式
spark-submit \
--name CommunityIBCF \
--class com.angejia.dw.recommend.community.CommunityIBCF \
--master yarn-client \
--driver-cores 4 \
--driver-memory 10240M \
--executor-memory 2048M \
--num-executors 2 \
${JAR_PATH} "online" "hdfs://uhadoop-ociicy-master1:8020/user/hive/real_time/rt_user_community_history/*"
 

# 新的进程
ps -aux | grep 'com.angejia.dw.recommend.community.CommunityIBCF' | awk '{print $2}' | while read pid;
  do
    echo "new pid: ${pid}"
  done

