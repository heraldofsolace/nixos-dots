import { ResourceLabelType } from "lib/types/bar";
import { GenericResourceData } from "lib/types/customModules/generic";
import { Binding } from "lib/utils";
import { openMenu } from "modules/bar/utils";
import options from "options";
import Gdk from "types/@girs/gdk-3.0/gdk-3.0";
import Gtk from "types/@girs/gtk-3.0/gtk-3.0";
import { Variable as VariableType } from "types/variable";
import Button from "types/widgets/button";

const { scrollSpeed } = options.bar.customModules;

export const runAsyncCommand = (
  cmd: string,
  fn: Function,
  events: { clicked: any; event: Gdk.Event },
): void => {
  if (cmd.startsWith("menu:")) {
    // if the command starts with 'menu:', then it is a menu command
    // and we should App.toggleMenu("menuName") based on the input menu:menuName. Ignoring spaces and case
    const menuName = cmd.split(":")[1].trim().toLowerCase();

    openMenu(events.clicked, events.event, `${menuName}menu`);

    return;
  }

  Utils.execAsync(`bash -c "${cmd}"`)
    .then((output) => {
      if (fn !== undefined) {
        fn(output);
      }
    })
    .catch((err) => console.error(`Error running command "${cmd}": ${err})`));
};

export function throttle<T extends (...args: any[]) => void>(
  func: T,
  limit: number,
): T {
  let inThrottle: boolean;
  return function (this: ThisParameterType<T>, ...args: Parameters<T>) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => {
        inThrottle = false;
      }, limit);
    }
  } as T;
}

export const throttledScrollHandler = (interval: number) =>
  throttle((cmd: string, fn: Function | undefined) => {
    Utils.execAsync(`bash -c "${cmd}"`)
      .then((output) => {
        if (fn !== undefined) {
          fn(output);
        }
      })
      .catch((err) => console.error(`Error running command "${cmd}": ${err}`));
  }, 200 / interval);

const dummyVar = Variable("");

export const inputHandler = (
  self: Button<Gtk.Widget, Gtk.Widget>,
  { onPrimaryClick, onSecondaryClick, onMiddleClick, onScrollUp, onScrollDown },
) => {
  const sanitizeInput = (input: VariableType<string>): string => {
    if (input === undefined) {
      return "";
    }
    return input.value;
  };

  const updateHandlers = (): void => {
    const interval = scrollSpeed.value;
    const throttledHandler = throttledScrollHandler(interval);

    self.on_primary_click = (clicked: any, event: Gdk.Event) =>
      runAsyncCommand(
        sanitizeInput(onPrimaryClick?.cmd || dummyVar),
        onPrimaryClick.fn,
        { clicked, event },
      );

    self.on_secondary_click = (clicked: any, event: Gdk.Event) =>
      runAsyncCommand(
        sanitizeInput(onSecondaryClick?.cmd || dummyVar),
        onSecondaryClick.fn,
        { clicked, event },
      );

    self.on_middle_click = (clicked: any, event: Gdk.Event) =>
      runAsyncCommand(
        sanitizeInput(onMiddleClick?.cmd || dummyVar),
        onMiddleClick.fn,
        { clicked, event },
      );

    self.on_scroll_up = () =>
      throttledHandler(
        sanitizeInput(onScrollUp?.cmd || dummyVar),
        onScrollUp.fn,
      );

    self.on_scroll_down = () =>
      throttledHandler(
        sanitizeInput(onScrollDown?.cmd || dummyVar),
        onScrollDown.fn,
      );
  };

  // Initial setup of event handlers
  updateHandlers();

  const sanitizeVariable = (
    someVar: VariableType<string> | undefined,
  ): Binding<string> => {
    if (someVar === undefined || typeof someVar.bind !== "function") {
      return dummyVar.bind("value");
    }
    return someVar.bind("value");
  };

  // Re-run the update whenever scrollSpeed changes
  Utils.merge(
    [
      scrollSpeed.bind("value"),
      sanitizeVariable(onPrimaryClick),
      sanitizeVariable(onSecondaryClick),
      sanitizeVariable(onMiddleClick),
      sanitizeVariable(onScrollUp),
      sanitizeVariable(onScrollDown),
    ],
    updateHandlers,
  );
};

