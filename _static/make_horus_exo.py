# Regenerate: python3 _static/make_horus_exo.py _static/horus_exo.svg
"""Generate the HORUS landing illustration: a walking person in a hip-knee-ankle exoskeleton with
wearable sensors, plus the HORUS loop. Original artwork, HORUS palette. Writes horus_exo.svg."""
import math, sys

def capsule(p1, p2, r1, r2, bulge=0.0, side=1):
    (x1, y1), (x2, y2) = p1, p2
    dx, dy = x2 - x1, y2 - y1
    L = math.hypot(dx, dy); nx, ny = -dy / L, dx / L
    a1 = (x1 + nx * r1, y1 + ny * r1); a2 = (x1 - nx * r1, y1 - ny * r1)
    b1 = (x2 + nx * r2, y2 + ny * r2); b2 = (x2 - nx * r2, y2 - ny * r2)
    mx, my = (x1 + x2) / 2, (y1 + y2) / 2
    rm = (r1 + r2) / 2
    c1 = (mx + nx * (rm + bulge * (side > 0)), my + ny * (rm + bulge * (side > 0)))
    c2 = (mx - nx * (rm + bulge * (side < 0)), my - ny * (rm + bulge * (side < 0)))
    f = lambda p: f"{p[0]:.1f},{p[1]:.1f}"
    return (f"M{f(a1)} Q{f(c1)} {f(b1)} A{r2:.1f},{r2:.1f} 0 0 1 {f(b2)} "
            f"Q{f(c2)} {f(a2)} A{r1:.1f},{r1:.1f} 0 0 1 {f(a1)} Z")

def lerp(p, q, t): return (p[0] + (q[0] - p[0]) * t, p[1] + (q[1] - p[1]) * t)

def off(p, q, d):
    """point offset d to the left of segment p->q, at p"""
    dx, dy = q[0] - p[0], q[1] - p[1]; L = math.hypot(dx, dy)
    return (p[0] - dy / L * d, p[1] + dx / L * d)


SHOE = ("M-6,-16 C6,-24 26,-22 40,-14 C54,-9 70,-7 76,1 C79,9 70,13 56,13 L0,13 C-10,13 -14,2 -6,-16 Z")
def shoe(x, y, ang, fill, sole):
    return (f'<g transform="translate({x},{y}) rotate({ang})"><path d="{SHOE}" fill="{fill}"/>'
            f'<path d="M-6,11 L74,11" stroke="{sole}" stroke-width="4" stroke-linecap="round"/>'
            f'<path d="M14,-12 L30,-6 M20,-16 L36,-9" stroke="#5b6b80" stroke-width="1.6" stroke-linecap="round" opacity="0.7"/></g>')

# ---- pose (side view, walking to the right) ----
HIP_F, KNEE_F, ANK_F = (282, 338), (322, 468), (304, 588)
HIP_B, KNEE_B, ANK_B = (268, 336), (226, 456), (164, 556)
SH, EL_F, WR_F = (288, 192), (264, 288), (240, 366)
EL_B, WR_B = (310, 288), (346, 356)

o = []
o.append('''<svg xmlns="http://www.w3.org/2000/svg" viewBox="-60 0 530 660" role="img" aria-label="A person walking in a lower-limb exoskeleton with wearable sensors, and the HORUS loop: sense, estimate, decide, move">
<defs>
  <linearGradient id="body" x1="0" y1="0" x2="1" y2="0.3"><stop offset="0" stop-color="#6f88a6"/><stop offset="0.55" stop-color="#8ea6c2"/><stop offset="1" stop-color="#6c84a1"/></linearGradient>
  <linearGradient id="bodyB" x1="0" y1="0" x2="1" y2="0.3"><stop offset="0" stop-color="#4b5f78"/><stop offset="1" stop-color="#5a6f8a"/></linearGradient>
  <linearGradient id="metal" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#c9d3de"/><stop offset="0.5" stop-color="#7d8896"/><stop offset="1" stop-color="#4b5563"/></linearGradient>
  <linearGradient id="strut" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#2a3442"/><stop offset="0.5" stop-color="#55606f"/><stop offset="1" stop-color="#2a3442"/></linearGradient>
  <linearGradient id="shoe" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#e9eef4"/><stop offset="1" stop-color="#9fb0c3"/></linearGradient>
  <radialGradient id="halo" cx="0.55" cy="0.45" r="0.6"><stop offset="0" stop-color="#2f78c4" stop-opacity="0.28"/><stop offset="1" stop-color="#2f78c4" stop-opacity="0"/></radialGradient>
  <filter id="glow" x="-60%" y="-60%" width="220%" height="220%"><feGaussianBlur stdDeviation="2.4" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%"><feDropShadow dx="0" dy="8" stdDeviation="8" flood-color="#000" flood-opacity="0.5"/></filter>
</defs>
<ellipse cx="280" cy="330" rx="185" ry="300" fill="url(#halo)"/>
<ellipse cx="260" cy="628" rx="150" ry="12" fill="#5b9bd5" fill-opacity="0.12"/>
''')

