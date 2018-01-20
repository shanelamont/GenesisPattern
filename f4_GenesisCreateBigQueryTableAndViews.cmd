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

call %LOG% Framework to create BigQuery table and views for the Genesis Pattern
call %LOG% list the configuration
call gcloud config list


call %LOG% create datasets to hold the views (separate from the data)
call bq mk --project_id %PROJECT% %DATASETVIEWS%_flc
call bq mk --project_id %PROJECT% %DATASETVIEWS%_fld
call bq mk --project_id %PROJECT% %DATASETVIEWS%_fle
call bq mk --project_id %PROJECT% %DATASETVIEWS%_fls



rem use standard sql from now on and note that the view sql MUST be in double quotes ("...")in Windows

call %LOG% create view on first_name, last_name, country_code_2
call bq mk --project_id %PROJECT% --use_legacy_sql=false --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, country_code_2 FROM `%PROJECT%.%DATASET%.customer_table`" %DATASETVIEWS%_flc.customer_view_flc
rem set in other project (-ext)
rem call bq --project_id %PROJECT%-ext mk %DATASETVIEWS%_flc
rem call bq mk --project_id %PROJECT%-ext --use_legacy_sql=false --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, country_code_2 FROM `shane-gcp-end-2-end-test.customer.customer_table`" %DATASETVIEWS%_flc.customer_view_flc

call %LOG% create view on first_name, last_name, date_of_birth
call bq mk --project_id %PROJECT% --use_legacy_sql=false --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, date_of_birth FROM `%PROJECT%.%DATASET%.customer_table`" %DATASETVIEWS%_fld.customer_view_fld

call %LOG% create view on first_name, last_name, email
call bq mk --project_id %PROJECT% --use_legacy_sql=false --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, email FROM `%PROJECT%.%DATASET%.customer_table`" %DATASETVIEWS%_fle.customer_view_fle

call %LOG% create view on first_name, last_name, email, sar
call bq mk --project_id %PROJECT% --use_legacy_sql=false --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, email, sar FROM `%PROJECT%.%DATASET%.customer_table`" %DATASETVIEWS%_fls.customer_view_fls

call %LOG% finished

goto :eof

rem - create a new view - not currently used
call bq mk --project_id shane-gcp-end-2-end-test-ext %DATASETVIEWS%_flc_e

call bq mk --project_id shane-gcp-end-2-end-test-ext^
 --use_legacy_sql=false^
 --view="SELECT SESSION_USER() as SESSION_USER, first_name, last_name, country_code_2 FROM `shane-gcp-end-2-end-test.customer.customer_table`" ^
 customer_views_flc_e.customer_view_flc_e

call gcloud projects add-iam-policy-binding shane-gcp-end-2-end-test-ext ^
 --member user:mr.shane.lamont.test4@gmail.com --role roles/bigquery.user