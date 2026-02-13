import $ from "jquery";

function handle_submit_for_server_login_form(form: HTMLFormElement): void {
    // Get value of doer_org_id.
    const doer_org_id = $<HTMLInputElement>("input#doer-org-id").val();
    const $error_field = $(".doer_org_id-error");
    if (doer_org_id === undefined) {
        // Already handled by `validate` plugin.
        return;
    }

    // Check if doer_org_id is in UUID4 format.
    // https://melvingeorge.me/blog/check-if-string-valid-uuid-regex-javascript
    // Regex was modified by linter after copying from above link according to this rule:
    // https://github.com/sindresorhus/eslint-plugin-unicorn/blob/main/docs/rules/better-regex.md
    const is_valid_uuid = /^[\da-f]{8}(?:\b-[\da-f]{4}){3}\b-[\da-f]{12}$/gi;
    // Check if doer_org_id is in UUID4 format.
    if (!is_valid_uuid.test(doer_org_id)) {
        $error_field.text(
            "Wrong doer_org_id format. Check to make sure doer_org_id and doer_org_key are not swapped.",
        );
        $error_field.show();
        return;
    }
    $("#server-login-form").find(".loader").css("display", "inline-block");
    $("#server-login-button .server-login-button-text").hide();
    form.submit();
}

export function initialize(): void {
    $(
        "#server-login-form, #remote-billing-confirm-email-form, #remote-billing-confirm-login-form",
    ).validate({
        errorClass: "text-error",
        wrapper: "div",
        submitHandler(form) {
            if (form.id === "server-login-form") {
                handle_submit_for_server_login_form(form);
                return;
            }

            $("#server-login-form").find(".loader").css("display", "inline-block");
            $("#server-login-button .server-login-button-text").hide();
            $("#remote-billing-confirm-email-form").find(".loader").css("display", "inline-block");
            $("#remote-billing-confirm-email-button .server-login-button-text").hide();
            $("#remote-billing-confirm-login-form").find(".loader").css("display", "inline-block");
            $(
                "#remote-billing-confirm-login-button .remote-billing-confirm-login-button-text",
            ).hide();

            form.submit();
        },
        invalidHandler() {
            $("*[class$='-error']").hide();
        },
        showErrors(error_map) {
            $("*[class$='-error']").hide();
            for (const [key, error] of Object.entries(error_map)) {
                const $error_element = $(`.${CSS.escape(key)}-error`);
                $error_element.text(error);
                $error_element.show();
            }
        },
    });

    $<HTMLInputElement>("input#enable-major-release-emails").on("change", function () {
        if (this.checked) {
            $(this).val("true");
        }
        $(this).val("false");
    });

    $<HTMLInputElement>("input#enable-maintenance-release-emails").on("change", function () {
        if (this.checked) {
            $(this).val("true");
        }
        $(this).val("false");
    });
}

$(() => {
    initialize();
});
