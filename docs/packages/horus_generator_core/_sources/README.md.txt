# horus_generator_core

The abstract **`Generator`** interface that every motion algorithm in HORUS implements. Header-only, no
node, and no dependency beyond `rclcpp`.

This package exists so `generator_server` and the algorithms it runs can evolve independently: the
server depends on this interface, plugins depend on this interface, and neither depends on the other.

## Architecture

A generator answers one question, once per tick: **what should the joints do right now?** It returns a
plain vector of numbers and the server publishes it. Everything else, the rate thread, the topic, the
lifecycle, the action, belongs to the server.

```mermaid
flowchart LR
  subgraph server["generator_server (the harness)"]
    timer["rate thread @ rate_hz"] --> upd["update(time, period)"]
    upd --> pub["publish reference"]
    lc["lifecycle + params + action"]
  end
  subgraph plugin["your Generator plugin"]
    alg["the algorithm"]
    subs["its own subscriptions<br/>(EMG, gait phase, joint states)"]
  end
  upd -.->|calls| alg
  alg -.->|returns vector| upd
  subs -.->|feeds| alg
```

The dashed lines are the whole contract: write the algorithm, inherit the rest.

## The interface (`generator.hpp`)

Lifecycle-shaped, so the server can be a managed node without a plugin ever knowing about lifecycle
transitions.

| Method | Description |
|---|---|
| `configure(node, name)` | Read this instance's parameters (they live under `<name>.*`) and subscribe whatever inputs the algorithm needs. Called once, at server configure time. |
| `activate()` | This generator has just become the active one; the next `update()` is imminent. |
| `deactivate()` | This generator is no longer active; stop doing work. |
| `reset()` | Return internal state (phase, elapsed time, integrators) to the start, so a repeated behavior behaves identically each run. |
| `update(time, period)` | Produce the reference for this tick, ordered to match the target controller's joints. This is the algorithm. |
| `finished()` | Whether a finite motion is complete. Returning `true` is what lets a behavior action succeed. Defaults to `false`, meaning continuous. |

### Finite and continuous

`finished()` is the only sequencing signal in the whole layer:

- **Finite** generators (`home`, `sit`, a trajectory player) reach an end state and report it.
- **Continuous** generators (`walk`, a CPG) never finish on their own and run until canceled.

That single boolean is what lets a behavior tree say "home, *then* walk" without the generation layer
knowing anything about sequences.

## Notes

Concrete plugins live in their own packages (`horus_generator_pattern` is the shipped example), and
authoring one never requires touching `generator_server`.