# ---- back limbs (darker, behind) ----
o.append('<g fill="url(#bodyB)" filter="url(#shadow)">')
o.append(f'<path d="{capsule(SH, EL_B, 15, 11, 4, -1)}"/>')
o.append(f'<path d="{capsule(EL_B, WR_B, 11, 7.5, 3, 1)}"/>')
o.append('<ellipse cx="352" cy="370" rx="10" ry="14" transform="rotate(-30 352 370)"/>')
o.append(f'<path d="{capsule(HIP_B, KNEE_B, 30, 19, 6, -1)}"/>')
o.append(f'<path d="{capsule(KNEE_B, ANK_B, 18, 11, 8, 1)}"/>')
o.append('</g>')
# back shoe (pushing off: heel up)
o.append(shoe(150, 572, 50, "#8696ab", "#b5c2d1"))
# back exo (dimmer)
o.append('<g opacity="0.75">')
o.append(f'<path d="{capsule(off(HIP_B,KNEE_B,-2), off(KNEE_B,HIP_B,2), 4.5, 4.5)}" fill="#273140"/>')
o.append(f'<path d="{capsule(KNEE_B, ANK_B, 4, 4)}" fill="#273140"/>')
o.append(f'<circle cx="{KNEE_B[0]}" cy="{KNEE_B[1]}" r="14" fill="#3a4554" stroke="#6b7685" stroke-width="2"/>')
o.append(f'<circle cx="{ANK_B[0]}" cy="{ANK_B[1]}" r="9" fill="#3a4554" stroke="#6b7685" stroke-width="2"/>')
o.append('</g>')

# ---- torso, head (front) ----
o.append('<g fill="url(#body)" filter="url(#shadow)">')
o.append('<path d="M284,150 C268,156 258,170 256,192 C252,226 250,260 256,294 C258,314 262,332 270,348 L314,348 '
         'C322,328 328,302 332,278 C338,248 340,214 330,190 C322,170 306,152 294,150 Z"/>')
o.append('<path d="M281,118 C288,122 298,122 304,118 L308,160 C298,166 286,166 278,160 Z"/>')   # neck
o.append('<path d="M266,84 C266,58 284,44 304,46 C324,48 334,64 332,82 C338,90 337,96 331,98 '
         'C331,110 326,120 314,124 C302,128 290,128 282,122 C270,114 266,100 266,84 Z"/>')  # head, profile
o.append('</g>')

# ---- front leg ----
o.append('<g fill="url(#body)">')
o.append(f'<path d="{capsule(HIP_F, KNEE_F, 33, 20, 8, 1)}"/>')
o.append(f'<path d="{capsule(KNEE_F, ANK_F, 19, 11, 10, -1)}"/>')
o.append('<path d="M244,300 C262,290 300,296 316,312 C326,330 312,356 290,362 C268,366 246,350 244,330 Z"/>')  # glute
o.append('</g>')
# front shoe
o.append(shoe(290, 608, 3, "url(#shoe)", "#f3f6fa"))

