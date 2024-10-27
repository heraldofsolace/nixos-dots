import PopupWindow from "widget/PopupWindow";
// import { Ethernet } from "./ethernet";
import { Wifi } from "./wifi";

export default () => {
  return PopupWindow({
    name: "networkmenu",
    transition: "crossfade",
    child: Widget.Box({
      class_name: "menu-items network",
      child: Widget.Box({
        vertical: true,
        hexpand: true,
        class_name: "menu-items-container network",
        children: [
          // Ethernet(),
          Wifi(),
        ],
      }),
    }),
  });
};
