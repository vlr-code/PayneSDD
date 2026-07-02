# PayneSDD benchmarks

A fixed task you run through PayneSDD after any big change to the protocol, to
check the protocol still produces a good, verifiable result. Run it as a normal
request and compare the result against its checklist — by eye and by building it.

These are NOT automated unit tests of PayneSDD. They are a human-checkable
"does the protocol still cook" sanity run.

---

## Benchmark 1 — Image downloader (Swift / iOS)

### The task — give this to the agent verbatim

> I need a Swift project that can download images from a URL entered by the user
> and save them to the device, with the ability to view the saved images. It needs
> error handling and a simple but modern, high-quality UI.

### What "pass" looks like — check by building and by eye

- [ ] User can type or paste a URL and start a download.
- [ ] A valid image URL downloads and the image is saved on the device.
- [ ] Saved images can be viewed in the app (a list or grid, plus a full view).
- [ ] Errors are handled and shown clearly — bad URL, no network, the link isn't
      an image, save failed — and the app never crashes or freezes.
- [ ] The UI is clean and modern (not raw default controls): sensible layout, a
      loading indicator while downloading, and an empty state when nothing is saved.
- [ ] The agent actually ran the protocol on it: a contract first, a real gate
      (it builds / tests pass), and an honest verdict — not just "here's some code".

### How to run it

1. Start a fresh session with the new version of PayneSDD in place.
2. Paste the task above.
3. Watch that the protocol runs: a tier is picked, consent is asked before code,
   the gate runs, a verdict is given.
4. Build and run the result, then walk the checklist above. Anything unchecked is
   a regression to look at.

### Note on the machine gate

This task is an iOS app, so a real gate needs a Mac with **full Xcode** (not just
Command Line Tools) and an iOS simulator. Before declaring that gate unavailable,
the agent must check what's actually INSTALLED — not just the active/default
selection (Step 4). If the toolchain is genuinely heavy or absent, it must ASK
the human: run the FULL gate, or a LIGHTER one (built-in runner for the logic,
the rest soft/by-eye) — and record which ran. Only when neither is possible does
the protocol say escalate, not fake a pass.
