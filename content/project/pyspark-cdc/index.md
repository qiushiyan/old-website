---
title: Change Data Capture with PySpark 
summary: use pyspark and aws to build data pipelines 
abstract: ""
date: "2021-10-19"
image:
  preview_only: true
links:
  - icon: github
    icon_pack: fab
    name: code
    url: https://github.com/qiushiyan/pyspark-cdc

tags:
  - Python 
---

This project builds a data integration pipeline with PySpark and AWS. It starts with data migration from RDS to S3 with replication on going, then lambda functions and AWS Glue jobs work together to synchronize bulk loaded data with CDC records. Finally, we perform feature engineering steps and save the final version of data in S# in preparation for analytical tasks. 