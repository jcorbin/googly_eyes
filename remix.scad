// Remix of <https://www.thingiverse.com/thing:5724636>
// - dual backplate pair with a zip-tie able bridge
// - allow for easy scaling up/down of eye size
// - the hole in the bridge is sized for a small (2.5mm x 1mm) zip-tie
//
// NOTE unpack the "Download All" zip file into a "sans_lense/" sibling

include <BOSL2/std.scad>

bridge_gap = 15; // NOTE subject to scale ; needs to be large enough to accomodate zip_tie_width

bridge_depth = 6; // NOTE needs to be large enough to accomodate zip_tie_thick
bridge_height = 4; // NOTE subject to scale
bridge_rounding = 1; // NOTE subject to scale
hole_rounding = 0.5;

// NOTE set either to 0 to disable zip tie hole
zip_tie_width = 2.5;
zip_tie_thick = 1;

scale = 1.0;
back_only = true;
eye_only = false;

// bridged dual-backing plate for a pair of eyes
if (!eye_only) {
  fwd(back_only ? 0 : 30 * scale)
    sans_lense_complex_base_pair(gap=bridge_gap * scale, scale=scale, anchor=BOTTOM);
}

// pair of eyes
if (!back_only) {
  back(eye_only ? 0 : 30 * scale)
  xcopies(n=2, l=50)
  scale(scale)
    sans_lense_complex_eye(anchor=BOTTOM);
}

module sans_lense_complex_base_pair(gap=bridge_gap, scale=1.0, anchor=CENTER, orient=UP, spin=0) {
  attachable(size=[49.8 * 2 + gap, 49.8, 6.06]*scale, anchor=anchor, orient=orient, spin=spin) {
    union() {

      scale(v=scale)
      right((49.3 + gap/scale)/2)
      sans_lense_complex_base()
        attach(LEFT, RIGHT, overlap=-gap/scale)
          sans_lense_complex_base();

      down(0.5) diff("hole")
        cuboid([gap + 1, bridge_depth, bridge_height * scale], rounding=bridge_rounding * scale, edges="X") {
          if (zip_tie_thick * zip_tie_width > 0) tag("hole")
            attach(BACK, BOTTOM, overlap=bridge_depth + 0.5)
            cuboid([
              zip_tie_width + 0.5,
              zip_tie_thick + 0.8,
              bridge_depth + 1
            ], rounding=hole_rounding, edges="Z");
        };

    }

    children();
  }
}

module sans_lense_complex_eye(anchor=CENTER, spin=0, orient=UP) {
  attachable(anchor=anchor, orient=orient, spin=spin, d=28.43, l=6.06) {
    down(3.03)
    left(60.203)
      import("sans_lense/files/Fake_googly_eye_-_complex_eye.stl");
    children();
  }
}

module sans_lense_complex_base(anchor=CENTER, spin=0, orient=UP) {
  left_by = 135/2;
  height = 6.32;
  attachable(anchor=anchor, orient=orient, spin=spin, d=49.8, l=height) {
    down(height/2)
    left(67.5)
      import("sans_lense/files/Fake_googly_eye_-_complex_back.stl");
    children();
  }
}

// minimal caliper module, for now it just uses super basic 1mm cubic "planes" for jaws
//
// use like: %caliper(gap=50, size=100) to measure Z
//           %yrot(90) caliper(gap=50, size=100) to measure X
//           %xrot(90) caliper(gap=50, size=100) to measure Y
module caliper(gap, size=10, thickness=1) {
  // TODO attach to a gap object
  up(gap/2) up(thickness/2) caliper_jaw(size=size, thickness=thickness);
  down(gap/2) down(thickness/2) caliper_jaw(size=size, thickness=thickness);
}

module caliper_jaw(size=10, thickness=1) {
  // TODO attachable triangular shape
  cube([size, size, thickness], center=true);
}
