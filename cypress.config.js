const { defineConfig } = require("cypress");
const createBundler = require("@bahmutov/cypress-esbuild-preprocessor");
const preprocessor = require("@badeball/cypress-cucumber-preprocessor");
const createEsbuildPlugin = require("@badeball/cypress-cucumber-preprocessor/esbuild");
const allureWriter = require("@shelex/cypress-allure-plugin/writer");

module.exports = defineConfig({
  projectId: "wi2ikb",
  e2e: {
    setupNodeEvents(on, config) {
      allureWriter(on, config);

      // This is required for the preprocessor to be able to generate JSON reports after each run, and more.
      preprocessor.addCucumberPreprocessorPlugin(on, config);

      on(
        "file:preprocessor",
        createBundler({
          plugins: [createEsbuildPlugin.default(config)],
        })
      );

      return config;
    },
    specPattern: "cypress/e2e/*.feature",
    baseUrl: "https://www.saucedemo.com",
    chromeWebSecurity: false,
    env: {
      allureReuseAfterSpec: true,
       allureResultsPath: "allure-results",
    },
  },
});
