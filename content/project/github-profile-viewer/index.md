---
title: Github Profile Viewer
summary: A react app for visualizing Github Statistics
abstract: ""
date: "2020-02-16"
image:
  preview_only: true
links:
  - icon: github
    icon_pack: fab
    name: Code
    url: https://github.com/qiushiyan/github-profile-viewer
  - icon: react
    icon_pack: fab
    name: App
    url: https://gh-profile-viewer.netlify.app/

tags:
  - Web-Dev
  - React
---

[Github Profile Viewer](https://gh-profile-viewer.netlify.app/) presents a quick image of any github user's public work, i.e, personal information, followers, repository statistics.

<figure>
  <img src = "featured.jpg" />
</figure>

The app is developed with React using the Github API, charts are generated via [Fusion Charts](https://www.fusioncharts.com/).

<figure>
  <img src = "repo-viz.jpg" />
  <figcaption>most used languages, most forked repos ...</figcaption>
</figure>

<div class = "note">
You don't need to login to use this app, though unauthenticated users might have to share a 60-requests-per-hour rate limit.
</div>
