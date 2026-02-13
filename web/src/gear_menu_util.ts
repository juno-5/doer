import {$t} from "./i18n.ts";
import {realm} from "./state_data.ts";

export function version_display_string(): string {
    const version = realm.doer_version;
    const is_fork = realm.doer_merge_base && realm.doer_merge_base !== version;

    if (realm.doer_version.endsWith("-dev+git")) {
        // The development environment uses this version string format.
        return $t({defaultMessage: "Doer Server dev environment"});
    }

    if (is_fork) {
        // For forks, we want to describe the Doer version this was
        // forked from, and that it was modified.
        const display_version = realm.doer_merge_base
            .replace(/\+git.*/, "")
            .replace(/(-beta\d+).*/, "$1")
            .replace(/-dev.*/, "-dev");
        return $t({defaultMessage: "Doer Server {display_version} (modified)"}, {display_version});
    }

    // The below cases are all for official versions; either a
    // release, or Git commit from one of Doer's official branches.

    if (version.includes("+git")) {
        // A version from a Doer official maintenance branch such as 5.x.
        const display_version = version.replace(/\+git.*/, "");
        return $t({defaultMessage: "Doer Server {display_version} (patched)"}, {display_version});
    }

    const display_version = version.replace(/\+git.*/, "").replace(/-dev.*/, "-dev");
    return $t({defaultMessage: "Doer Server {display_version}"}, {display_version});
}
