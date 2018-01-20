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

call %LOG% *** Remove Environments

:choice
set /P c=Do you really want to delete genesis storage and bigquery tables? (Y/N)
if /I "%c%" EQU "Y" goto :deleteenvironment
if /I "%c%" EQU "N" goto :exitspot
goto :choice

:deleteenvironment
call %LOG%  Deleting the environment
pause

call %LOG%  remove logging from the buckets
call gsutil logging set off -b gs://%INBUCKET%
call gsutil logging set off -b gs://%OUTBUCKET%

call %LOG% cleanup the buckets
call gsutil rm -r gs://%INBUCKET%/
call gsutil rm -r gs://%OUTBUCKET%/
call gsutil rm -r gs://%LOGBUCKET%/

call %LOG% cleanup the BQ tables then BQ dataset
call bq rm -f %PROJECT%:%DATASET%.%TABLE%
call bq rm -f %PROJECT%:%DATASET%.%TABLE%.gZip

rem views can only be on a dataset, not a view (doh & pity)
call bq rm -r -f %PROJECT%:%DATASETVIEWS%_flc
call bq rm -r -f %PROJECT%:%DATASETVIEWS%_fld
call bq rm -r -f %PROJECT%:%DATASETVIEWS%_fle
call bq rm -r -f %PROJECT%:%DATASETVIEWS%_fls
call bq rm -r -f %PROJECT%:%DATASET%

call %LOG%  remove roles/bigquery.user
call gcloud projects remove-iam-policy-binding %PROJECT% --member user:mr.shane.lamont@gmail.com       --role roles/bigquery.user
call gcloud projects remove-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test1@gmail.com --role roles/bigquery.user
call gcloud projects remove-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test2@gmail.com --role roles/bigquery.user
call gcloud projects remove-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test3@gmail.com --role roles/bigquery.user

call %LOG% all finished environment cleaned


goto :EOF


:exitspot
echo "You selected NO, exiting [environment untouched]..."

