---
title: "Developing my engineering practices and tooling for software creation with agents"
description: "Coding is solved. But engineering practices aren't. What is Claude Code missing? Even for small pet projects, I crafted several documents describing my approach and scripts to enforce it."
date: 2026-10-19T16:27:00.000Z
---

# Developing my engineering practices and tooling for software creation with agents

## Introduction

Yeah, coding is solved. But engineering practices aren't. The more codebase, the more engineering we need. How to review a finished part of the work. How to work with Git branches. How to plan the feature, split the job between humans and agents, and work with bugs, issues, and the backlog. Who will gather requirements, and who will prioritize what to do and what not to do?

Are there any best engineering practices for developing software that uses AI agents? I don't think so, although AI Frontier Labs and other teams are currently working actively on this. CI/CD, coding harnesses, skills, and spec-driven development are good examples, but in reality I see a huge lack of tooling in this area. To learn what I need, I worked on a pet project: a router (Ilirium LLM Router) for several weeks. The router sits between Claude Code and LLM APIs: I wanted to use different local LLM models and all Anthropic models simultaneously, while saving observability metrics and a requests/responses corpus.

My goal was twofold: build a router I could actually use, and learn what Claude Code is missing.

As I mentioned above, the agent doesn't know exactly how I want to work with Git branches, divide the project into parts, document decisions, conduct plan and code reviews, and much more. Below, I'll describe the problems I encountered in more detail and how I solved them.

In reality, I didn't solve all my programming issues with the agents. But I realized I needed to write my own tools. For example, the most annoying problem holding me back was the links between Markdown files, tasks, and backlog items. In the end, I built a small tool to check the links between Markdown files, but that's only part of the problem. Another issue: I want the plan to be comprehensive so the agent doesn't have any questions for me during implementation.

## Engineering practices

Here is a general overview of my workflow. I start with an idea for a feature, briefly describe it, and pass it to the agent. I ask the agent to analyze it, identify gaps, issues, or inconsistencies, and interview me. The goal is to end the planning process with a documented plan that captures all decisions and defines names for necessary code objects (commands, constants, settings, etc.: essentially the interface a user interacts with when using the router). With this plan, the agent can implement the feature without needing to ask me further questions during the process. However, sometimes questions do arise that couldn't have been foreseen.

So, while drafting the plan, the agent asks me questions and proposes options. If a question or a set of options is unclear, I ask for clarification. It often happens that the agent's text (descriptions, questions, options) is unclear – for instance, referencing vague points (too brief, no source cited) or describing objects buried deep within the documentation or earlier in the current discussion. I clarify these points using specific prompts (I have a ready-made snippet for this!). Once we have both answered each other's questions, we have a set of agreed-upon decisions. The agent then saves the implementation plan for the phase. A "phase" consists of either a single feature or a group of small features. The plan itself is composed of task groups and the individual tasks within them. A "milestone" encompasses multiple phases. Before execution, the plan undergoes a review. The review procedure is outlined in document [IDM-004](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/method/IDM-004-reviewing-unexecuted-work.md). Once all planned work is complete, a review of the entire body of work takes place ([IDM-009](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/method/IDM-009-reviewing-executed-work.md)).

During plan implementation, the agent records notes (in [notes.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/milestone-2-corpus/phase-13-method-and-backlog/notes.md) and a separate [notes-group-X.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/milestone-2-corpus/phase-13-method-and-backlog/notes-group-a.md) file for each task group). A [for-the-owner.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/milestone-2-corpus/phase-13-method-and-backlog/for-the-owner.md) document is also created, containing key information the agent deems necessary for the human to review after implementation finishes, since the raw note files (notes.md and notes-group-X.md) contain too much detail. These notes serve to facilitate a handoff, ensuring that if issues arise, the session can be restarted and work resumed from the last stopping point.

The [prompt.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/prompt.md) file is updated either when the human explicitly requests it (e.g., to wrap up the workday) or when the agent suggests an update after completing a specific phase.

The [status.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/status.md) file provides a concise overview of the project's state.

Work on a phase is carried out in a dedicated Git branch. Upon completion, the phase is merged into the main branch. Documents from completed phases aren't updated during work on subsequent phases; they reflect the project's history rather than the current specification. I believe maintaining a separate, fully up-to-date specification for the entire project has little value, as the code and such a specification would inevitably diverge. The specification serves as a well-documented work plan. Additionally, separate records are kept for bugs, ideas, future tasks (backlog), and proposals for specific features. Several reference documents also cover key architecture points and decisions.

