# TildesAutolinkerBot

In Discord, replies to certain formats with links to the Tildes Gitlab repository.

## Installation

Add a .env file containing
```
discord_token = your-bot-token
gl_token = your-personal-access-token
defaultrepo = your-project-id

additionalrepo = another-project-id
yetanotherrepo = project-id-thing
seeabove = la-id-du-project
```
After that, plain old `shards build` and run.

## Development

Run `crystal tool format` before committing.

## Contributors

- [deing](https://github.com/your-github-user) - creator and maintainer
