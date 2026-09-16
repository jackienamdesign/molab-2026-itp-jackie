# molab-2026-itp-jackie

Class work for **Mobile App Development Lab**, NYU ITP, Fall 2026.
Instructor: jht9629-nyu. Each `WeekNN/` folder holds that week's homework.

Syllabus: <https://github.com/molab-itp/content-2026-itp>
Sample code org: <https://github.com/molab-itp> (also mirrored at `mobilelabclass-itp`)
Homework wiki: <https://github.com/molab-itp/content-2026-itp/wiki>

## The rule: stay at the week Jackie is at

This is coursework and the point is learning, not impressive code. **Do not introduce
language features or APIs from a later week than the one currently being worked on.**
Each `WeekNN/CLAUDE.md` lists exactly what has been covered through that week — treat
those lists as the complete allowed vocabulary.

Before helping with code, work out which week applies from the folder being edited and
read that week's `CLAUDE.md`. If the folder is ambiguous, ask.

If something genuinely cannot be done with that week's vocabulary, **say so and explain
the gap** — do not quietly reach for a more advanced tool. Naming the limit is useful
information; silently skipping ahead is not.

## Course schedule

Thursdays. Use the date to work out the current week.

| Week | Date       | Topic                          |
| :--- | :--------- | :----------------------------- |
| 01   | 2026-09-03 | Swift Programming 1, Intro     |
| 02   | 2026-09-10 | Swift Programming 2, iOS App   |
| 03   | 2026-09-17 | SwiftUI 1, Images              |
| 04   | 2026-09-24 | SwiftUI 2, Audio               |
| 05   | 2026-10-01 | Local Data 1, Sensors          |
| 06   | 2026-10-08 | Local Data 2, Files            |
| 07   | 2026-10-15 | Photo Media                    |
| 08   | 2026-10-22 | Video Media                    |
| 09   | 2026-10-29 | Multi User Experience 1        |
| 10   | 2026-11-05 | Multi User Experience 2        |
| 11   | 2026-11-12 | Final Project Proposal         |
| 12   | 2026-11-19 | Final Project Workshop 2       |
| 13   | 2026-12-03 | Final Project Workshop 3       |
| 14   | 2026-12-10 | Final Presentation and Review  |

**SwiftUI does not start until Week 03.** Weeks 01–02 are plain Swift and UIKit
drawing in playgrounds. Do not suggest `View`, `@State`, `Canvas`, or any SwiftUI
construct before then.

## Build on the teacher's sample code

Every week ships a reference playground from `molab-itp`. Start from the patterns in
those files and extend them; do not rewrite them in a different style. Sample pages
copied into this repo stay unmodified as reference — new work goes in new pages.

## Do not over-engineer

Match the samples' level, even where it is not production practice. Specifically, do
not add unless that week introduced it:

- Error handling beyond the samples' `try?` and force-unwraps
- `struct` / `class` / `enum` / protocols / extensions
- `async`/`await`, Combine, or any concurrency
- Generics, `guard` chains, or clever functional one-liners in place of a plain loop
- Abstractions "for reuse" — a playground page is a sketch, not a library
- Files, helpers, or configuration nobody asked for

Match the sample style: a top-of-page `//:` comment describing the page, `import`, then
top-level statements. Prefer the simple obvious form. Commented-out earlier attempts
are fine to keep — the samples do that to show the thinking.

## Explain, don't just produce

When adding code, name the sample page the technique came from so it connects back to
class material. Jackie has to be able to explain her own work in class.

The course AI policy requires citing AI tools as sources and being able to explain how
the use of them did not detract from the learning objectives. Keep help explainable and
attributable. Favor scaffolding and review over writing finished pages outright.

## Weekly checklist

Each week's homework is not done until:

- [ ] Work is in the correct `WeekNN/` folder
- [ ] Committed and pushed to `main`
- [ ] A link to the folder is added to the class wiki homework page for that week
- [ ] The wiki page documents hours, issues, and errors encountered

## Conventions

- One playground per week, new pages added for Jackie's own work
- New pages must be registered in the playground's `contents.xcplayground`
- `.DS_Store` and `**/xcuserdata/` are gitignored and never committed
