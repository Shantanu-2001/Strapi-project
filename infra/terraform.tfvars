ssh_key_name      = "devops-intern-key" # <-- your key pair name from AWS
allowed_ssh_cidr  = "0.0.0.0/0"         # for demo; better: your IP
allowed_http_cidr = "0.0.0.0/0"

db_password      = "StrapiDemoPass123!"
app_keys         = "key1,key2,key3"
jwt_secret       = "SomeJWTSecret"
admin_jwt_secret = "SomeAdminSecret"
api_token_salt   = "SomeApiTokenSalt"