# ---- front exo ----
# pelvis belt
o.append('<path d="M236,300 C262,310 300,312 330,298 L334,320 C304,336 262,334 234,322 Z" fill="#1b2533" stroke="#3f8bd6" stroke-width="1.6"/>')
o.append('<path d="M240,312 C266,320 300,322 330,309" fill="none" stroke="#49d1e8" stroke-width="1.6" stroke-opacity="0.8"/>')
# thigh + shank struts (outside of the leg)
o.append(f'<path d="{capsule(HIP_F, KNEE_F, 6, 6)}" fill="url(#strut)"/>')
o.append(f'<path d="{capsule(KNEE_F, ANK_F, 5.5, 5.5)}" fill="url(#strut)"/>')
# cuffs: thigh, shank
def cuff(p, q, t, w, h):
    c = lerp(p, q, t); ang = math.degrees(math.atan2(q[1] - p[1], q[0] - p[0])) + 90
    return (f'<g transform="translate({c[0]:.1f},{c[1]:.1f}) rotate({ang:.1f})">'
            f'<rect x="{-w/2}" y="{-h/2}" width="{w}" height="{h}" rx="5" fill="#141c27" stroke="#55606f" stroke-width="1.4"/>'
            f'<line x1="{-w/2+5}" y1="0" x2="{w/2-5}" y2="0" stroke="#49d1e8" stroke-width="1.8" stroke-opacity="0.85"/></g>')
o.append(cuff(HIP_F, KNEE_F, 0.55, 74, 15))
o.append(cuff(KNEE_F, ANK_F, 0.45, 52, 13))
# foot plate
o.append('<path d="M290,628 L362,628" stroke="#2a3442" stroke-width="5" stroke-linecap="round"/>')
o.append(f'<path d="{capsule(ANK_F, (300,626), 4, 4)}" fill="url(#strut)"/>')
# actuators: hip, knee, ankle
def actuator(c, r):
    x, y = c
    return (f'<g filter="url(#shadow)"><circle cx="{x}" cy="{y}" r="{r}" fill="url(#metal)"/>'
            f'<circle cx="{x}" cy="{y}" r="{r*0.68:.1f}" fill="#3b4653" stroke="#9aa6b4" stroke-width="1.2"/>'
            f'<circle cx="{x}" cy="{y}" r="{r*0.3:.1f}" fill="#1b2533"/>'
            f'<circle cx="{x}" cy="{y}" r="{r+3}" fill="none" stroke="#49d1e8" stroke-width="1.4" stroke-opacity="0.7" stroke-dasharray="3 4"/></g>')
o.append(actuator(HIP_F, 24)); o.append(actuator(KNEE_F, 18)); o.append(actuator(ANK_F, 12))

# ---- front arm (over everything) ----
o.append('<g fill="url(#body)" filter="url(#shadow)">')
o.append(f'<path d="{capsule(SH, EL_F, 16, 12, 5, 1)}"/>')
o.append(f'<path d="{capsule(EL_F, WR_F, 11.5, 7.5, 3, -1)}"/>')
o.append('<ellipse cx="234" cy="380" rx="10" ry="15" transform="rotate(18 234 380)"/>')
o.append('</g>')

# ---- control unit on the back of the pelvis ----
o.append('<g filter="url(#glow)"><rect x="214" y="270" width="34" height="46" rx="6" fill="#10202f" stroke="#49d1e8" stroke-width="1.6"/>'
         '<rect x="222" y="280" width="18" height="18" rx="2" fill="#173247" stroke="#49d1e8" stroke-width="1"/>'
         '<path d="M226,289 h3 l2,-4 l3,8 l2,-4 h3" fill="none" stroke="#8ff0ff" stroke-width="1.2"/>'
         '<circle cx="231" cy="306" r="2.2" fill="#8ff0ff"/></g>')

# ---- sensors + wires ----
imu = lambda x, y, a=0: (f'<g transform="translate({x},{y}) rotate({a})"><rect x="-8" y="-6" width="16" height="12" rx="2.5" '
                          f'fill="#0f2a3a" stroke="#49d1e8" stroke-width="1.6"/><circle cx="0" cy="0" r="2" fill="#8ff0ff"/></g>')
