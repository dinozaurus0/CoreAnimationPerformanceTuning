#  Core Animations Optimizations

## Creating CALayers Off the Main Thread

- Simply creating or modifying `CALayers` on a thread other than the main thread can lead to issues.

- `CoreAnimation` provides some guardrails to help catch this during debugging. Two environment variables are useful here: one prints a stack trace to the console when a layer is touched off the main thread, and the other crashes the app at the exact line where this happens (see [Debug Environment Variables](#debug-environment-variables) above).

- "Touching" a layer's property from a non-main thread includes things like:
  - Changing `bounds`, `position`, `frame`, or any other layer property
  - Adding the layer as a sublayer to another layer
  - Adding an animation

- Even if we bypass these guardrails, problems can still occur. Manipulating the layer hierarchy from a background thread can result in the UI rendering incorrectly — in practice, this often shows up as missing layers or other parts of the UI failing to appear.

### Debug Environment Variables
- CA_DEBUG_TRANSACTIONS - prints in console the stack trace that generated the issue.
- CA_ASSERT_MAIN_THREAD_TRANSACTIONS - crashes app when the transaction is started from a background thread.

### Why This Happens

Whenever a layer is touched, `CoreAnimation` implicitly opens a `CATransaction` behind the scenes to track the changes — this is known as an *implicit transaction*. At the end of the current run loop iteration, this transaction is pushed by `CoreAnimation` to the `RenderServer`. If the thread on which the transaction was opened isn't associated with a `RunLoop`, the transaction never gets sent to the render server.

- In practice, it seems that only some layers added on a background thread end up being dropped. This is likely because the `CATransaction` was actually opened on the main thread — even though the changes were made from a background thread — and gets committed normally since the main thread is tied to a run loop.

- Side note: a `RunLoop` emits a notification when the current iteration finishes. `CoreAnimation` listens for this notification and commits the transaction at that point. If a thread has no associated run loop, the transaction likely never commits, which explains the rendering issues.

### Possible Solutions

**1. Batch animation construction on a background thread**

Build the animations on a background thread, batch them together, and then add them to the layer hierarchy on the main thread. This respects `CoreAnimation`'s rules around transactions, but in practice yields little to no performance improvement for a simple app. For something like the Lottie library, however, this could meaningfully help — since virtually everything in Lottie's CoreAnimation renderer is expressed as an animation. The layer hierarchy would still need to be created on the main thread, with all hierarchy operations happening there; only the animation *construction* would move to the background thread, while actually adding the animations to the layers would remain on the main thread.

**2. Manually manage a `CATransaction` on a background thread**

Manually open a `CATransaction` on a background thread, build the entire layer hierarchy there, and then attach it to the `UIView` (the actual UIKit update would still need to happen on the main thread). To create a custom transaction, you'd use `CATransaction.begin()` and `CATransaction.end()` — this pair should commit the transaction regardless of which thread it runs on.

> **Open question:** it's unclear whether this actually works in practice — specifically, how it would interact with the implicit transaction created when layers are subsequently touched on the main thread, and whether transactions opened on different threads would still be treated as nested/embedded transactions.
