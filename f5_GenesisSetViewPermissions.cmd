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

call %LOG% list the configuration
call gcloud config list


call %LOG% set access all users can query
call gcloud projects add-iam-policy-binding %PROJECT% --member user:mr.shane.lamont@gmail.com       --role roles/bigquery.user
call gcloud projects add-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test1@gmail.com --role roles/bigquery.user
call gcloud projects add-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test2@gmail.com --role roles/bigquery.user
call gcloud projects add-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test3@gmail.com --role roles/bigquery.user


rem - check with Google on how this is permissioned externally
rem call gcloud projects add-iam-policy-binding %PROJECT%-ext --member user:mr.shane.lamont.test4@gmail.com --role roles/bigquery.user


call %LOG% updating from iam_%DATASETVIEWS%_fl[cdes].json
call bq update --project_id %PROJECT% --source=iam_%DATASETVIEWS%_flc.json %DATASETVIEWS%_flc
call bq update --project_id %PROJECT% --source=iam_%DATASETVIEWS%_fld.json %DATASETVIEWS%_fld
call bq update --project_id %PROJECT% --source=iam_%DATASETVIEWS%_fle.json %DATASETVIEWS%_fle
call bq update --project_id %PROJECT% --source=iam_%DATASETVIEWS%_fls.json %DATASETVIEWS%_fls
call %LOG% finished updating from iam_%DATASETVIEWS%_fl[cdes].json

rem call bq update --project_id %PROJECT%-ext --source=ext-%DATASETVIEWS%_flc.json ext-%DATASETVIEWS%_flc
call %LOG% Authorize the view to access the source dataset
call bq update --project_id %PROJECT% --source=iam_%DATASET%.json %DATASET%

call %LOG% get the current project iam policy
call gcloud projects get-iam-policy %PROJECT% --format=json

call %LOG% iam_%DATASETVIEWS%_flc.json
call bq --project_id %PROJECT% --format=prettyjson show %DATASETVIEWS%_flc
call %LOG% iam_%DATASETVIEWS%_fld.json
call bq --format=prettyjson show %DATASETVIEWS%_fld
call %LOG% iam_%DATASETVIEWS%_fle.json
call bq --format=prettyjson show %DATASETVIEWS%_fle
call %LOG% iam_%DATASETVIEWS%_fls.json
call bq --format=prettyjson show %DATASETVIEWS%_fls

rem call bq --project_id %PROJECT%-ext --format=prettyjson show ext-%DATASETVIEWS%_flc

call %LOG% finished
goto :EOF

rem *******************************************************************************

rem you can only give permission to a dataset, not a view (doh)
rem Create a separate dataset to store the view.
rem Create the view in the new dataset.
rem Assign access controls to the project.
rem Assign access controls to the dataset containing the view.
rem Authorize the view to access the source dataset.

rem todo: Set up three access groups
rem each use should have the role roles/bigquery.user
rem member is an e-mail address
rem group contains members
rem resource is project, compute engine, etc
rem permissions is service.resource.verb e.g. pubsub.subscription.consume
rem role has several permissions
rem policy is a list of bindings
rem binding mape a list of members to a role

goto skip_create_project_iam
call gcloud projects get-iam-policy %PROJECT% > iam_%PROJECT%.json
:skip_create_project_iam

goto skip_create_iam
rem For users to query the view, they need READER access to the dataset that contains the view. For more
rem  information about assigning access controls to a dataset, see Assigning access controls to datasets.
rem use this so create the initial IAM - would change in continuout integration  / bulld
call %LOG% get iam policy into iam_%DATASETVIEWS%_fl[cdes].json
call bq --format=prettyjson show %DATASETVIEWS%_flc > iam_%DATASETVIEWS%_flc.json
call bq --format=prettyjson show %DATASETVIEWS%_fld > iam_%DATASETVIEWS%_fld.json
call bq --format=prettyjson show %DATASETVIEWS%_fle > iam_%DATASETVIEWS%_fle.json
call bq --format=prettyjson show %DATASETVIEWS%_fls > iam_%DATASETVIEWS%_fls.json
:skip_create_iam


echo *** remove users individually
call gcloud projects remove-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test2@gmail.com --role roles/bigquery.user
call gcloud projects    add-iam-policy-binding %PROJECT% --member user:mr.shane.lamont.test2@gmail.com --role roles/bigquery.user

call %LOG%
echo *** current iam policy is in iam_%PROJECT%.json
echo *** ******* edit iam_%PROJECT%.json then continue ***********
echo *** just continue to leave current iam in place
pause

call gcloud projects set-iam-policy %PROJECT% iam_%PROJECT%.json

echo on





