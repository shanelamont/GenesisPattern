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


call %LOG% Framework to create storage / logging environment Genesis Pattern for data Environment
rem call f1_GenesisEnvironmentVariables.cmd

call %LOG% List the configuration
call gcloud config list

call %LOG% Create the new storage FOR IN/out/log buckets in Belgium
call gsutil mb -c %STORAGECLASS% -p %PROJECT% -l %BELGIUM% gs://%INBUCKET%
call gsutil mb -c %STORAGECLASS% -p %PROJECT% -l %BELGIUM% gs://%OUTBUCKET%
call gsutil mb -c %STORAGECLASS% -p %PROJECT% -l %BELGIUM% gs://%LOGBUCKET%

call %LOG% grant access to %LOGBUCKET% to the google cloud logging group
call gsutil acl ch -g cloud-storage-analytics@google.com:W gs://%LOGBUCKET%
call gsutil defacl set project-private gs://%LOGBUCKET%

call %LOG% set logging for %INBUCKET%
call gsutil logging set on -b gs://%LOGBUCKET% -o %LOGOBJECTPREFIX% gs://%INBUCKET%

call %LOG% set logging for %OUTBUCKET%
call gsutil logging set on -b gs://%LOGBUCKET% -o %ENVIRONMENTNAME% gs://%OUTBUCKET%

call %LOG% exiting script for debug purposes

call %LOG% finished


echo on





