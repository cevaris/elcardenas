#!/bin/sh

export S3_BUCKET=www.elcardenas.com

# Run Jekyll
echo "-> Running Jekyll"
./build.sh

# Upload to S3!
echo "\n\n-> Uploading to S3"


# Sync media files first (Cache: expire in 10weeks)
echo "\n--> Syncing media files..."
s3cmd sync --acl-public --exclude '*.*' --include '*.png' --include '*.jpg' --include '*.ico' --add-header="Expires: Sat, 20 Nov 2020 18:46:39 GMT" --add-header="Cache-Control: max-age=6048000"  _deploy/ s3://www.elcardenas.com

# Sync Javascript and CSS assets next (Cache: expire in 1 week)
echo "\n--> Syncing .js and .css files..."
s3cmd sync --acl-public --exclude '*.*' --include  '*.css' --include '*.js' --add-header="Cache-Control: max-age=604800"  _deploy/ s3://www.elcardenas.com

# Sync html files (Cache: 2 hours)
echo "\n--> Syncing .html"
s3cmd sync --acl-public --exclude '*.*' --include  '*.html' --add-header="Cache-Control: max-age=7200, must-revalidate"  _deploy/ s3://www.elcardenas.com

# Sync everything else, but ignore the assets!
echo "\n--> Syncing everything else"
s3cmd sync --acl-public --exclude '.DS_Store' --exclude 'assets/'  _deploy/ s3://www.elcardenas.com

# Sync: remaining files & delete removed
s3cmd sync --acl-public --delete-removed  _deploy/ s3://www.elcardenas.com