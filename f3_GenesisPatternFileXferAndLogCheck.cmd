@echo off

call %LOG% Framework to transfer

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

 file for the Genesis Pattern

call %LOG% verify that the bucket exists
call gsutil ls -p %PROJECT%

call %LOG% upload the customer file to google cloud
call gsutil cp data/%CUSTOMERFILE% gs://%INBUCKET%/%CUSTOMERFILE%

call %LOG% upload the customer file to google cloud (zipped)
call gsutil cp -z csv data/%CUSTOMERFILE% gs://%INBUCKET%/%CUSTOMERFILE%.gzip

call %LOG% list the files (show that it's there)
call gsutil ls -l gs://%INBUCKET%

call %LOG% setup a big query dataset
call bq mk --project_id %PROJECT% %DATASET%

call %LOG% load the table (unzipped)
call bq load --project_id %PROJECT% %DATASET%.%TABLE% gs://%INBUCKET%/%CUSTOMERFILE% ./%CUSTOMERSCHEMA%

call %LOG% load the table (zipped)
call bq load --project_id %PROJECT% %DATASET%.%TABLE%FromZip gs://%INBUCKET%/%CUSTOMERFILE%.gzip ./%CUSTOMERSCHEMA%

call %LOG% list the dataset
call bq ls --project_id %PROJECT%

call %LOG% list the tables in dataset
call bq ls --project_id %PROJECT% %DATASET%

call %LOG% get table information the tables
call bq show %PROJECT%:%DATASET%.%TABLE%

call %LOG% show first 10 rows
call bq head -n 10 %PROJECT%:%DATASET%.%TABLE%

call %LOG% run a query
type genesis_customer_query_standard.sql | bq query --use_legacy_sql=false

call %LOG% all finished

echo on