Work sometimes begins with developing an EPD ([Engineering Project Document](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/epd)) or by addressing a specific bug or backlog item.

## Conclusion

Overall, even without applying the engineering practices described, I still could have developed a router. However, I would have had to exercise much more manual control over the agent and proceed in smaller steps. So the engineering practices described do work. Now I know exactly what’s missing. It’s a well-thought-out system for linking documents and items, and a toolkit that enforces the agent’s adherence to engineering practices. I’ve already started working on such a toolkit. It will be something like a combination of Git, Jira, and CI/CD, plus the skills needed for agents to understand how to use it.

## Appendix: Structure of the repo and documents

The resulting structure of the repository and the documents describing engineering practices are outlined below. Some folders and files, such as `Makefile` and `pyproject.toml`, are omitted because they relate to the code rather than the specifications and documentation.

---

- [ilirium_llm_router/](https://github.com/ilirium/ilirium_llm_router) = The project and Git repository
	- [docs/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs):
		- [bugs/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/bugs) = One document is one bug.
		- [epd/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/epd) = Enhancement Proposal Documents, it's my RFC.
		- [method/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/method) = Ilirium Development Method, several documents, like how to work with branches, review plans and executed work, track a register, and so on.
		- [milestone-1-core/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/milestone-1-core) = Implementation plans for each phase (feature), notes, lessons, evidences.
		- [milestone-2-corpus/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/milestone-2-corpus)
		- [procedures/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/procedures) = Tooling to help to work with Markdown files, additional helpful tools to develop the router, etc.
		- [reference/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/reference) = It contains main architecture points and decisions.
		- [wiki/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/wiki)
		- [README.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/README.md) = It contains several engineering practices that would be worth describing in separate documents, but I decided not to spend time on them.
		- [backlog.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/backlog.md) = One heading per a backlog item.
		- [backlog-done.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/backlog-done.md)
		- [prompt.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/prompt.md) = For handoff between sessions.
		- [status.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/status.md) = Status of the phase.
	- srs/
	- tests/
	- CHANGELOG.md
	- CLAUDE.md = A short set of most important instructions for agent with links with deeper descriptions in documents
	- README.md = The root README.md, the general description of the project, why it was created, what tasks it solves, how to use and so on.

---

[Ilirium Development Method](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/method) (the `docs/method/` folder):
- IDM-000-about-these-documents.md
- IDM-001-git-branching.md
- IDM-002-harness-configuration.md
- IDM-003-development-tooling.md
- IDM-004-reviewing-unexecuted-work.md
- IDM-005-opening-a-milestone.md
- IDM-006-closing-a-milestone.md
- IDM-007-raising-a-concern.md
- IDM-008-the-register.md
- IDM-009-reviewing-executed-work.md
- IDM-010-writing-for-the-owner.md
- IDM-011-the-backlog.md
- And [docs/README.md](https://github.com/ilirium/ilirium_llm_router/blob/main/docs/README.md) for other small method additional rules and recommendation about engineering practices. They should be split to documents under the IDM folder in the future. But I didn't do this yet, since writing one IDM document requires a day of work. I wanted to finish the router first.

---

[Enhancement Proposal Document](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/epd) (the `docs/epd/` folder):
- EPD-000-about-these-documents.md
- EPD-001-model-selection-and-mixed-model-sessions.md
- EPD-002-token-counting-for-local-backends.md
- EPD-003-capturing-bodies-for-a-corpus.md
- EPD-004-documentation-structure.md

---

The example of one of the phase:
- [docs/milestone-2-corpus/](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/milestone-2-corpus)
	- implementation-plan.md = The plan for the Milsetone.
	- phase-13-method-and-backlog/
		- evidence/ = Logs, pice of data, small scripts and tools useful for this phase.
		- for-the-owner.md
		- notes.md
		- notes-group-a.md
		- notes-group-b.md
		- notes-review-jobs-done.md
		- notes-review-plan.md
		- plan.md
		- review-charter.md
		- review-charter-jobs-done.md

---

The [reference](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/reference) (the `docs/reference/` folder):
- architecture.md
- backend-anthropic.md
- backend-lmstudio.md
- branches.md
- corpus.md
- design-decisions.md
- lessons.md
- measurements.md
- observability.md
- README.md

---

The [wiki](https://github.com/ilirium/ilirium_llm_router/tree/main/docs/wiki) (the `docs/wiki/` folder):
- background-work-in-fastapi.md
- claude-code-auto-mode.md
- claude-code-context-budget.md
- claude-md-scopes-and-precedence.md
- reading-a-c-extension-binary.md
- zstandard-and-libzstd.md
- README.md
