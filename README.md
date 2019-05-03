# drone-gcs-sync

Runs `gsutil -m rsync` command.

## Docker

Build the Docker image with the following commands:

```
docker build --rm=true -t quintoandar/drone-gcs-sync .
```

## Usage

Execute from the working directory:

```
docker run --rm \
  -e PLUGIN_BUCKET=my-bucket \
  -e PLUGIN_TARGET=bucket/target/folder \
  -e PLUGIN_SOURCE=my/local/folder \
  -e PLUGIN_DELETE=false \
  -e PLUGIN_DRY_RUN=true \
  -e GOOGLE_APPLICATION_CREDENTIALS=... \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  quintoandar/drone-gcs-sync
```

On a Drone pipeline (tested with 0.8.5):

```
  tag:
    group: publish
    image: quintoandar/drone-gcs-sync
    bucket: my-bucket
    target: bucket/target/folder
    source: my/local/folder
    delete: false
    dry_run: true
    secrets:
        - google_application_credentials
    when:
      branch: ["master"]
      event: ["push"]
```

## Parameters

| env var                        | key     | value                                                                                                                                    |
| ------------------------------ | ------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| PLUGIN_BUCKET                  | bucket  | Google Cloud Storage bucket name (*without* prefixing gs://)                                                                             |
| PLUGIN_TARGET                  | target  | Google Cloud Storage target path                                                                                                         |
| PLUGIN_SOURCE                  | source  | Local source path to sync from                                                                                                           |
| PLUGIN_DELETE                  | delete  | If *true* (default is _false_) will delete files in target destination that are not present in the source folder. Use with extreme care! |
| PLUGIN_DRY_RUN                 | dry-run | If *true* (default is _false_) Google Cloud Storage bucket name (*without* prefixing gs://)                                              |
| PLUGIN_DEBUG                   | debug   | If *true* (default is _false_) will run script with "set -x", printing each command (but will not print credentials)                     |
| GOOGLE_APPLICATION_CREDENTIALS | -       | The Google Private Key credentials in json format with the needed storage roles.                                                         |
## Warning

The `PLUGIN_DELETE` is akin to running `gsutil -m rsync -d ...`. It is a very useful and commonly used command, because it provides a means of making the contents of a destination bucket match those of a source directory. However, please exercise caution when you use this option: It's possible to delete large amounts of data accidentally if, for example, you erroneously reverse source and destination.

When using `PLUGIN_DELETE`, always run with `PLUGIN_DRY_RUN` to make sure you will not be removing more content than desired.
