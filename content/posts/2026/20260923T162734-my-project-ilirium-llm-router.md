---
title: "My project: Ilirium LLM Router"
description: "Router to use different local LLM models and all Anthropic models simultaneously in one Claude Code session. Saving telemetry for observability and a corpus of all raw requests and responses for later analysis."
date: 2026-09-23T16:27:34.812Z
draft: true
---

Let's imagine: you want to use Claude Code simultaneously with their models and your own local models. Claude Code does not allow you to do this by design. Several weeks ago, I faced this problem. Hmm, I had thought that there should be some open-source project that solves this problem. Yes, and no. There is Claude Code Router. They advertise this function, but due to their bug, it simply doesn't work, ha ha. I tried another solution, LiteLLM. But it's a fucking crazy complex product to configure for such a simple task.

So, I decided to write my own router to experiment with how exactly I can split workload between Anthropic models and popular open-source LLMs. For the past few weeks, I developed the router and added two more features: saving all raw requests and responses in the corpus, compressing them using ZSTD with daily dicts. And saving telemetry for observability. The corpus can be used later for analysis and LLM and agentic harness debugging. It is also compatible with your Anthropic subscriptions: the router just passes through your credentials.

This development was fun. I decided not to read or write code at all, only operating by prompts and documents. During these weeks, I, with agents, crafted dozens of documents to improve our engineering process. All implementation plans were written and reviewed before any work. During the implementation, the agent saves implementation notes.

I open-sourced the whole router, my engineering process, and docs: https://github.com/ilirium/ilirium_llm_router

I didn't use any skills, just plain Claude Code. The structure of my engineering process:

./docs:
- bugs/
- epd/ = Enhancement Proposal Document
- method/ = Ilirium Development Method, several documents, like how to work with branches, reviewing plans and executed work, how to track a register and so on.
- milestone-1-core/
- milestone-2-corpus/
- procedures/
- reference/
- wiki/
- backlog.md + backlog-done.md
- prompt.md = for handoff between sessions
- status.md

---

**Discus on** [**LinkedIn**](https://www.linkedin.com/posts/ilirium_lets-imagine-you-want-to-use-claude-code-share-7508562720061882370-CK0C/)