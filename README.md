# drone-ecr-auth

This docker image is used for Drone authentication to AWS ECR service.
It is a basic container using a docker image with AWS CLI installed so that CLI commands can be run within the container.
It can push/pull container images using the `docker push` or `docker pull` commands.

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
      - AWS_REGION=eu-west-2
    secrets:
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_ACCOUNT
    commands:
      - $(aws ecr get-login --region eu-west-2 --no-include-email)
      - docker push $${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/foo:${DRONE_COMMIT_SHA}
    when:
      event: push
```

In drone CI pull

```
  pull_from_ecr:
    image: wirelab/drone-ecr-auth:v1
    environment:
      - DOCKER_HOST=unix:///drone/docker.sock
      - AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
      - AWS_REGION=eu-west-2
      secrets:
        - AWS_ACCESS_KEY_ID
        - AWS_SECRET_ACCESS_KEY
        - AWS_ACCOUNT
    commands:
      - $(aws ecr get-login --region eu-west-2 --no-include-email)
      - docker pull $${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/foo:${DRONE_COMMIT_SHA}
      - docker run -d -p 8181:80 --net net-network_default --name=web_development registry_url:${DRONE_COMMIT:0:8}
    when:
      event: push
```

Please register `aws_access_key_id` and `aws_secret_access_key` in secrets, and specify environment.
After that, you can pull the image after doing `$ (aws ecr get-login --region eu-west-2 --no-include-email)` to pass authentication in commands.
