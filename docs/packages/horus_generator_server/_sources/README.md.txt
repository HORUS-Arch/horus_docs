# horus_generator_server

The HORUS **reference-generation** layer: one lifecycle node that hosts `Generator` plugins and
publishes the reference stream the real-time controllers track.

It owns the rate thread, the publishing and the lifecycle, so a plugin author writes only an algorithm,
never a node. It is **pure generation with no sequencing**: deciding *which* behavior runs when is
the job of the supervisor's trees.

## Where it sits

Motion in HORUS is split in two, by rate and by responsibility. Generation decides *what the joints
should do* and runs in a normal node at ~100 Hz; control *tracks* that decision inside `ros2_control`
at ~1 kHz in its own real-time process.

```mermaid
flowchart LR
  bt["supervisor tree<br/>(decides what runs)"] -->|execute_behavior goal| gs
  subgraph gen["generation, ~100 Hz, normal node"]
    gs["generator_server"] -->|drives| plug["active Generator plugin"]
  end
  plug -->|"reference (Float64MultiArray)"| ctl
  subgraph rt["control, ~1 kHz, real-time process"]
    ctl["controller"] --> hw["hardware"]
  end
```

Splitting them is what lets the same generator drive the mock, MuJoCo and real hardware unchanged, and
lets you write new motion algorithms without touching real-time code.

## How a behavior runs

A **behavior** is a named generator instance (`home`, `walk`, `sit`) declared in configuration. Running
one is an action, so it is long-running, reports feedback and can be canceled.

```mermaid
sequenceDiagram
    participant BT as supervisor tree
    participant GS as generator_server
    participant G as Generator plugin
    participant C as controller

    Note over GS: idle, publishing nothing
    BT->>GS: execute_behavior{behavior: "walk"}
    GS->>GS: reject if unknown, preempt the running one
    GS->>G: reset() + activate()
    loop every 1/rate_hz
        GS->>G: update(time, period)
        G-->>GS: reference vector
        GS->>C: publish on output_topic
    end
    G-->>GS: finished() == true
    GS->>G: deactivate()
    Note over GS: idle again, publishing stops
    GS-->>BT: SUCCEEDED (error_code NONE)
```

Two guarantees matter here, and both exist for safety:

- **Idle means silent.** With no behavior running the server publishes *nothing*, so it can never drive
  the device on its own. A forward controller then simply holds its last command, and one with a
  reference timeout stands down entirely. There is deliberately no "default" generator that would
  stream a pattern at idle.
- **One behavior at a time.** A goal that arrives while another is running **preempts** it (the old goal
  ends aborted with "preempted"), so a recovery behavior never waits for the running one and two goals
  never fight over which generator is active. Unknown behavior names are rejected, so a typo fails
  loudly instead of silently doing nothing.
- **A cancel stops the output at once.** The output is stopped in the cancel callback itself, not at the
  next check of the execute loop (which runs every 5 ms). A cancel is how a mode change or an emergency
  stop reaches the motion: no command is published after it.

### Finite and continuous behaviors

`Generator::finished()` is what lets an action *complete*:

- **Finite** (`home`, `sit`, a trajectory player): returns `true` once the motion is done, so the action
  succeeds and the behavior tree moves to its next step.
- **Continuous** (`walk`, a CPG, `Manual`): stays `false` and runs until the tree cancels it. The shipped
  `Pattern` generator can be made finite by giving it a `duration`.

## Configuration model

Behaviors are declared exactly the way nav2 declares plugins: a list of instance names, then a block
per name giving its class and its parameters. Adding a behavior is configuration, not code.

```yaml
generator_server:
  ros__parameters:
    rate_hz: 100.0
    output_topic: /position_controller/commands   # point at the controller's command topic
    generator_plugins: [home, walk]               # the instance names

    home:                                         # parameters live under the instance name
      plugin: horus_generator_pattern/Pattern
      duration: 1.0                               # finite: ends after 1 s
      ...
    walk:
      plugin: horus_generator_pattern/Pattern
      duration: 2.0
      ...
```

Each instance is loaded and configured **once, at configure time**, so switching behavior at runtime is
a pointer swap rather than a plugin reload.

## ROS 2 API

### Nodes

| Node | Description |
|---|---|
| `generator_server` | Hosts the generators and runs the active one at `rate_hz`. Registered as a component (`horus_generator_server::GeneratorServer`), so it runs standalone or composed into a container. It is a **managed lifecycle node**, brought up by `lifecycle_manager`. |

### Published topics

| Topic | Description |
|---|---|
| `output_topic` (the parameter's value) | The reference, published only while a behavior is running: `std_msgs/Float64MultiArray` (`output_type: float64_array`) or a one-point `trajectory_msgs/JointTrajectory` per tick (`output_type: joint_trajectory`). Point it at the command topic of the controller that should track it. |
| `~/behavior_state` | `horus_msgs/BehaviorState` (latched): the running behavior, its plugin, active, finished. |

### Subscribed topics (by plugins, on this node)

| Topic | Description |
|---|---|
| `~/manual_target` | `sensor_msgs/JointState`: operator targets for a `horus_generator_pattern/Manual` behavior (the UI sliders). |
| `/joint_states` | Measured pose, read by plugins that start from it (Waypoints `start_from_current`, Manual). |

### Actions

| Action | Description |
|---|---|
| `~/execute_behavior` | Run one named behavior to completion. Switches the active generator, streams the reference, and succeeds when a finite generator finishes. Goal `parameters` override that behavior's own parameters (e.g. `cycling`, a Waypoints `times`) for this run only; they are restored afterwards. Feedback carries the generator's progress. A goal that arrives while another behavior runs **preempts** it (the old goal ends aborted with "preempted"); an unknown name is rejected. |

### Parameters

| Parameter | Description |
|---|---|
| `rate_hz` | How often the active generator is sampled and the reference published. Defaults to 100 Hz, which is the generation tier, not the real-time tier. |
| `output_topic` | Where the reference is published. Defaults to `~/reference`; in practice it is the target controller's command topic, e.g. `/safety_controller/commands` (`horus_control/SafetyController`, direct wiring). |
| `generator_plugins` | The behavior instance names. Each name gets a `<name>.plugin` (its class) and its own parameter block under `<name>.*`. |
| `output_type` | `float64_array` (default, for `forward_command_controller`) or `joint_trajectory` (for `joint_trajectory_controller`). |
| `joint_names` | Joint order of trajectory output when the generator does not name its joints (Waypoints does). |
| `trajectory_point_time` | s, `time_from_start` of each streamed point; `0` = two periods. |
| `speed_scale` | **Live** time scaling of every behavior: `1` normal, `0.5` half speed, `0` hold, up to `max_speed_scale` (default 3). `ros2 param set /horus/generator_server speed_scale 1.5`. |

## Writing a new generator

You never modify this server. Create a package that depends on `horus_generator_core`, subclass
`Generator`, export it with pluginlib, then list it under `generator_plugins` with a behavior name. See
`horus_generator_core` for the interface and `horus_generator_pattern` for a complete example.

## Notes

- A new algorithm is a new plugin package; the server never changes.
- The old `BehaviorPlanner` / Mode FSM was removed. That sequencing now lives in the trees the
  supervisor runs, which keeps this server dumb and the trial logic swappable as data.
