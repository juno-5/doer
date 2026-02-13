import type * as doer_test_module from "./doer_test.ts";

type JQueryCaretRange = {
    start: number;
    end: number;
    length: number;
    text: string;
};

type JQueryIdleOptions = Partial<{
    idle: number;
    events: string;
    onIdle: () => void;
    onActive: () => void;
    keepTracking: boolean;
}>;

declare global {
    const doer_test: typeof doer_test_module;

    // eslint-disable-next-line @typescript-eslint/consistent-type-definitions
    interface JQuery {
        expectOne: () => this;
        get_offset_to_window: () => DOMRect;
        tab: (action?: string) => this; // From web/third/bootstrap

        // Types for jquery-caret-plugin
        caret: (() => number) & ((arg: number | string) => this);
        range: (() => JQueryCaretRange) &
            ((start: number, end?: number) => this) &
            ((text: string) => this);
        selectAll: () => this;
        deselectAll: () => this;

        // Types for jquery-idle plugin
        idle: (opts: JQueryIdleOptions) => {
            cancel: () => void;
            reset: () => void;
        };
    }

    const DEVELOPMENT: boolean;
    const DOER_VERSION: string;
}
