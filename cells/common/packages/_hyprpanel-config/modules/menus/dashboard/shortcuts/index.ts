const hyprland = await Service.import("hyprland");
import options from "options";
import * as services from "services/index";

import { Variable as VarType } from "types/variable";

const { left, right } = options.menus.dashboard.shortcuts;

const Shortcuts = () => {
  const isRecording = Variable(false, {
    poll: [
      1000,
      `${App.configDir}/services/screen_record.sh status`,
      (out) => {
        if (out === "recording") {
          return true;
        }
        return false;
      },
    ],
  });
  const handleClick = (action: any, tOut: number = 250) => {
    App.closeWindow("dashboardmenu");

    if (action.toString().startsWith("menu:")) {
      const menu = action.toString().replace("menu:", "");
      return App.toggleWindow(menu);
    }

    if (action.toString().startsWith("service:")) {
      let cmd = action.toString().replace("service:", "");

      return Utils.execAsync(`${App.configDir}/services/${cmd}`).catch((err) =>
        logError(err),
      );
    }

    setTimeout(() => {
      Utils.execAsync(action)
        .then((res) => {
          return res;
        })
        .catch((err) => err);
    }, tOut);
  };

  const recordingDropdown = Widget.Menu({
    class_name: "dropdown recording",
    hpack: "fill",
    hexpand: true,
    setup: (self) => {
      self.hook(hyprland, () => {
        const displays = hyprland.monitors.map((mon) => {
          return Widget.MenuItem({
            label: `Display ${mon.name}`,
            on_activate: () => {
              App.closeWindow("dashboardmenu");
              Utils.execAsync(
                `${App.configDir}/services/screen_record.sh start ${mon.name}`,
              ).catch((err) => console.error(err));
            },
          });
        });

        // NOTE: This is disabled since window recording isn't available on wayland
        const apps = hyprland.clients.map((clt) => {
          return Widget.MenuItem({
            label: `${clt.class.charAt(0).toUpperCase() + clt.class.slice(1)} (Workspace ${clt.workspace.name})`,
            on_activate: () => {
              App.closeWindow("dashboardmenu");
              Utils.execAsync(
                `${App.configDir}/services/screen_record.sh start ${clt.focusHistoryID}`,
              ).catch((err) => console.error(err));
            },
          });
        });

        return (self.children = [
          ...displays,
          // Disabled since window recording isn't available on wayland
          // ...apps
        ]);
      });
    },
  });

  type ShortcutFixed = {
    tooltip: string;
    command: string;
    icon: string;
    configurable: false;
  };

  type ShortcutVariable = {
    tooltip: VarType<string>;
    command: VarType<string>;
    icon: VarType<string>;
    configurable?: true;
  };

  type Shortcut = ShortcutFixed | ShortcutVariable;

  const cmdLn = (sCut: ShortcutVariable) => {
    return sCut.command.value.length > 0;
  };

  const leftCardHidden = Variable(
    !(
      cmdLn(left.shortcut1) ||
      cmdLn(left.shortcut2) ||
      cmdLn(left.shortcut3) ||
      cmdLn(left.shortcut4)
    ),
  );

  function createButton(shortcut: Shortcut, className: string) {
    if (shortcut.configurable !== false) {
      return Widget.Button({
        vexpand: true,
        tooltip_text: shortcut.tooltip.value,
        class_name: className,
        on_primary_click: () => handleClick(shortcut.command.value),
        child: Widget.Label({
          class_name: "button-label txt-icon",
          label: shortcut.icon.value,
        }),
      });
    } else {
      // handle non-configurable shortcut
      return Widget.Button({
        vexpand: true,
        tooltip_text: shortcut.tooltip,
        class_name: className,
        on_primary_click: (_, event) => {
          if (shortcut.command === "settings-dialog") {
            App.closeWindow("dashboardmenu");
            App.toggleWindow("settings-dialog");
          } else if (shortcut.command === "record") {
            if (isRecording.value === true) {
              App.closeWindow("dashboardmenu");
              return Utils.execAsync(
                `${App.configDir}/services/screen_record.sh stop`,
              ).catch((err) => console.error(err));
            } else {
              recordingDropdown.popup_at_pointer(event);
            }
          }
        },
        child: Widget.Label({
          class_name: "button-label txt-icon",
          label: shortcut.icon,
        }),
      });
    }
  }

  function createButtonIfCommandExists(
    shortcut: Shortcut,
    className: string,
    command: string,
  ) {
    if (command.length > 0) {
      return createButton(shortcut, className);
    }
    return Widget.Box();
  }

  return Widget.Box({
    class_name: "shortcuts-container",
    hpack: "fill",
    hexpand: true,
    children: [
      Widget.Box({
        child: Utils.merge(
          [
            left.shortcut1.command.bind("value"),
            left.shortcut2.command.bind("value"),
            left.shortcut1.tooltip.bind("value"),
            left.shortcut2.tooltip.bind("value"),
            left.shortcut1.icon.bind("value"),
            left.shortcut2.icon.bind("value"),
            left.shortcut3.command.bind("value"),
            left.shortcut4.command.bind("value"),
            left.shortcut3.tooltip.bind("value"),
            left.shortcut4.tooltip.bind("value"),
            left.shortcut3.icon.bind("value"),
            left.shortcut4.icon.bind("value"),
          ],
          () => {
            const isVisibleLeft =
              cmdLn(left.shortcut1) || cmdLn(left.shortcut2);
            const isVisibleRight =
              cmdLn(left.shortcut3) || cmdLn(left.shortcut4);

            if (!isVisibleLeft && !isVisibleRight) {
              leftCardHidden.value = true;
              return Widget.Box();
            }

            leftCardHidden.value = false;

            return Widget.Box({
              class_name: "container most-used dashboard-card",
              children: [
                Widget.Box({
                  className: `card-button-section-container ${isVisibleRight && isVisibleLeft ? "visible" : ""}`,
                  child: isVisibleLeft
                    ? Widget.Box({
                        vertical: true,
                        hexpand: true,
                        vexpand: true,
                        children: [
                          createButtonIfCommandExists(
                            left.shortcut1,
                            `dashboard-button top-button ${cmdLn(left.shortcut2) ? "paired" : ""}`,
                            left.shortcut1.command.value,
                          ),
                          createButtonIfCommandExists(
                            left.shortcut2,
                            "dashboard-button",
                            left.shortcut2.command.value,
                          ),
                        ],
                      })
                    : Widget.Box({
                        children: [],
                      }),
                }),
                Widget.Box({
                  className: "card-button-section-container",
                  child: isVisibleRight
                    ? Widget.Box({
                        vertical: true,
                        hexpand: true,
                        vexpand: true,
                        children: [
                          createButtonIfCommandExists(
                            left.shortcut3,
                            `dashboard-button top-button ${cmdLn(left.shortcut4) ? "paired" : ""}`,
                            left.shortcut3.command.value,
                          ),
                          createButtonIfCommandExists(
                            left.shortcut4,
                            "dashboard-button",
                            left.shortcut4.command.value,
                          ),
                        ],
                      })
                    : Widget.Box({
                        children: [],
                      }),
                }),
              ],
            });
          },
        ),
      }),
      Widget.Box({
        child: Utils.merge(
          [
            right.shortcut1.command.bind("value"),
            right.shortcut1.tooltip.bind("value"),
            right.shortcut1.icon.bind("value"),
            right.shortcut3.command.bind("value"),
            right.shortcut3.tooltip.bind("value"),
            right.shortcut3.icon.bind("value"),
            leftCardHidden.bind("value"),
            isRecording.bind("value"),
          ],
          () => {
            return Widget.Box({
              class_name: `container utilities dashboard-card ${!leftCardHidden.value ? "paired" : ""}`,
              children: [
                Widget.Box({
                  className: `card-button-section-container visible`,
                  child: Widget.Box({
                    vertical: true,
                    hexpand: true,
                    vexpand: true,
                    children: [
                      createButtonIfCommandExists(
                        right.shortcut1,
                        "dashboard-button top-button paired",
                        right.shortcut1.command.value,
                      ),
                      createButtonIfCommandExists(
                        {
                          tooltip: "HyprPanel Configuration",
                          command: "settings-dialog",
                          icon: "󰒓",
                          configurable: false,
                        },
                        "dashboard-button",
                        "settings-dialog",
                      ),
                    ],
                  }),
                }),
                Widget.Box({
                  className: "card-button-section-container",
                  child: Widget.Box({
                    vertical: true,
                    hexpand: true,
                    vexpand: true,
                    children: [
                      createButtonIfCommandExists(
                        right.shortcut3,
                        "dashboard-button top-button paired",
                        right.shortcut3.command.value,
                      ),
                      createButtonIfCommandExists(
                        {
                          tooltip: "Record Screen",
                          command: "record",
                          icon: "󰑊",
                          configurable: false,
                        },
                        `dashboard-button record ${isRecording.value ? "active" : ""}`,
                        "record",
                      ),
                    ],
                  }),
                }),
              ],
            });
          },
        ),
      }),
    ],
  });
};

export { Shortcuts };
