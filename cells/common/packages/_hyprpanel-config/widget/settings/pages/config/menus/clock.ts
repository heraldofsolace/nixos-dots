import { Option } from "widget/settings/shared/Option";
import { Header } from "widget/settings/shared/Header";

import options from "options";

export const ClockMenuSettings = () => {
  return Widget.Scrollable({
    vscroll: "automatic",
    child: Widget.Box({
      class_name: "bar-theme-page paged-container",
      vertical: true,
      children: [
        Header("Time"),
        Option({
          opt: options.menus.clock.time.military,
          title: "Use 24hr time",
          type: "boolean",
        }),

        Header("Weather"),
        Option({
          opt: options.menus.clock.weather.location,
          title: "Location",
          subtitle: "Zip Code, Postal Code, City, etc.",
          type: "string",
        }),
        Option({
          opt: options.menus.clock.weather.key,
          title: "Weather API Key",
          subtitle: "May require AGS restart. https://weatherapi.com/",
          type: "string",
        }),
        Option({
          opt: options.menus.clock.weather.unit,
          title: "Units",
          type: "enum",
          enums: ["imperial", "metric"],
        }),
        Option({
          opt: options.menus.clock.weather.interval,
          title: "Weather Fetching Interval (ms)",
          subtitle: "May require AGS restart.",
          type: "number",
        }),
      ],
    }),
  });
};
