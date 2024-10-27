import { clock } from "lib/variables";
import options from "options";
import icons from "lib/icons";
import PanelButton from "./PanelButton";

const poweroff = PanelButton({
  class_name: "powermenu",
  child: Widget.Icon(icons.powermenu.shutdown),
  on_clicked: () => Utils.exec("shutdown now"),
});

const date = PanelButton({
  class_name: "date",
  child: Widget.Label({
    label: clock.bind().as((c) => c.format(`"%H:%M - %A %e."`)!),
  }),
});

export default Widget.CenterBox({
  class_name: "bar",
  hexpand: true,
  center_widget: date,
  end_widget: Widget.Box({
    hpack: "end",
    children: [poweroff],
  }),
});