export const divide = ([total, used]: number[], round: boolean) => {
  const percentageTotal = (used / total) * 100;
  if (round) {
    return total > 0 ? Math.round(percentageTotal) : 0;
  }
  return total > 0 ? parseFloat(percentageTotal.toFixed(2)) : 0;
};

export const formatSizeInKiB = (sizeInBytes: number, round: boolean) => {
  const sizeInGiB = sizeInBytes / 1024 ** 1;
  return round ? Math.round(sizeInGiB) : parseFloat(sizeInGiB.toFixed(2));
};
export const formatSizeInMiB = (sizeInBytes: number, round: boolean) => {
  const sizeInGiB = sizeInBytes / 1024 ** 2;
  return round ? Math.round(sizeInGiB) : parseFloat(sizeInGiB.toFixed(2));
};
export const formatSizeInGiB = (sizeInBytes: number, round: boolean) => {
  const sizeInGiB = sizeInBytes / 1024 ** 3;
  return round ? Math.round(sizeInGiB) : parseFloat(sizeInGiB.toFixed(2));
};
export const formatSizeInTiB = (sizeInBytes: number, round: boolean) => {
  const sizeInGiB = sizeInBytes / 1024 ** 4;
  return round ? Math.round(sizeInGiB) : parseFloat(sizeInGiB.toFixed(2));
};

export const autoFormatSize = (sizeInBytes: number, round: boolean) => {
  // auto convert to GiB, MiB, KiB, TiB, or bytes
  if (sizeInBytes >= 1024 ** 4) return formatSizeInTiB(sizeInBytes, round);
  if (sizeInBytes >= 1024 ** 3) return formatSizeInGiB(sizeInBytes, round);
  if (sizeInBytes >= 1024 ** 2) return formatSizeInMiB(sizeInBytes, round);
  if (sizeInBytes >= 1024 ** 1) return formatSizeInKiB(sizeInBytes, round);

  return sizeInBytes;
};

export const getPostfix = (sizeInBytes: number) => {
  if (sizeInBytes >= 1024 ** 4) return "TiB";
  if (sizeInBytes >= 1024 ** 3) return "GiB";
  if (sizeInBytes >= 1024 ** 2) return "MiB";
  if (sizeInBytes >= 1024 ** 1) return "KiB";

  return "B";
};

export const renderResourceLabel = (
  lblType: ResourceLabelType,
  rmUsg: GenericResourceData,
  round: boolean,
) => {
  const { used, total, percentage, free } = rmUsg;

  const formatFunctions = {
    TiB: formatSizeInTiB,
    GiB: formatSizeInGiB,
    MiB: formatSizeInMiB,
    KiB: formatSizeInKiB,
    B: (size: number, _: boolean) => size,
  };

  // Get them datas in proper GiB, MiB, KiB, TiB, or bytes
  const totalSizeFormatted = autoFormatSize(total, round);
  // get the postfix: one of [TiB, GiB, MiB, KiB, B]
  const postfix = getPostfix(total);

  // Determine which format function to use
  const formatUsed = formatFunctions[postfix] || formatFunctions["B"];
  const usedSizeFormatted = formatUsed(used, round);

  if (lblType === "used/total") {
    return `${usedSizeFormatted}/${totalSizeFormatted} ${postfix}`;
  }
  if (lblType === "used") {
    return `${autoFormatSize(used, round)} ${getPostfix(used)}`;
  }
  if (lblType === "free") {
    return `${autoFormatSize(free, round)} ${getPostfix(free)}`;
  }

  return `${percentage}%`;
};

export const formatTooltip = (dataType: string, lblTyp: ResourceLabelType) => {
  switch (lblTyp) {
    case "used":
      return `Used ${dataType}`;
    case "free":
      return `Free ${dataType}`;
    case "used/total":
      return `Used/Total ${dataType}`;
    case "percentage":
      return `Percentage ${dataType} Usage`;
    default:
      return "";
  }
};
