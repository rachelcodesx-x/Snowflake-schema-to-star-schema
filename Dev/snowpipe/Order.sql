create or replace storage integration s3_location_integration_Order
  type = external_stage
  storage_provider = 'S3'
  enabled = true
  storage_aws_role_arn = ''
  storage_allowed_locations = ('s3://foodordersdata/Order')
  storage_aws_external_id = '';


desc integration s3_location_integration_Order;

create or replace stage Order_stage
  url = 's3://foodordersdata/Order'
  storage_integration = s3_location_integration
  file_format = (type = csv field_optionally_enclosed_by = '"' skip_header = 1);

create or replace pipe dev.stagesch.Order_pipe
  auto_ingest = true
  as
  copy into dev.stagesch.Order
  from @OrderAddressAddress_stage
  file_format = (type = csv field_optionally_enclosed_by = '"' skip_header = 1);
select system$pipe_status('dev.stagesch.restaurant_pipe');
