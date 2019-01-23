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
      sock.write("BOUSSOLE " + Math.ceil(Math.random() * 360) + "\n");
    }

    if (command == "DIST_US") {
      sock.write("DIST_US " + Math.ceil(Math.random() * 50) + " " + Math.ceil(Math.random() * 50) + " " + Math.ceil(Math.random() * 50) + "\n");
    }

    if (command == "POS_GPS") {
      var long = (Math.ceil(Math.random() * 360) - 180) + "°" + Math.ceil(Math.random() * 60 + "'" + Math.ceil(Math.random() * 60)) + "\"\n"
      var lat = (Math.ceil(Math.random() * 360) - 180) + "°" + Math.ceil(Math.random() * 60 + "'" + Math.ceil(Math.random() * 60)) + "\"\n"
      sock.write("POS_GPS " + long + " " + lat + "\n");
    }

    if (command == "ETAT_BATT") {
      sock.write("ETAT_BATT " + (Math.random() * 12).toFixed(1) + "\n");
    }

    if (command == "NBSAT_GPS") {
      sock.write("NBSAT_GPS " + (Math.random() * 5).toFixed(1) + "\n");
    }

  });

  // Add a 'close' event handler to this instance of socket
  sock.on('close', function (data) {
    console.log('CLOSED:');
  });

}).listen(PORT, HOST);

console.log('Server listening on ' + HOST + ':' + PORT);