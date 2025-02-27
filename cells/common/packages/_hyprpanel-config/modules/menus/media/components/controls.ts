import { MprisPlayer } from "types/service/mpris.js";
import icons from "../../../icons/index.js";
const media = await Service.import("mpris");

const Controls = (getPlayerInfo: Function) => {
  const isLoopActive = (player: MprisPlayer) => {
    return player["loop-status"] !== null &&
      ["track", "playlist"].includes(player["loop-status"].toLowerCase())
      ? "active"
      : "";
  };

  const isShuffleActive = (player: MprisPlayer) => {
    return player["shuffle-status"] !== null && player["shuffle-status"]
      ? "active"
      : "";
  };

  return Widget.Box({
    class_name: "media-indicator-current-player-controls",
    vertical: true,
    children: [
      Widget.Box({
        class_name: "media-indicator-current-controls",
        hpack: "center",
        children: [
          Widget.Box({
            class_name: "media-indicator-control shuffle",
            children: [
              Widget.Button({
                hpack: "center",
                hasTooltip: true,
                setup: (self) => {
                  self.hook(media, () => {
                    const foundPlayer = getPlayerInfo();
                    if (foundPlayer === undefined) {
                      self.tooltip_text = "Unavailable";
                      self.class_name =
                        "media-indicator-control-button shuffle disabled";
                      return;
                    }

                    self.tooltip_text =
                      foundPlayer.shuffle_status !== null
                        ? foundPlayer.shuffle_status
                          ? "Shuffling"
                          : "Not Shuffling"
                        : null;
                    self.on_primary_click = () => foundPlayer.shuffle();
                    self.class_name = `media-indicator-control-button shuffle ${isShuffleActive(foundPlayer)} ${foundPlayer.shuffle_status !== null ? "enabled" : "disabled"}`;
                  });
                },
                child: Widget.Icon(icons.mpris.shuffle["enabled"]),
              }),
            ],
          }),
          Widget.Box({
            children: [
              Widget.Button({
                hpack: "center",
                child: Widget.Icon(icons.mpris.prev),
                setup: (self) => {
                  self.hook(media, () => {
                    const foundPlayer = getPlayerInfo();
                    if (foundPlayer === undefined) {
                      self.class_name =
                        "media-indicator-control-button prev disabled";
                      return;
                    }

                    self.on_primary_click = () => foundPlayer.previous();
                    self.class_name = `media-indicator-control-button prev ${foundPlayer.can_go_prev !== null && foundPlayer.can_go_prev ? "enabled" : "disabled"}`;
                  });
                },
              }),
            ],
          }),
          Widget.Box({
            children: [
              Widget.Button({
                hpack: "center",
                setup: (self) => {
                  self.hook(media, () => {
                    const foundPlayer = getPlayerInfo();
                    if (foundPlayer === undefined) {
                      self.class_name =
                        "media-indicator-control-button play disabled";
                      return;
                    }

                    self.on_primary_click = () => foundPlayer.playPause();
                    self.class_name = `media-indicator-control-button play ${foundPlayer.can_play !== null ? "enabled" : "disabled"}`;
                  });
                },
                child: Widget.Icon({
                  icon: Utils.watch(
                    icons.mpris.paused,
                    media,
                    "changed",
                    () => {
                      const foundPlayer = getPlayerInfo();
                      if (foundPlayer === undefined) {
                        return icons.mpris["paused"];
                      }
                      return icons.mpris[
                        foundPlayer.play_back_status.toLowerCase()
                      ];
                    },
                  ),
                }),
              }),
            ],
          }),
          Widget.Box({
            class_name: `media-indicator-control next`,
            children: [
              Widget.Button({
                hpack: "center",
                child: Widget.Icon(icons.mpris.next),
                setup: (self) => {
                  self.hook(media, () => {
                    const foundPlayer = getPlayerInfo();
                    if (foundPlayer === undefined) {
                      self.class_name =
                        "media-indicator-control-button next disabled";
                      return;
                    }

                    self.on_primary_click = () => foundPlayer.next();
                    self.class_name = `media-indicator-control-button next ${foundPlayer.can_go_next !== null && foundPlayer.can_go_next ? "enabled" : "disabled"}`;
                  });
                },
              }),
            ],
          }),
          Widget.Box({
            class_name: "media-indicator-control loop",
            children: [
              Widget.Button({
                hpack: "center",
                setup: (self) => {
                  self.hook(media, () => {
                    const foundPlayer = getPlayerInfo();
                    if (foundPlayer === undefined) {
                      self.tooltip_text = "Unavailable";
                      self.class_name =
                        "media-indicator-control-button shuffle disabled";
                      return;
                    }

                    self.tooltip_text =
                      foundPlayer.loop_status !== null
                        ? foundPlayer.loop_status
                          ? "Shuffling"
                          : "Not Shuffling"
                        : null;
                    self.on_primary_click = () => foundPlayer.loop();
                    self.class_name = `media-indicator-control-button loop ${isLoopActive(foundPlayer)} ${foundPlayer.loop_status !== null ? "enabled" : "disabled"}`;
                  });
                },
                child: Widget.Icon({
                  setup: (self) => {
                    self.hook(media, () => {
                      const foundPlayer = getPlayerInfo();
                      if (foundPlayer === undefined) {
                        self.icon = icons.mpris.loop["none"];
                        return;
                      }

                      self.icon =
                        foundPlayer.loop_status === null
                          ? icons.mpris.loop["none"]
                          : icons.mpris.loop[
                              foundPlayer.loop_status?.toLowerCase()
                            ];
                    });
                  },
                }),
              }),
            ],
          }),
        ],
      }),
    ],
  });
};

export { Controls };
