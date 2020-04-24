# frozen_string_literal: true

Rails.configuration.aws = {
  access_key_id: ENV.fetch("S3_ACCESS_KEY_ID", "access_key_id"),
  secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY", "secret_access_key"),
  region: ENV.fetch("S3_REGION", "region"),
  bucket: ENV.fetch("S3_BUCKET", "bucket")
}
