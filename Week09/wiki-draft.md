# Week 09 — Multi User Experience 1

**Homework:** [Week09/SpotLobby](https://github.com/jackienamdesign/molab-2026-itp-jackie/tree/main/Week09/SpotLobby)

`[screenshot: Match and Floor tabs]`

## Part 1: final project proposal, first draft

**Concept: the phone app for my thesis.** My thesis is a small device you hold, press and talk
to when something happens with your health. It answers with light and asks one follow-up
question at a time. It never gives advice or a diagnosis. The goal is to help someone arrive at
a doctor's visit better prepared. My thesis notes already say that what people say goes to "a
separate app built later". For my final, I want to build the main functions and core screens of
that app, instead of waiting until spring.

Core screens:

1. **Talk:** hold to talk and save a note. The phone mic stands in for the device for now
2. **Sessions:** everything I've said, newest first
3. **Session detail:** what I said and the questions I was asked
4. **Visit prep:** what happened since my last visit, organized so I can go through it with my doctor
5. **Share:** a page I can show or print for the visit

Rules I'm keeping from the thesis:

- No advice and no diagnosis, only questions and organizing
- The fixed safety line stays: "If this feels like an emergency, please speak to a professional
  or someone nearby."
- Health notes stay on the phone. So this uses local saving from Weeks 05 to 06, **not** Firebase
- Mock content or my own voice only, no real patient information

Week by week:

| Week | Date | Goal |
| :--- | :--- | :--- |
| 11 | 11-12 | Talk, Sessions and Session detail with recording and local saving |
| 12 | 11-19 | Voice to text, so a session has a transcript |
| 13 | 12-03 | Visit prep and Share |
| 14 | 12-10 | Polish and present, showing the whole system one link at a time |

What I don't know yet:

- **How the device reaches the phone.** Wi-Fi or Bluetooth is still undecided in my thesis.
  Bluetooth needs Core Bluetooth, which isn't in this class. For the final I can start with the
  phone mic, the first step in the build order Tom Igoe suggested
- **Organizing the notes with AI.** My WWDC research points to SpeechAnalyzer and Foundation
  Models, which stay on the phone. That fits the privacy rule better than sending notes to
  Gemini, but Foundation Models needs an Apple Intelligence phone `[placeholder: assuming mine supports it, check in Settings]`
- **Who it's for.** Still open in my thesis. For now: adults with ongoing health issues who
  want to remember what happened between visits `[placeholder: my thesis audience isn't decided]`

Questions for class `[placeholder: swap in my own]`:

- Is it OK to start with the phone mic and connect the device later?
- What's the simplest way to save voice notes on the phone?
- Is five screens too many for four weeks?

## Part 2: SpotLobby

I chose Option 2 and customized MoLobby for the ITP floor. You often get to the floor and every
good seat is taken, and you can't tell what's open until you walk it. Each area is good for
different things:

| Area | Good for | Tradeoff |
| :--- | :--- | :--- |
| Kitchen | Kitchen, close to the shop | Noisy, lots of foot traffic |
| Shop | 3D equipment, wood shop, soldering, soft lab | Often taken |
| ER | Open tables for working together, quieter | Separate from the shop, but you can walk over |
| Design Lab | Quiet, wide open seating | Very far from the shop |

**Match** asks four quick questions: are you in the mood to collaborate, do you need the shop,
do you have a group project, do you want solo time. **Floor** shows how many people are in each
area right now, and you tap I'm here or I left.

How it works:

- Checking in saves two new fields on my user document in Firestore: `zone` and `zoneDate`
- Saving uses the same `setData(values, merge: true)` as `updateUser` in the sample
- I didn't write any live update code. The sample's `addSnapshotListener` already sends every
  change to every phone, and the counts are worked out from that list
- `rankZones` is a chain of ifs where the first match wins, so **the order is the design**, like
  `pickEmoji` last week. It gives a list of areas, best first, and `pickZone` takes the first one
  with a free seat
- A check in expires after 3 hours, in case someone forgets to tap I left

## Issues and errors

- `GoogleService-Info.plist` can't go in my public repo, so it's gitignored. To run this you
  need it from 98-MoGallery-Private
- Xcode needs several GB to build Firebase, and my disk filled up on the first build
- The seat numbers are guesses until I count them on the floor: Kitchen 12, Shop 10, ER 16,
  Design Lab 20 `[placeholder: count the real seats]`
- I haven't run it on my phone yet `[placeholder: add anything I hit when I do]`

**Hours:** 6 `[placeholder: my real hours]`

## Plans and questions

- **"Good time to go" only means right now.** I want it to say when a good time is, but that
  needs check ins saved over days
- Only people who check in get counted, so it's only as accurate as how many people use it.
  Could something count people automatically?
- Should a check in expire after 3 hours, or should it end when you leave the floor?
  `[placeholder: swap in my own question]`

## AI use

Per the course AI policy: the floor concept and the questionnaire are mine. I used Claude Code
to read MoLobby and scaffold the changes, which are marked `Week09:` in the code so I can show
what is the sample's and what is mine. Claude also drafted this page from my notes and my thesis
documentation, and I `[placeholder: say what I reviewed and changed]`.
