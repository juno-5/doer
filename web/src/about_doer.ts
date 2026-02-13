import ClipboardJS from "clipboard";
import $ from "jquery";
import assert from "minimalistic-assert";

import render_about_zulip from "../templates/about_zulip.hbs";

import * as browser_history from "./browser_history.ts";
import {show_copied_confirmation} from "./copied_tooltip.ts";
import * as overlays from "./overlays.ts";
import {realm} from "./state_data.ts";

export function launch(): void {
    overlays.open_overlay({
        name: "about-doer",
        $overlay: $("#about-doer"),
        on_close() {
            browser_history.exit_overlay();
        },
    });

    const doer_version_clipboard = new ClipboardJS("#about-doer .doer-version");
    doer_version_clipboard.on("success", (e) => {
        assert(e.trigger instanceof HTMLElement);
        show_copied_confirmation(e.trigger, {
            show_check_icon: true,
        });
    });

    const doer_merge_base_clipboard = new ClipboardJS("#about-doer .doer-merge-base");
    doer_merge_base_clipboard.on("success", (e) => {
        assert(e.trigger instanceof HTMLElement);
        show_copied_confirmation(e.trigger, {
            show_check_icon: true,
        });
    });
}

export function initialize(): void {
    const rendered_about_zulip = render_about_zulip({
        doer_version: realm.doer_version,
        doer_merge_base: realm.doer_merge_base,
        is_fork: realm.doer_merge_base && realm.doer_merge_base !== realm.doer_version,
    });
    $("#about-doer-modal-container").append($(rendered_about_zulip));
}
