# EpiDoc Validator API

EpiDoc Validator API provides an API interface for the
[EpiDoc Validator](https://github.com/perseids-tools/epi-doc-validator-rb)
JRuby library.

It accepts EpiDoc XML and returns JSON containing any errors.

## Running

### Docker Compose

#### Running a standalone server

```
docker-compose build
docker-compose up
```

#### Including in other compose files

Include `perseidsproject/epi-doc-validator-api` as one of your services in `docker-compose.yml`.
The simplest version would be:

```yaml
version: '3'
services:
  validator:
    image: perseidsproject/epi-doc-validator-api:v1.0.1
    ports:
      - "1600:1600"
```

The port can be customized using the `PORT` environment variable.
For example, if you want to run on port 3000:

```yaml
version: '3'
services:
  validator:
    image: perseidsproject/epi-doc-validator-api:v1.0.1
    environment:
      - PORT=3000
    ports:
      - "3000:3000"
```

(See project on [Docker Hub](https://hub.docker.com/r/perseidsproject/epi-doc-validator-api/).)

### Unix/Linux

Requirements:

- JRuby (~9.2.11)
- Bundler

```bash
bundle install
bundle exec ruby app.rb
```

## Usage

The `/validate` endpoint accepts a POST request with the EpiDoc XML to be validated.
It returns a JSON array of errors. If there are no errors, it returns an empty
array. By default, it will validate against the latest version of the schema.

To validate against a different version, add that version to the end of the path:
e.g. `/validate/9.1`.

The `/versions` endpoint accepts a GET request and returns a JSON array of
accepted versions.

### Examples

#### Validate a document

`curl -X POST -d '@./spec/fixtures/files/valid_doc.xml' http://localhost:1600/validate`

```json
[]
```

`curl -X POST -d '@./spec/fixtures/files/invalid_doc.xml' http://localhost:1600/validate`

```json
[
  "-1:-1: ERROR: unknown element \"incorrect\" from namespace \"http://www.tei-c.org/ns/1.0\""
]
```

#### Validate against a particular schema version

`curl -X POST -d '@./spec/fixtures/files/valid_9.xml' http://localhost:1600/validate/8.23`

```json
[
  "-1:-1: ERROR: attribute \"toWhom\" not allowed at this point; ignored"
]
```

#### Get a list of schema versions

`curl http://localhost:1600/versions`

```json
[
  "8",
  "8-rc1",
  "8.2"
  ...
  "dev",
  "latest"
]
```
