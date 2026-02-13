"use strict";

module.exports = {
    files: ["./*.svg"],
    fontName: "doer-icons",
    classPrefix: "doer-icon-",
    baseSelector: ".doer-icon",
    cssTemplate: "./template.hbs",
    ligature: false,
    types: ["woff2"], // https://github.com/jeerbl/webfonts-loader/pull/219
};
