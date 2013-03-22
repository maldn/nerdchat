
var cs = require('coffee-script'),
	requirejs = require('requirejs');

requirejs.config({
	//baseUrl: 'scripts',
	nodeRequire: require,
	paths: {
		"cs": "shared/cs"
	}
});

requirejs(['cs!server/main'],
function ( server) {
	//console.log (server);
	server.server.listen(8000);
});