var fs = require('fs');

require('angular').module('app', []).controller('AppController', function($scope, $http) {

  var backendUrl = "localhost:8080";

  $scope.posts = [];

  $scope.addPost = (post) => {
    $http.post(backendUrl+'/post').then(refresh);
  }

  function refresh() {
    $http.get(backendUrl+'/post').then(function(posts) {
      $scope.posts = posts;
    });
  }

});