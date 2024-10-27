/* eslint-disable @typescript-eslint/no-explicit-any */
import { type Application } from "types/service/applications";
import icons, { substitutes } from "./icons";
import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import GLib from "gi://GLib?version=2.0";

export type Binding<T> = import("types/service").Binding<any, any, T>;

/**
 * @returns substitute icon || name || fallback icon
 */
export function icon(name: string | null, fallback = icons.missing) {
  if (!name) return fallback || "";

  if (GLib.file_test(name, GLib.FileTest.EXISTS)) return name;

  const icon = substitutes[name] || name;
  if (Utils.lookUpIcon(icon)) return icon;

  print(`no icon substitute "${icon}" for "${name}", fallback: "${fallback}"`);
  return fallback;
}

/**
 * @returns execAsync(["bash", "-c", cmd])
 */
export async function bash(
  strings: TemplateStringsArray | string,
  ...values: unknown[]
) {
  const cmd =
    typeof strings === "string"
      ? strings
      : strings.flatMap((str, i) => str + `${values[i] ?? ""}`).join("");

  return Utils.execAsync(["bash", "-c", cmd]).catch((err) => {
    console.error(cmd, err);
    return "";
  });
}

/**
 * @returns execAsync(cmd)
 */
export async function sh(cmd: string | string[]) {
  return Utils.execAsync(cmd).catch((err) => {
    console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err);
    return "";
  });
}

export function forMonitors(widget: (monitor: number) => Gtk.Window) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(n, 0).flatMap(widget);
}

/**
 * @returns [start...length]
 */
export function range(length: number, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}

/**
 * @returns true if all of the `bins` are found
 */
export function dependencies(...bins: string[]) {
  const missing = bins.filter((bin) =>
    Utils.exec({
      cmd: `which ${bin}`,
      out: () => false,
      err: () => true,
    }),
  );

  if (missing.length > 0) {
    console.warn(Error(`missing dependencies: ${missing.join(", ")}`));
    Utils.notify(`missing dependencies: ${missing.join(", ")}`);
  }

  return missing.length === 0;
}

/**
 * run app detached
 */
export function launchApp(app: Application) {
  const exe = app.executable
    .split(/\s+/)
    .filter((str) => !str.startsWith("%") && !str.startsWith("@"))
    .join(" ");

  bash(`${exe} &`);
  app.frequency += 1;
}

/**
 * to use with drag and drop
 */
export function createSurfaceFromWidget(widget: Gtk.Widget) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const cairo = imports.gi.cairo as any;
  const alloc = widget.get_allocation();
  const surface = new cairo.ImageSurface(
    cairo.Format.ARGB32,
    alloc.width,
    alloc.height,
  );
  const cr = new cairo.Context(surface);
  cr.setSourceRGBA(255, 255, 255, 0);
  cr.rectangle(0, 0, alloc.width, alloc.height);
  cr.fill();
  widget.draw(cr);
  return surface;
}

export const closeAllMenus = () => {
  const menuWindows = App.windows
    .filter((w) => {
      if (w.name) {
        return /.*menu/.test(w.name);
      }

      return false;
    })
    .map((w) => w.name);

  menuWindows.forEach((w) => {
    if (w) {
      App.closeWindow(w);
    }
  });
};

export const openMenu = (clicked: any, event: Gdk.Event, window: string) => {
  /*
   * NOTE: We have to make some adjustments so the menu pops up relatively
   * to the center of the button clicked. We don't want the menu to spawn
   * offcenter dependending on which edge of the button you click on.
   * -------------
   * To fix this, we take the x coordinate of the click within the button's bounds.
   * If you click the left edge of a 100 width button, then the x axis will be 0
   * and if you click the right edge then the x axis will be 100.
   * -------------
   * Then we divide the width of the button by 2 to get the center of the button and then get
   * the offset by subtracting the clicked x coordinate. Then we can apply that offset
   * to the x coordinate of the click relative to the screen to get the center of the
   * icon click.
   */

  const middleOfButton = Math.floor(clicked.get_allocated_width() / 2);
  const xAxisOfButtonClick = clicked.get_pointer()[0];
  const middleOffset = middleOfButton - xAxisOfButtonClick;

  const clickPos = event.get_root_coords();
  const adjustedXCoord = clickPos[1] + middleOffset;
  const coords = [adjustedXCoord, clickPos[2]];

  // globalMousePos.value = coords;

  closeAllMenus();
  App.toggleWindow(window);
};

export const getWifiIcon = (iconName: string) => {
  const deviceIconMap = [
    ["network-wireless-acquiring", "󰤩"],
    ["network-wireless-connected", "󰤨"],
    ["network-wireless-encrypted", "󰤪"],
    ["network-wireless-hotspot", "󰤨"],
    ["network-wireless-no-route", "󰤩"],
    ["network-wireless-offline", "󰤮"],
    ["network-wireless-signal-excellent", "󰤨"],
    ["network-wireless-signal-good", "󰤥"],
    ["network-wireless-signal-ok", "󰤢"],
    ["network-wireless-signal-weak", "󰤟"],
    ["network-wireless-signal-none", "󰤯"],
  ];

  const foundMatch = deviceIconMap.find((icon) =>
    RegExp(icon[0]).test(iconName.toLowerCase()),
  );

  return foundMatch ? foundMatch[1] : "󰤨";
};
