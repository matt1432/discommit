# Discommit

Example of an action from a different git server (This one uses forgejo)

```yaml
name: Discord

on:
  - workflow_dispatch
  - push

jobs:
  discord_commits:
    runs-on: ubuntu-latest
    name: discord commits
    if: contains(github.event.head_commit.message, '(servers)')

    steps:
      - name: Discommit
        uses: https://github.com/matt1432/discommit@v0.0.2
        with:
          discord_webhook: ${{ secrets.DISCORD_WEBHOOK }}
          api_url: 'https://git.nelim.org/api/v1/repos/$OWNER/$REPO/git/commits/$REF'
          title: 'New commit containing changes to server configs:'
```

This is the result:

![image](https://github.com/matt1432/discommit/assets/98562002/0e09a025-1659-4296-a565-377b318177d2)


## TODO

- cachix builds
- add more customization to embed
- add Docs
