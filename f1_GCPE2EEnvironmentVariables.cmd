@echo off

rem Copyright 2018 Shane Lamont
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

call DateTime Framework to create the Environment variables for Genesys Pattern / Environment

set PROJECT=shane-gcp-end-2-end-test-2
set EXTERNAL_PROJECT=shane-gcp-end-2-end-test-ext
set ENVIRONMENTNAME=genesis
set LOGOBJECTPREFIX=%ENVIRONMENTNAME%
set STORAGECLASS=Standard
set BELGIUM=europe-west1
set ZONE=europe-west1-b

rem datalab
set ZONE=europe-west1-b
set DATALABVM=datalabvm-shane1

rem Genesis pattern
set INBUCKET=%PROJECT%-%ENVIRONMENTNAME%-in
set OUTBUCKET=%PROJECT%-%ENVIRONMENTNAME%-out
set LOGBUCKET=%PROJECT%-%ENVIRONMENTNAME%-logs
set ADVIEWER=ADGRP-%PROJECT%-viewer
set ADEDITOR=ADGRP-%PROJECT%-editor
set ADOWNER=ADGRP-%PROJECT%-owner
set ADEVIEWER=ADGRP-%PROJECT%-%ENVIRONMENTNAME%-viewer
set ADEEDITOR=ADGRP-%PROJECT%-%ENVIRONMENTNAME%-editor
set ADEOWNER=ADGRP-%PROJECT%-%ENVIRONMENTNAME%-owner
set VMNAME=%PROJECT%-%ENVIRONMENTNAME%-owner

set CUSTOMERFILE=customer.csv

set DATASET=customer
set DATASETVIEWS=customer_views
set TABLE=customer_table
set CUSTOMERSCHEMA=data/customer_schema.json
SET SQLQUERYFILESTANDARD=genesis_customer_query_standard.sql
SET SQLQUERYFILELEGACY=genesis_customer_query_legacy.sql

rem PubSub
rem set access - no longer active
set TOPIC=shane-pubsub-topic
set SUBSCRIPTION=shane-pubsub-subscription
set SUBSCRIPTION2=shane-pubsub-subscription2
set DATA_DIR=./data_dir
set PUBSUB_EMULATOR_HOST=localhost:8432
set PUBSUB_PROJECT_ID=%PROJECT%

rem source repo
set REPO_NAME=shane_sourcerepo_01

rem for logging, set this to your directory
set LOG=C:\Users\shane\PycharmProjects\Shane-GCP-end-2-end-test\datetime.cmd

