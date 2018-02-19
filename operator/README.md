# Operating the Foundry

## Creating a lab environment

You can create a lab environment for multiple students in AWS by first cloning this repository:

```sh
git clone --recursive https://github.com/EngineerBetter/summit-training-classes.git
cd summit-training-classes/operator
./scripts/create-vpc.sh $NUMBER_OF_STUDENTS
```

This creates the file `terraform/students.json` which contains an array of objects containing settings for an independent BOSH Lite v2 deployments.

If you would like deploy those BOSH environments (rather than letting the students do it), you can use the following command:

```sh
git clone https://github.com/cloudfoundry/bosh-deployment
jq -c '.[]' terraform/students.json | while read -r info
do
    ./scripts/deploy-bosh.sh "$(jq -r '.access_key_id' <<< "$info")_" <<< "$info"
done
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
