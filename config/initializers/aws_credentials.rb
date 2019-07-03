Rails.configuration.aws = {
  access_key_id: ENV.fetch("S3_ACCESS_KEY_ID",""),
  secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY",""),
  region: ENV.fetch("S3_REGION",""),
  bucket: ENV.fetch("S3_BUCKET","")
}
