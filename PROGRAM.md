---
title: "Reproducible science, best practices and ICES Transparent Assessment Framework"
author:
  - Iago Mosqueira (WMR), <iago.mosqueira@wur.nl>
  - Colin Millar (ICES), <colin.millar@ices.dk>
date: "5-7 September 2022"
---

# Course goals

- Be able to create and populate a TAF repository for any analysis.
- Use git for version control, development and collaboration.
- Create all required outputs (tables and figures) from both stock assessment and advice forecast.
- Report on the work carried out using markdown.

# Workflows

1. catch + indices -> assessment -> WG report (inc. tables & plots)
2. assessment + forecast -> SAG
3. run + options -> forecast -> catch advice -> advice sheet (tables + plots)

# Ideas to be covered

- Reproducibility: to be able to rerun an analysis to check, correct or extend it, and generate the same output later on.
  - Analyses as code: all your steps should ( ideally) be in the oce pushed to TAF.
  - All inputs and tools available: any element, or its location, needed to run it is in TAF.
- Collaboration: work with others securely and easily.
  - Common workflow and steps: simplifies work division and communication.
  - Contributing to the same analysis: made simpler by git + TFA.
  - Conflict resolution: use git to solve conflicts, work offline and keep track of progress.
- Quality: check your analyses, on different setups and at differemt times.
  - TAF checks your work: coherence is assured by TAF server warning of any inconsistency.

# Timetable

- 09:00 - 10:30: Session 1
- 10:30 - 11:00: Coffee break and questions.
- 11:00 - 12:30: Session 2
- 12:30 - 13:30: Lunch break
- 13:30 - 15:00: Session 3
- 15:00 - 15:30: Coffee break and questions.
- 15:30 - 16:30: Session 4
- 16:30 - 17:00: Questions

# Agenda

## Day 1: Introduction to the tools, an example from input to report.

### Session 1: Welcome, TAF & git.

- Welcome
- Check setup
- Introduction to TAF
- Introduction to git

### Session 2: Dissecting a TAF repository

- The sol274 assessment repository

### Session 3: Create and populate your TAF repository

- DEMO: Creating and populating a new TAF repository.

### Session 4: Create and populate your TAF repository (cont.)

- EXTRA: Web services to access data.

## Day 2: Reporting in TAF using (R)markdown

- CATCH UP of day 1.

### Session 5: Intro to markdown for reporting

- Rmardkown, citeproc.
- Figures and tables.

### Session 6: From output to report.docx

- The report.Rmd template from icesdown

### Session 7: Creating the catch advice document.

- The sol274 forecast repository.
- EXTRA: Interactive plots and maps in HTML.

### Session 8: Documenting your own analyses

- OPEN SESSION, work on your own repository.

## Day 3: more TAF

- CATCH UP of day 2.

### Session 9-10: TAF extras

- TAF to SAG
- Organizing an analysis and using multiple projects
- Example stock assessments with SAM, FLSAM, FLXSA, a4a and SS

### Session 11: Review of repositories from the course

- User by user

### Session 12: Final recap and feedback.

# Some references

## Rmarkdown

- [rmarkdown cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/word-template.html)
- [rmarkdown formats](https://www.rstudio.com/blog/r-markdown-custom-formats/)
- [reviewer](https://docs.ropensci.org/reviewer/), track changes in rmarkdown.

## officedown

- [flextable book](https://ardata-fr.github.io/flextable-book/)
- [flextable reference](https://davidgohel.github.io/flextable/reference/index.html)
