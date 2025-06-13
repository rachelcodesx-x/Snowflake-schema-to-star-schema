create or replace storage integration s3_restaurant_integration
  type = external_stage
  storage_provider = 'S3'
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::739786453073:role/roleforpizzabucket'
  storage_allowed_restaurants = ('s3://foodordersdata/restaurant')
  storage_aws_external_id = 'FZ01979_SFCRole=3_3FP3CGsqlP9zhS+QsOTF7kuS6rg=';


desc integration s3_restaurant_integration;

create or replace stage restaurant_stage
  url = 's3://foodordersdata/restuarant'
  storage_integration = s3_restaurant_integration
  file_format = (type = csv field_optionally_enclosed_by = '"' skip_header = 1);

create or replace pipe dev.stagesch.restaurant_pipe
  auto_ingest = true
  as
  copy into dev.stagesch.restaurant
  from @restaurant_stage
  file_format = (type = csv field_optionally_enclosed_by = '"' skip_header = 1);
select system$pipe_status('dev.stagesch.restaurant_pipe');
