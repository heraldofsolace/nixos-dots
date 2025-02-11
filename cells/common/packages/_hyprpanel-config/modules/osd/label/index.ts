import { OSDOrientation } from "lib/types/options";
import brightness from "services/Brightness";
import options from "options";
const audio = await Service.import("audio");

export const OSDLabel = (ort: OSDOrientation) => {
  return Widget.Box({
    class_name: "osd-label-container",
    hexpand: true,
    vexpand: true,
    child: Widget.Label({
      class_name: "osd-label",
      hexpand: true,
      vexpand: true,
      hpack: "center",
      vpack: "center",
      setup: (self) => {
        self.hook(
          brightness,
          () => {
            self.class_names = self.class_names.filter((c) => c !== "overflow");
            self.label = `${Math.round(brightness.screen * 100)}`;
          },
          "notify::screen",
        );
        self.hook(
          brightness,
          () => {
            self.class_names = self.class_names.filter((c) => c !== "overflow");
            self.label = `${Math.round(brightness.kbd * 100)}`;
          },
          "notify::kbd",
        );
        self.hook(
          audio.microphone,
          () => {
            self.toggleClassName("overflow", audio.microphone.volume > 1);
            self.label = `${Math.round(audio.microphone.volume * 100)}`;
          },
          "notify::volume",
        );
        self.hook(
          audio.microphone,
          () => {
            self.toggleClassName(
              "overflow",
              audio.microphone.volume > 1 &&
                (!options.theme.osd.muted_zero.value ||
                  audio.microphone.is_muted === false),
            );
            self.label = `${options.theme.osd.muted_zero.value && audio.microphone.is_muted !== false ? 0 : Math.round(audio.microphone.volume * 100)}`;
          },
          "notify::is-muted",
        );
        self.hook(
          audio.speaker,
          () => {
            self.toggleClassName("overflow", audio.speaker.volume > 1);
            self.label = `${Math.round(audio.speaker.volume * 100)}`;
          },
          "notify::volume",
        );
        self.hook(
          audio.speaker,
          () => {
            self.toggleClassName(
              "overflow",
              audio.speaker.volume > 1 &&
                (!options.theme.osd.muted_zero.value ||
                  audio.speaker.is_muted === false),
            );
            self.label = `${options.theme.osd.muted_zero.value && audio.speaker.is_muted !== false ? 0 : Math.round(audio.speaker.volume * 100)}`;
          },
          "notify::is-muted",
        );
      },
    }),
  });
};