wires = [
    "M240,282 C256,240 262,214 270,196",                       # to trunk IMU
    "M246,300 C276,330 300,380 304,404",                       # to thigh IMU
    "M246,306 C292,350 316,402 320,432",                       # to EMG
    "M240,316 C300,430 318,500 314,522",                       # to shank IMU
    "M236,316 C276,470 300,560 300,620",                       # to insole
]
o.append('<g fill="none" stroke="#49d1e8" stroke-width="1.6" stroke-opacity="0.75" stroke-linecap="round" filter="url(#glow)">')
o += [f'<path d="{w}"/>' for w in wires]
o.append('</g>')
o.append('<g filter="url(#glow)">')
o.append(imu(272, 196, -10))           # trunk (back)
o.append(imu(304, 404, 18))            # thigh
o.append(imu(314, 524, -8))            # shank
o.append('<circle cx="318" cy="430" r="4" fill="#8ff0ff"/><circle cx="324" cy="442" r="4" fill="#8ff0ff"/>')   # EMG pair
o.append('<path d="M294,620 L360,620" stroke="#8ff0ff" stroke-width="3" stroke-linecap="round"/>')               # insole
o.append('</g>')

# ---- the HORUS loop ----
cx, cy, R = 62, 250, 74
o.append(f'<g fill="none" stroke="#7fb5ea" stroke-width="2" stroke-linecap="round">')
for a0, a1 in [(-80, -10), (10, 80), (100, 170), (190, 260)]:
    p0 = (cx + R * math.cos(math.radians(a0)), cy + R * math.sin(math.radians(a0)))
    p1 = (cx + R * math.cos(math.radians(a1)), cy + R * math.sin(math.radians(a1)))
    o.append(f'<path d="M{p0[0]:.1f},{p0[1]:.1f} A{R},{R} 0 0 1 {p1[0]:.1f},{p1[1]:.1f}"/>')
    t = math.radians(a1); tx, ty = -math.sin(t), math.cos(t)
    o.append(f'<path d="M{p1[0]-tx*7-ty*4:.1f},{p1[1]-ty*7+tx*4:.1f} L{p1[0]:.1f},{p1[1]:.1f} L{p1[0]-tx*7+ty*4:.1f},{p1[1]-ty*7-tx*4:.1f}"/>')
o.append('</g>')
lab = 'font-family="IBM Plex Sans, sans-serif" font-size="12" font-weight="600" letter-spacing="1.5" fill="#9fd0f5"'
for (a, text, anchor, dx, dy) in [(-45, "SENSE", "start", 10, -4), (45, "ESTIMATE", "start", 10, 14),
                                  (135, "DECIDE", "end", -10, 14), (225, "MOVE", "end", -10, -4)]:
    x = cx + R * math.cos(math.radians(a)); y = cy + R * math.sin(math.radians(a))
    o.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="13" fill="#0c1a29" stroke="#49d1e8" stroke-width="1.6"/>')
    o.append(f'<text x="{x+dx:.1f}" y="{y+dy:.1f}" text-anchor="{anchor}" {lab}>{text}</text>')
# small icons in the four nodes
def node(a): return cx + R * math.cos(math.radians(a)), cy + R * math.sin(math.radians(a))
x, y = node(-45); o.append(f'<path d="M{x-7},{y} h3 l2,-5 l3,10 l2,-5 h4" fill="none" stroke="#8ff0ff" stroke-width="1.5"/>')
x, y = node(45);  o.append(f'<circle cx="{x}" cy="{y}" r="5" fill="none" stroke="#8ff0ff" stroke-width="1.5"/><circle cx="{x}" cy="{y}" r="1.6" fill="#8ff0ff"/>')
x, y = node(135); o.append(f'<path d="M{x},{y-6} v4 M{x},{y-2} l-5,6 M{x},{y-2} l5,6" fill="none" stroke="#8ff0ff" stroke-width="1.5"/>'
                           f'<circle cx="{x}" cy="{y-6}" r="1.6" fill="#8ff0ff"/><circle cx="{x-5}" cy="{y+5}" r="1.6" fill="#8ff0ff"/><circle cx="{x+5}" cy="{y+5}" r="1.6" fill="#8ff0ff"/>')
x, y = node(225); o.append(f'<circle cx="{x}" cy="{y}" r="5.5" fill="none" stroke="#8ff0ff" stroke-width="1.5" stroke-dasharray="4 2.5"/><circle cx="{x}" cy="{y}" r="2" fill="#8ff0ff"/>')
o.append(f'<text x="{cx}" y="{cy+5}" text-anchor="middle" font-family="IBM Plex Mono, monospace" font-size="13" font-weight="600" letter-spacing="2" fill="#5b9bd5">HORUS</text>')
o.append('</svg>')
open(sys.argv[1], "w").write("\n".join(o))
