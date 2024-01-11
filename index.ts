#!/usr/bin/env node

import { Commit } from 'commit'; // Custom type
import fetch from 'node-fetch';

const DATA = {
    sha: process.env.GITHUB_SHA,
    owner: process.env.GITHUB_REPOSITORY_OWNER,
    api_url: process.env.INPUT_API_URL,
    webhook: process.env.INPUT_DISCORD_WEBHOOK,
    title: process.env.INPUT_TITLE,
};

if (DATA.api_url && DATA.owner && DATA.sha) {
    const API_URL = DATA.api_url
        .replace('$OWNER', DATA.owner)
        .replace(
            '$REPO',
            process.env.GITHUB_REPOSITORY?.replace(`${DATA.owner}/`, '') || '',
        )
        .replace('$REF', DATA.sha);

    const commitInfo = await (await fetch(API_URL)).json() as Commit;

    const commit = JSON.stringify({
        content: null,
        embeds: [{
            title: DATA.title,
            description: commitInfo.commit.message,
            url: commitInfo.html_url,
            author: {
                name: commitInfo.author.username,
                icon_url: commitInfo.author.avatar_url,
            },
        }],
    });

    const post = await fetch(`${DATA.webhook}?wait=true`, {
        method: 'post',
        body: commit,
        headers: { 'Content-Type': 'application/json' },
    });

    console.log(await post.text());
}
