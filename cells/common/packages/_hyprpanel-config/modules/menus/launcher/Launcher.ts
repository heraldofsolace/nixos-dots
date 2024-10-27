import { type Binding } from "lib/utils";
import PopupWindow, { Padding, type Opts } from "../PopupWindow";
import icons from "lib/icons";
import options from "options";
import nix from "services/nix";
import * as AppLauncher from "./AppLauncher";
import * as NixRun from "./NixRun";
import * as ShRun from "./ShRun";

const { width, margin } = options.menus.launcher;
const isnix = nix.available;

function Launcher() {
  const favs = AppLauncher.Favorites();
  const applauncher = AppLauncher.Launcher();
  const sh = ShRun.ShRun();
  const shicon = ShRun.Icon();
  const nix = NixRun.NixRun();
  const nixload = NixRun.Spinner();

  function HelpButton(cmd: string, desc: string | Binding<string>) {
    return Widget.Box(
      { vertical: true },
      Widget.Separator(),
      Widget.Button(
        {
          class_name: "help",
          on_clicked: () => {
            entry.grab_focus();
            entry.text = `:${cmd} `;
            entry.set_position(-1);
          },
        },
        Widget.Box([
          Widget.Label({
            class_name: "name",
            label: `:${cmd}`,
          }),
          Widget.Label({
            hexpand: true,
            hpack: "end",
            class_name: "description",
            label: desc,
          }),
        ]),
      ),
    );
  }

  const help = Widget.Revealer({
    child: Widget.Box(
      { vertical: true },
      HelpButton("sh", "run a binary"),
      isnix
        ? HelpButton(
            "nx",
            options.menus.launcher.nix.pkgs
              .bind()
              .as((pkg) => `run a nix package from ${pkg}`),
          )
        : Widget.Box(),
    ),
  });

  const entry = Widget.Entry({
    hexpand: true,
    placeholder_text: 'Search or type ":sh" to run a binary',
    primary_icon_name: icons.ui.search,
    on_accept: ({ text }) => {
      if (text?.startsWith(":nx")) nix.run(text.substring(3));
      else if (text?.startsWith(":sh")) sh.run(text.substring(3));
      else applauncher.launchFirst();

      App.toggleWindow("launcher");
      entry.text = "";
    },
    on_change: ({ text }) => {
      text ||= "";
      favs.reveal_child = text === "";
      help.reveal_child = text.split(" ").length === 1 && text?.startsWith(":");

      if (text?.startsWith(":nx")) nix.filter(text.substring(3));
      else nix.filter("");

      if (text?.startsWith(":sh")) sh.filter(text.substring(3));
      else sh.filter("");

      if (!text?.startsWith(":")) applauncher.filter(text);
    },
  });

  function focus() {
    entry.text = "";
    entry.set_position(-1);
    entry.select_region(0, -1);
    entry.grab_focus();
    favs.reveal_child = true;
  }

  const layout = Widget.Box({
    css: width.bind().as((v) => `min-width: ${v}pt;`),
    class_name: "launcher",
    vertical: true,
    vpack: "start",
    setup: (self) =>
      self.hook(App, (_, win, visible) => {
        if (win !== "launcher") return;

        entry.text = "";
        if (visible) focus();
      }),
    children: [
      Widget.Box([entry, nixload, shicon]),
      favs,
      help,
      applauncher,
      nix,
      sh,
    ],
  });

  return Widget.Box(
    { vertical: true, css: "padding: 1px" },
    Padding("applauncher", {} as Opts),
    layout,
  );
}

export default () =>
  PopupWindow({
    name: "launcher",
    layout: "top",
    child: Launcher(),
    transition: "crossfade",
  });
