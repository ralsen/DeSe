
const express = require('express');
const http = require('http');
const url = require('url');
const querystring = require('querystring');
const path = require('path');
const fs = require('fs');
const socketIO = require('socket.io');
const mime = require('mime-types');
const log4js = require('log4js');
const cors = require('cors');
const yaml = require('js-yaml');
const os = require('os');
const app = express();
const server = http.createServer(app);
const io = socketIO(server);
const { exec } = require('child_process');


log4js.configure({
    appenders: { 
    file: { type: 'file', filename: '../log/'+path.basename(process.argv[1]).replace('.js', '')+'_'+os.hostname()+'-'+new Date().toISOString().slice(0, 10).replace(/-/g, '_')+'.log' },
    console: { type: 'console' } 
    },
    categories: { 
    default: { appenders: ['file', 'console'], level: 'debug' } 
    }
});

const logger = log4js.getLogger();

// Define CORS options
const corsOptions = {
  origin: ['http://localhost:8080', 'http://localhost:3000'],
  optionsSuccessStatus: 200
};

// Enable CORS
app.use(cors(corsOptions));

// Set up static file serving
app.use(express.static('/var/www/html/dabo-web', {
    setHeaders: function (res, path) {
        const contentType = mime.lookup(path);
        res.setHeader('Content-Type', contentType);
    }
}));

app.post('/action', (req, res) => {
    logger.info('da hat einer geklickt: '+Object.keys(req) + ' ---> ' + Object.keys(res));
//    Object.entries(req).forEach(([key, value]) => {
//        logger.info(`${key}: ${value}`);
//      });
});

app.get('/rrd', (req, res) => {
    logger.info('da will einer ne rrd: ');

    fs.readFile('./rrd.sh', 'utf8', (err, data) => {
        if (err) {
          console.error(err);
          res.status(500).send('Fehler beim Lesen der Datei');
          return;
        }
    
        try {
          // Sende die Daten als JSON-Antwort
          res.json(data);
        } catch (e) {
          console.error(e);
          res.status(500).send('Fehler beim Parsen der Datei');
        }
      });
    });

app.get('/draw', (req, res) => {
    const parsedUrl = url.parse(req.url);
    const parsedQuery = querystring.parse(parsedUrl.query);
    const paraArray = JSON.parse(parsedQuery.para);
    logger.info('da will einer ne grafik: ' + req.url);
    logger.info(paraArray);
    res.json('habs bekommen');
    exec('python3 draw.py ' + JSON.stringify(paraArray), (err, stdout, stderr) => {
      if (err) {
        console.error(`Fehler: ${err}`);
        return;
      }
      console.log(`Ausgabe: ${stdout}`);
    });
  });

app.get('/yml', (req, res) => {
    logger.info('da will einer ne yml: ' + req.url);

    const parsedUrl = url.parse(req.url);
    const parsedQuery = querystring.parse(parsedUrl.query);
    const filepath = path.join(__dirname, '../yml/' + parsedQuery.file + '.yml');
    fs.readFile(filepath, 'utf8', (err, data) => {
        if (err) {
          console.error(err);
          res.status(500).send('Fehler beim Lesen der Datei');
          return;
        }
    
        try {
          // Parse die YML-Datei
          const ymlData = yaml.load(data);
    
          // Sende die Daten als JSON-Antwort
          res.json(ymlData);
        } catch (e) {
          console.error(e);
          res.status(500).send('Fehler beim Parsen der Datei');
        }
      });
    });

// Define namespaces for each path
const dataNamespace = io.of('/data');
const infoNamespace = io.of('/info');

dataNamespace.on('connection', (socket) => {
    logger.info('data user connected');

    // send data to client every second
    setInterval(() => {
        const message = {date: new Date().getTime(), a: 1, text: "Hello there"};
        logger.info("send timeticks")
        socket.emit('data', (message));
        //socket.emit('data', {date: new Date().getTime()});
    }, 1000);

    socket.on('disconnect', () => {
        logger.info('data user disconnected');
    });
});

infoNamespace.on('connection', (socket) => {
    logger.info('info user connected');
    var i = 0
    // send data to client every second
    setInterval(() => {
        logger.info(i)
        socket.emit('info', i++);
    }, 2000);

    socket.on('disconnect', () => {
        logger.info('info user disconnected');
    });
});

server.listen(3000, () => {
    logger.info(__dirname)
    logger.info('listening on *:3000');
    console.log(process.argv[1])
});
