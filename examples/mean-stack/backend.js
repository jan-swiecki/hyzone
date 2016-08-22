var MongoClient = require('mongodb').MongoClient;
var Promise = require('bluebird');
var express = require('express');

function Mongo() {
}

Mongo.prototype.init = function(callback) {
  // Connection URL
  var url = process.env.MONGO_URL;

  return new Promise((resolve,reject) => {
    MongoClient.connect(url, (err, db) => {
      if(err) {
        reject(err);
      } else {
        console.log("Connected successfully to server");
        this.db = db;
        resolve();
      }
    });
  });
};

Mongo.prototype.addPost = function(post, callback) {
  var collection = this.db.collection('posts');
  
  return new Promise((resolve, reject) => {
    collection.insert(post, function(err, result) {
      if(err) {
        reject(err);
        return;
      }
      console.log("Inserted post into posts");
      resolve(result);
    });
  });
};

Mongo.prototype.getPosts = function() {
  var collection = this.db.collection('documents');

  return new Promise((resolve, reject) => {
    collection.find({}).toArray(function(err, docs) {
      if(err) {
        reject(err);
        return;
      }

      console.log("Found the following records");
      resolve(docs);
    });
  });
};

Mongo.prototype.stop = function() {
  this.db.close();
};

var mongo = new Mongo();

mongo.init().then(() => {
  var app = express();
  console.log(123);
  app.post('/post', function(req, res) {
    mongo.addPost(req.body)
      .then(() => res.send(201, "Created"))
      .catch(toError(res));
  });
  
  app.get('/post', function(req, res) {
    mongo.getPosts()
      .then((posts) => res.send(200, posts))
      .catch(toError(res));
  });

  var port = process.env.BACKEND_PORT;
  app.listen(port, function () {
    console.log('Example app listening on port '+port+'!');
  });

  function toError(res) {
    return (err) => res.send(500, "Error: "+JSON.stringify(err));
  }
});

