var net = require('net');

var HOST = '127.0.0.1';
var PORT = 8888;

function rand(i) {
  return parseInt((Math.random() * 10000) % i);
}

net.createServer(function (sock) {
  // We have a connection - a socket object is assigned to the connection automatically
  console.log('CONNECTED: ' + sock.remoteAddress + ':' + sock.remotePort);

  // Add a 'data' event handler to this instance of socket
  sock.on('data', function (data) {
    console.log('< ' + sock.remoteAddress + ': ' + data.toString().trim());
    var command = data.toString().trim();
    if (command == "DETECT") {
      var s = "DETECT ";
      if (parseInt((Math.random() * 100000)) % 2 == 0) s += "AVG "
      if (parseInt((Math.random() * 100000)) % 2 == 0) s += "AVD "
      if (parseInt((Math.random() * 100000)) % 2 == 0) s += "ARG "
      if (parseInt((Math.random() * 100000)) % 2 == 0) s += "ARD "
      s = s.trim() + " \n"
      console.log('> ' + s.trim())
      sock.write(s);
    }
    if (command == "BOUSSOLE") {
      var str = "BOUSSOLE " + Math.ceil(Math.random() * 360) + "\n";
      sock.write(str);
      console.log("> " + str);
    }

    if (command == "DIST_US") {
      var str = "DIST_US " + Math.ceil(Math.random() * 50) + " " + Math.ceil(Math.random() * 50) + " " + Math.ceil(Math.random() * 50) + "\n";
      sock.write(str);
      console.log("> " + str);
    }

    if (command == "POS_GPS") {
      var long = (Math.ceil(Math.random() * 360) - 180) + "\u00B0" + Math.ceil(Math.random() * 60) + "'" + Math.ceil(Math.random() * 60) + "\" N\n"
      var lat = (Math.ceil(Math.random() * 360) - 180) + "\u00B0" + Math.ceil(Math.random() * 60) + "'" + Math.ceil(Math.random() * 60) + "\" E\n"
      var str = "POS_GPS " + long + " " + lat + "\n";
      sock.write(str);
      console.log("> " + str);
    }

    if (command == "ETAT_BATT") {
      var str = "ETAT_BATT " + (Math.random() * 12).toFixed(1) + "\n";
      sock.write(str);
      console.log("> " + str);
    }

    if (command == "NBSAT_GPS") {
      var str = "NBSAT_GPS " + Math.ceil((Math.random() * 5)) + "\n";
      sock.write(str);
      console.log("> " + str);
    }

  });

  // Add a 'close' event handler to this instance of socket
  sock.on('close', function (data) {
    console.log('CLOSED:');
  });

}).listen(PORT, HOST);

console.log('Server listening on ' + HOST + ':' + PORT);