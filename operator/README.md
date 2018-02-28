# Operating the Foundry

## Creating a lab environment

You can create a lab environment for multiple students in AWS by first cloning this repository (the clone is important):

*Note:* The VPC is deployed to `us-east-1` by default. To deploy to a different region set the environment variable `$AWS_REGION`

```sh
git clone --recursive https://github.com/EngineerBetter/summit-training-classes.git
cd summit-training-classes/operator
./scripts/create-vpc.sh $NUMBER_OF_STUDENTS
```

This creates the file `terraform/students.json` which contains an array of objects containing settings for an independent BOSH Lite v2 deployments.

To generate zip files for each of the students containing their credentials run:

```sh
cd scripts
ruby create_zips.rb ../terraform/students.json
```

This will create a `students` directory in the directory where the script is run, with zip archives for each student. Each zip archive contains a `private_key.pem` and a `export_vars`. The latter should be sourced by the student to export the necessary environment variables.

If you would like deploy the BOSH environments (rather than letting the students do it), you can use the following command:

```sh
jq -c '.[]' terraform/students.json | while read -r info
do
    ./scripts/deploy-bosh.sh "$(jq -r '.access_key_id' <<< "$info")_" <<< "$info"
done
```

## Deleting a lab environment

If the BOSH environments were deployed using the command above then they can all be deleted using the following:

*If you have run `source create_env` beware that your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env vars will have been overwriten with ones for a student.*

```sh
./scripts/destroy-all-bosh.sh
```

Delete the VPC with:

```sh
./scripts/delete-vpc.sh $NUMBER_OF_STUDENTS
```

## Key Narratives

Availability
Scale
Immutability


BOSH as a day 2 solution
- availability
- updates
- scaling

CF
-
