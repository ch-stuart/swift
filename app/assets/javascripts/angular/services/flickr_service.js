SwiftApp.service('FlickrService', ['$http', function($http) {

    return {
        photo: function(id, label) {
            return $http.get('/flickr/photo/' + id + '/' + label);
        }
    };

}]);
