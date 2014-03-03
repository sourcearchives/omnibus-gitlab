# Omnibus-gitlab release process

Our main goal is to make it clear which version of GitLab is in an omnibus package.

## On your development machine

- Pick a tag of GitLab to package (e.g. `v6.6.0`).
- Create a release branch in omnibus-gitlab (e.g. `6-6-stable`).
- Change [the gitlab-rails version in omnibus-gitlab].
  In our example that would be `version "v6.6.0"`.
- Commit the new version to the release branch

```shell
git commit -m 'Pin GitLab to v6.6.0' config/software/gitlab-rails.rb
```

- Create an annotated tag on omnibus-gitlab corresponding to the GitLab tag.
  GitLab tag `v6.6.0` becomes omnibus-gitlab tag `6.6.0.omnibus`.

```shell
git tag -a 6.6.0.omnibus -m 'Pin GitLab to v6.6.0'
```

- Push the branch and the tag to the main repository.

```shell
git push origin 6-6-stable 6.6.0.omnibus
```

## On the build machines

- Install release dependencies

```shell
# Ubuntu
sudo apt-get install python-pip

# CentOS
curl -o epel-release-6-8.noarch.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh epel-release-6-8.noarch.rpm
sudo yum install python-pip

# Both
sudo pip install awscli
aws configure # enter AWS key and secret
```

- Check out the release branch of omnibus-gitlab.

```shell
git fetch
git checkout 6-6-stable
```

- Check the system time; the S3 upload will fail if it is off by too much

```shell
date
```

You can adjust the time with the `date` command if necessary.

- Run the release script

```shell
./release.sh
```

This will `clean --purge` the build environment, build a package and upload it to S3.

[the gitlab-rails version in omnibus-gitlab]: ../config/software/gitlab-rails.rb#L20
