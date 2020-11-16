import { withPluginApi } from "discourse/lib/plugin-api";

function initializeTl3(api) {
  // https://github.com/discourse/discourse/blob/master/app/assets/javascripts/discourse/lib/plugin-api.js.es6
}

export default {
  name: "tl3",

  initialize() {
    withPluginApi("0.8.31", initializeTl3);
  }
};
