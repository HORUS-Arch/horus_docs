# horus_human_description

The **model of the person** (data, not algorithms), a lower-body human/biomech URDF that state estimation
and estimation reference and that stimulator targets attach to. Kept separate from the device
description: human and device are **two URDFs joined by a transform** (URDF is a tree and can't close the
strap loop; MuJoCo `<equality>` closes it for sim).

## Dependencies

`xacro`, `robot_state_publisher`.

## Contents

- `urdf/human.urdf.xacro`, the lower-body skeleton, **parametric** on the subject's body measurements
  (`hip_height`, `knee_height`, `ankle_height`, `hip_width`, `foot_length`, `sole_thickness`; 0 = adult
  default). Links and joints use the `human_msgs` names (`pelvis`, `right_upper_leg`, `right_knee`, ...).
- `profile_to_urdf`, builds a subject's URDF from `subjects/<id>/profile.yaml`.
- `launch/human_model.launch.py subject_id:=<id>`, publishes it with `robot_state_publisher` in `/human`
  (frames prefixed `human/`, joint states from `/human/joint_states`).

## Usage

Publish the human TF tree with `robot_state_publisher` fed this description; sensors (IMUs, Xsens,
insoles) publish joint states / transforms into that tree.

## Notes

Segment lengths: upper leg = hip height − knee height, lower leg = knee height − ankle height; the
pelvis sits at hip height plus sole thickness. Inertia-free: for TF, visualization and kinematics.
