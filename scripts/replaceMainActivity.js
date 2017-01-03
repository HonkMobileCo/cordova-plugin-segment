module.exports = function(ctx) {
    // make sure android platform is part of build
    if (ctx.opts.platforms.indexOf('android') < 0) {
        return;
    }
    var fs = ctx.requireCordovaModule('fs'),
        path = ctx.requireCordovaModule('path'),
        deferral = ctx.requireCordovaModule('q').defer(),
        et = ctx.requireCordovaModule('elementtree');

    var platformRoot = path.join(ctx.opts.projectRoot, 'platforms/android');
    var mainActivityFileTemplate = path.join(ctx.opts.projectRoot, 'plugins/cordova-plugin-segment/src/android/MainActivity.java');
    var mainActivityFile = path.join(platformRoot, 'src/com/honkmobile/MainActivity.java');

    var configData = fs.readFileSync(path.join(ctx.opts.projectRoot, 'config.xml')).toString();
    var configDataParsed = et.parse(configData);
    var prodKey = configDataParsed.findall(".//platform[@name='android']/preference[@name='analytics_write_key']")[0].get('value')

    fs.readFile(mainActivityFileTemplate, 'utf8', function (err,data) {
      if (err) {
        return console.log(err);
      }
      var result = data.replace(/\|SEGMENT_KEY\|/g, prodKey);

      fs.writeFile(mainActivityFile, result, 'utf8', function (err) {
         if (err) return console.log(err);
      });
      deferral.resolve();
    });
    console.log("MainActivity File has been updated")
    return deferral.promise;
};
