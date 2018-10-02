# CI/CD

## Setting the pipeline

Target and log in to your Concourse then set the pipeline with

```sh
fly -t YOUR_CONCOURSE set-pipeline \
    --pipeline basics-course \
    --config pipeline.yml \
    --load-vars-from pipeline-vars.yml
```

When setting your pipeline you must also make sure the following values are available either by passing them with `--var` in the command above or by putting them in your Concourse's credential manager (i.e. Credhub/Vault/etc)

```yaml
cf-api
cf-username
cf-password
cf-org
cf-space
```

Note if you want to pull from a fork rather than from the CFF repo, create your own `custom-vars.yml` file with:

```yaml
course-repository: YOUR_FORK
routes: '[route: a-custom-route.example.com]'
```

Then set the pipeline using that instead of `pipeline-vars.yml`
