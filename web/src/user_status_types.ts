import * as z from "zod/mini";

export const user_status_schema = z.intersection(
    z.object({
        status_text: z.optional(z.string()),
        away: z.optional(z.boolean()),
    }),
    z.union([
        z.object({
            emoji_name: z.string(),
            emoji_code: z.string(),
            reaction_type: z.enum(["doer_extra_emoji", "realm_emoji", "unicode_emoji"]),
        }),
        z.object({
            emoji_name: z.undefined(),
        }),
    ]),
);
