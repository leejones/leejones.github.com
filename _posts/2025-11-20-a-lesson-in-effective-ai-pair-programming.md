---
title: A Lesson in Effective AI Pair Programming
date: 2025-11-20
layout: post
excerpt: Effective AI pair programming leverages human experience instead of mindlessly clicking "accept".
---

Effective AI pair programming leverages human experience instead of mindlessly clicking "accept".

Andy Osmani's book [Beyond Vibe Coding](https://beyond.addy.ie) describes 3 ways of working with AI effectively:

* **First drafter** - AI creates the code, you refine it.
* **Pair programmer** - You + AI collaborate to create the code and refine it.
* **Validator** - You create the code, AI helps you refine it.

I took the pair programmer approach when I added CI to my [kubectl-nearby](https://github.com/leejones/kubectl-nearby) project and learned a valuable lesson.

**Starting strong**

AI created a sensible looking GitHub Actions config and it even worked.  Nice! 😎 The config included a caching step to optimize latency.  Extra nice! 🤩 I almost stopped there, but I decided to dig deeper since I'm not familiar with GitHub Actions.  I'm committed to understanding and being responsible for code I commit (AI generated or not).  I'm familiar with other CI systems like Buildkite and Jenkins so I had a general understanding of what was happening.  I carefully reviewed the config and asked a few targeted questions to understand better.  

**Maintenance issue**

I noticed a hardcoded Go version in the CI config.  Based on experience, I knew this was likely to fall out of date over time so I asked AI to update the CI config to extract the Go version from the `go.mod` file since it's effectively the source of truth.  It quickly added a step to do this.  I iterated on that further, removing the default version fallback it generated (to avoid confusion).  It used [outputs](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/pass-job-outputs) to pass the detected Go version between steps.  Neat stuff.  I'll file that away for the future.  For visibility and easier debugging, I asked it to log the version it found to the build log.  It mentioned annotations would provide visibility in the GitHub Actions UI so I chatted with it to learn more about those.  I asked it to use an annotation for the version.  Worked well!

**Caching is broken**

However... in addition to the version annotation, I noticed 10 error annotations and 2 warnings from the caching step.  I gave the AI an example error with some context and it said a previous step may be populating directories used by the cache.  Hmm... 🤔 This is suspicious.  It said the agent environment is ephemeral so it should have a clean working directory...  The previous step was `setup-go`.  Could that be doing something with dependencies?  Could it be using the cache?  AI selected `setup-go@v4`.  Is that the latest version?  I briefly looked at the GitHub repo for [actions/setup-go](https://github.com/actions/setup-go) and saw that `@v6` is the latest.  I asked the AI to look at the latest docs for `setup-go` because it seems like the separate caching step may be redundant.  It read the latest README and confirmed that the newest `setup-go` has caching built-in.  It also noticed that that the newest version had an option to detect the Go version dynamically from `go.mod`.  Perfect!  I collaborated with AI to update to `v6` and this significantly simplified the config.  Now it's truly nice!

**Better pairing**

I could clicked "accept" and shipped the original vibe-coded version with minimal/no review since it "worked", but it would be costly in the long run.  The config was more complicated than it needed to be and I would have learned nothing.  When I needed to edit the config in the future I would be starting from zero and would be reliant on AI.  It probably would have continued with the v4 version (presumably because that's what's most prominent in the training data) and accumulated more workarounds leading to a vicious cycle of difficult-to-maintain code.  My AI pair programming session was more effective once I leveraged my human experience and judgement. 🙌
