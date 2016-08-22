var _ = require('lodash');

var argv = process.argv;

var lines = [
  "FROM ubuntu:14.04",
  "RUN mkdir -p /opt/installers",
  "WORKDIR /opt/installers"
];

var list = _(argv)
  .filter(x => x.match(/:/))
  .map(x => x.split(":"))
  .filter(xs => xs.length == 2)
  .map(xs => {
    return {
      type: xs[0],
      name: xs[1]
    }
  })
  .value();

_(list).map(x => x.type).uniq().value().forEach(x => {
  if(x === "npm") {
    lines.push("COPY installers/node.sh /opt/installers");
    lines.push("RUN /opt/installers/node.sh");
  } else if(x === "pip") {
    lines.push("COPY installers/python.sh /opt/installers");
    lines.push("RUN /opt/installers/python.sh");
  }
});

list.map(x => {
  if(x.type === "npm") {
    lines.push("RUN npm install -g "+x.name);
  } else if(x.type === "pip") {
    lines.push("RUN pip install "+x.name);
  }
});

process.stdout.write(lines.join("\n")+"\n");