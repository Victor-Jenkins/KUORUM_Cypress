const allure = require('allure-commandline');

exports.config = {
    // ...
    reporters: ['allure'],
    reporterOptions: {
        allure: {
            outputDir: 'allure-results',
            disableWebdriverStepsReporting: true,
            disableWebdriverScreenshotsReporting: false,
            useCucumberStepReporter: false
        },
        onComplete: function () {
            const reportError = new Error('Could not generate Allure report');
            const generation = allure(['generate', 'allure-results', '--clean']);
            return new Promise((resolve, reject) => {
                const generationTimeout = setTimeout(
                    () => reject(reportError),
                    5000);

                generation.on('exit', function (exitCode) {
                    clearTimeout(generationTimeout);

                    if (exitCode !== 0) {
                        return reject(reportError);
                    }

                    console.log('Allure report successfully generated');
                    resolve();
                });
            });
        },
    },
    // ...
};
