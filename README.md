# drone-ecr-auth

This docker image is used for Drone authentication to AWS ECR service.
It is a basic container using a docker image with AWS CLI installed so that CLI commands can be run within the container.
It can push container images using the `docker push` command.

## pre-reqs

It is assumed the Drone pipeline steps have got a service attached running `docker:dind`

```
services:
  docker:
    image: docker:dind
    command: [ '-H', 'unix:///drone/docker.sock' ]
    privileged: true
```

## dependencies

- Drone v0.8
- Docker
- AWS CLI
- AWS IAM credentials
- Existing repository in ECR

## usage
In drone CI push,

```
  push_to_ecr:
    image: wirelab/drone-ecr-auth:v1
    environment:
      - DOCKER_HOST=unix:///drone/docker.sock
      - AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
      - AWS_REGION=$AWS_REGION
    secrets:
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_REGION
      - AWS_ACCOUNT
    commands:
      - $(aws ecr get-login --region $${AWS_REGION} --no-include-email)
      - docker push $${AWS_ACCOUNT}.dkr.ecr.$${AWS_REGION}.amazonaws.com/foo:${DRONE_COMMIT_SHA}
    when:
      event: push
```

Please register `aws_access_key_id` and `aws_secret_access_key` in secrets, and specify environment.
After that, you can push the image after doing `$ (aws ecr get-login --region eu-west-2 --no-include-email)` to pass authentication in commands.
